import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class UserDAO extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User usuario;
  bool isLoading = true;

  String errorMessage;
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
      String state, String city, BuildContext context) async {
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
      // Possíveis erros
      if (e.code == 'weak-password') {
        // throw AuthException('A senha é muito fraca!');
        errorMessage = 'A senha é muito fraca!';
      } else if (e.code == 'email-already-in-use') {
        //throw AuthException('Este email já foi cadastrado');
        errorMessage = 'Este email já foi cadastrado';
      }

      // Mostrando o erro pro usuário
      //Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.BOTTOM);
      //SnackBar
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      debugPrint(e);
    }
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

  // Logar o usuário
  void login(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _getUser();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        //throw AuthException('Senha incorreta. Tente novamente');
        errorMessage = 'Senha incorreta. Tente novamente';
      } else if (e.code == 'user-not-found') {
        //throw AuthException('Email não encontrado. Cadastre-se');
        errorMessage = 'Email não encontrado. Cadastre-se';
      }

      //Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.SNACKBAR);
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      debugPrint(e);
    }
  }

  // Logou do usuário
  void logout() async {
    await auth.signOut();
    notifyListeners();
    _getUser();
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    await auth.sendPasswordResetEmail(email: email).then((value) {
      String message =
          'Pronto! Um link para criação de uma nova senha foi enviado para seu e-mail.';
      debugPrint(message);

      SnackBar snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  /*//
  Future<void> checkUser(String userID) async {
    // Pega o documento que possui em seu campo id o valor do id do usuário logado
    final userId = await usersRef.where('id', isEqualTo: userID).get().then((value) => value.docs);

    //Laço que retorna o tipo de usuário(admin ou user)
    for (var element in userId) {
      userType = element.data().tipo;
    }
  }*/

  // TODO: Sing In with Google
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        auth.currentUser?.photoURL;

        addUser(userEmail(), null, auth.currentUser?.displayName,
            auth.currentUser?.phoneNumber);
        usuario = userCredential.user;
        _getUser();
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          addUser(userEmail(), null, auth.currentUser?.displayName,
              auth.currentUser?.phoneNumber);

          usuario = userCredential.user;
          _getUser();
          notifyListeners();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return usuario;
  }

  // Login com Facebook
  void signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      //final userData = await FacebookAuth.instance.getUserData();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);
      await auth.signInWithCredential(facebookAuthCredential);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('erro de autentificação');
      }
    }
  }
}
