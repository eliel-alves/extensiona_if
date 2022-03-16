import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  void signup(String email, String password, String userName, String userPhone) async {
    // Tenta cadastrar o usuário
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      addUser(email, password, userName, userPhone);
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

  // Método responsável por adicionar um novo usuário na coleção USUARIOS
  void addUser(String email, String password, String userName, String userPhone) async {
    //Adicionando um novo usuario a nossa coleção -> Usuários
    DocumentReference _novoUsuario = await FirebaseFirestore.instance.collection('USUARIOS').add({
      'id': userId(),
      'email': userEmail(),
      'telefone': userPhone,
      'name': userName,
      'tipo': 'user',
      'url_photo': '',
    })
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar o usuário: $error"));
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

  // TODO: Sing In with Google
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        usuario = userCredential.user;
        _getUser();
        notifyListeners();
      } catch (e) {
        print(e);
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






