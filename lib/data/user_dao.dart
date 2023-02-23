import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserDAO extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User usuario;
  bool isLoading = true;

  UserCredential user;

  String userType;

  // Verifica se o usuário está logado
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  // Pega o ID do usuário
  String userId() {
    return auth.currentUser?.uid;
  }

  // Pega o email do Usuario
  String userEmail() {
    return auth.currentUser?.email;
  }

  // ImgUsuario.src = user.photoURL ? user.photoURL : 'IMGs/usuarioIMG.png'
  String photoURL() {
    return auth.currentUser?.photoURL ?? 'lib/assets/img/logo_user.png';
  }

  Future<String> userLocation() async {
    var userRef = await FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(userId())
        .get();

    var userInfo = Users.fromJson(userRef.data());

    return userInfo.userCity;
  }

  UserDAO() {
    _authCheck();
  }

  // Pegar usuário atual logado
  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }

  // Observador do status de autenticação do usuário
  _authCheck() {
    auth.authStateChanges().listen((User user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  Stream<User> get authState => auth.authStateChanges();

  //Faz referência a coleção de usuário no Firebase
  final usersRef =
      FirebaseFirestore.instance.collection('USUARIOS').withConverter<Users>(
            fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()),
            toFirestore: (user, _) => user.toJson(),
          );

  // Cadastrar no app
  void signup(String email, String password, String userName, String userPhone,
      String state, String city) async {
    // Tenta cadastrar o usuário
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      addUser(email, password, userName, userPhone, state, city);
      notifyListeners();
      _getUser();
    } on FirebaseAuthException catch (e) {
      handleAuthError(e);
    } catch (e) {
      debugPrint(e);
    }
  }

  // Logar o usuário
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _getUser();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      handleAuthError(e);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> deleteUser(
      String email, String password, BuildContext context) async {
    try {
      final user = auth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email, password: password);

      final result = await user
          .reauthenticateWithCredential(credential)
          .catchError((error) {
        Navigator.of(context).pop(true);

        Utils.schowSnackBar(
            'Credenciais incorretas. Por favor, verifique-as e tente novamente.');
      });

      if (kDebugMode) {
        print(user);
      }
      // ignore: use_build_context_synchronously
      await deleteUserData(result.user.uid, context);
      await result.user.delete();
    } catch (error) {
      debugPrint(error);
      debugPrint('Erro na deleção da conta do usuário !!!');
    }
  }

  Future<void> deleteUserData(String uid, BuildContext context) async {
    final userCollection =
        await FirebaseFirestore.instance.collection('USUARIOS').doc(uid).get();

    final userDemandas = await FirebaseFirestore.instance
        .collection('DEMANDAS')
        .where('usuario', isEqualTo: uid)
        .get();

    //Acessa as informações das demandas do usuário
    for (var uDemanda in userDemandas.docs) {
      //Referência a subcoleção dos documentos deste usuário
      var subcollectionRef = await FirebaseFirestore.instance
          .collection('DEMANDAS')
          .doc(uDemanda.id)
          .collection('arquivos')
          .get();

      //Acessa as informações das subcoleções das demandas do usuário
      for (var subCollection in subcollectionRef.docs) {
        // Referência do arquivo a ser deletado no firebase_storage
        final storageFilesRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("arquivos/${subCollection.get('file_name_storage')}");

        final storagePhotoRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("foto_perfil/${userCollection.get('nome_arquivo_foto')}");

        // Deleta o arquivo
        await storageFilesRef.delete();

        await storagePhotoRef.delete();

        //Deleta a subcoleção
        subCollection.reference
            .delete()
            .then((value) => debugPrint('Subcoleção deletada !!!'))
            .catchError((error) {
          // ignore: prefer_interpolation_to_compose_strings
          debugPrint('Erro ao deletar a subcoleção: ' + error);
        });
      }

      //Deleta as demandas do usuário
      uDemanda.reference
          .delete()
          .then((value) => debugPrint("Demanda deletada !!!"))
          .catchError((error) =>
              // ignore: prefer_interpolation_to_compose_strings
              debugPrint("Erro ao deletar a demanda do usuário: " + error));
    }

    //Deleta a coleção referente ao usuário
    userCollection.reference
        .delete()
        .then((value) => debugPrint('Coleção do usuário deletada !!!'))
        .catchError((error) {
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint('Erro ao deletar a coleção do usuário: ' + error);
    });

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/');
  }

  // Método responsável por adicionar um novo usuário na coleção USUARIOS
  void addUser(
      [String email,
      String password,
      String userName,
      String userPhone,
      String state,
      String city]) async {
    //Adicionando um novo usuario a nossa coleção -> Usuários
    await usersRef.doc(userId()).set(
          Users(userId(), userEmail(), 'user', userName, userPhone, '', state,
              city, ''),
        );
  }

  // Logou do usuário
  void logout() async {
    await auth.signOut();
    notifyListeners();
    _getUser();
  }

  Future<void> reauthenticateUser(
      String password, BuildContext context, Function action) async {
    try {
      final user = auth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: userEmail(), password: password);

      await user.reauthenticateWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
      action();
    } catch (error) {
      debugPrint('$error');
      Navigator.of(context).pop(true);

      Utils.schowSnackBar(
          'Credenciais incorretas. Por favor, verifique-as e tente novamente.');
      debugPrint('Erro na reautenticação do usuário !!!');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      String message =
          'Pronto! Um link para criação de uma nova senha foi enviado para o seu e-mail.';
      debugPrint(message);

      //SNACKBAR
      Utils.schowSnackBar(message);
    } catch (e) {
      debugPrint('$e');

      Utils.schowSnackBar('Erro no envio do e-mail!');
    }
  }

  handleAuthError(FirebaseException error) {
    switch (error.code) {
      case 'invalid-email':
        Utils.schowSnackBar('Email inválido');

        break;
      case 'user-not-found':
        Utils.schowSnackBar('Usuário não encontrado');
        break;
      case 'wrong-password':
        Utils.schowSnackBar('Senha incorreta');
        break;
      case 'email-already-in-use':
        Utils.schowSnackBar('Este email já está sendo usado por outro usuário');
        break;
      case 'weak-password':
        Utils.schowSnackBar('A senha precisa ter no mínimo 6 caracteres');
        break;
      default:
        Utils.schowSnackBar('Erro desconhecido');
        break;
    }
  }

  // Future<void> signInWithGoogle() async {
  //   if (kIsWeb) {
  //     GoogleAuthProvider authProvider = GoogleAuthProvider();

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithPopup(authProvider);

  //       auth.currentUser?.photoURL;

  //       addUser(userEmail(), null, auth.currentUser?.displayName,
  //           auth.currentUser?.phoneNumber);
  //       usuario = userCredential.user;
  //       _getUser();
  //       notifyListeners();
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   } else {
  //     final GoogleSignIn googleSignIn = GoogleSignIn();

  //     final GoogleSignInAccount googleSignInAccount =
  //         await googleSignIn.signIn();

  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );

  //       try {
  //         final UserCredential userCredential =
  //             await auth.signInWithCredential(credential);

  //         addUser(userEmail(), null, auth.currentUser?.displayName,
  //             auth.currentUser?.phoneNumber);

  //         usuario = userCredential.user;
  //         _getUser();
  //         notifyListeners();
  //       } on FirebaseAuthException catch (e) {
  //         if (e.code == 'account-exists-with-different-credential') {
  //           // ...
  //         } else if (e.code == 'invalid-credential') {
  //           // ...
  //         }
  //       } catch (e) {
  //         // ...
  //       }
  //     }
  //   }

  //   return usuario;
  // }

  // // Login com Facebook
  // void signInWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //     //final userData = await FacebookAuth.instance.getUserData();

  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken.token);
  //     await auth.signInWithCredential(facebookAuthCredential);
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'account-exists-with-different-credential') {
  //       debugPrint('erro de autentificação');
  //     }
  //   }
  // }
}
