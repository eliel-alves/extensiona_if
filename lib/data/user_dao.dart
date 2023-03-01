import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDAO extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User? usuario;
  bool? isLoading = true;
  UserCredential? user;

  late String userType;

  // Verifica se o usuário está logado
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  // Pega o ID do usuário
  userId() {
    return auth.currentUser?.uid;
  }

  // Pega o email do usuário
  userEmail() {
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

    var userInfo = Users.fromJson(userRef.data()!);

    return userInfo.userCity;
  }

  UserDAO() {
    _authCheck();
  }

  // Pegar o atual usuário logado
  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }

  // Observador do status de autenticação do usuário
  _authCheck() {
    auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  //Faz referência a coleção de usuário no Firebase
  final usersRef =
      FirebaseFirestore.instance.collection('USUARIOS').withConverter<Users>(
            fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
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
      debugPrint('$e');
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
      debugPrint('$e');
    }
  }

  // Método responsável por adicionar um novo usuário na coleção USUARIOS
  void addUser(String email, String password, String userName, String userPhone,
      String state, String city) async {
    //Adicionando um novo usuario a nossa coleção -> Usuários
    await usersRef.doc(userId()).set(
          Users(
              userId: userId(),
              email: userEmail()!,
              tipo: 'user',
              userName: userName,
              userPhone: userPhone,
              userPhoto: '',
              userState: state,
              userCity: city,
              nomeArquivoFoto: ''),
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
      final user = auth.currentUser!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: userEmail()!, password: password);

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
