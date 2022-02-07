import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDAO extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User usuario;
  String errorMessage;
  UserCredential user;


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
    //return auth.currentUser?.photoURL;
  }

  // Pegar usuário atual logado
  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }


  // Cadastrar no app
  void signup(String email, String password) async {
    // Tenta cadastrar o usuário
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      _getUser();
    } on FirebaseAuthException catch (e) { // Possíveis erros
      if (e.code == 'weak-password') {
        //throw AuthException('Sua senha é muito fraca');
        errorMessage = 'Sua senha é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        //throw AuthException('Este email já está cadastrado');
        errorMessage = 'Este email já está cadastrado';
      }

      // Mostrando o erro pro usuário
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.BOTTOM);
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
      if (e.code == 'wrong-password') {
        //throw AuthException('Senha incorreta. Tente novamente');
        errorMessage = 'Senha incorreta. Tente novamente';
      } else if (e.code == 'user-not-found') {
        //throw AuthException('Email não encontrado. Cadastre-se');
        errorMessage = 'Email não encontrado. Cadastre-se';
      }

      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.SNACKBAR);
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


  // Login com o Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await auth.signInWithCredential(credential).then((userCredential) => {
        user = userCredential
    });
    //return await auth.signInWithCredential(credential);
    _getUser();
    notifyListeners();
  }

  // Login com Facebook
  void signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
      await auth.signInWithCredential(facebookAuthCredential);
      notifyListeners();
    } on FirebaseAuthException catch(e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('erro de autentificação');
      }
    }
  }
}






