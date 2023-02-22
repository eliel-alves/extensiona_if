import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/auth/auth_page.dart';
import 'package:extensiona_if/screens/homepage.dart';
import 'package:extensiona_if/screens/homepage_admin.dart';
import 'package:extensiona_if/screens/homepage_super_admin.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAuthState extends StatefulWidget {
  const ManageAuthState({Key key}) : super(key: key);

  @override
  State<ManageAuthState> createState() => _ManageAuthStateState();
}

class _ManageAuthStateState extends State<ManageAuthState> {
  @override
  Widget build(BuildContext context) {
    UserDAO authService = Provider.of<UserDAO>(context);

    if (authService.isLoading) {
      return loading();
    } else if (authService.usuario == null) {
      return const AuthPage();
    } else {
      return VerifyEmailPage(email: authService.userEmail());
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({Key key, this.email}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer timer;
  Timer _timerResendEmail;
  Duration myDuration = const Duration(seconds: 60);
  int _start = 60;

  @override
  void initState() {
    super.initState();

    //O usuario deve ser criado antes
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      startTimer();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();

      //Após o envio do email, ele desabilitará por 60 segundos o botão de reenvio de email
      setState(() => canResendEmail = false);
      //setState(() => _start = 60);
      await Future.delayed(myDuration);
      //setState(() => _start = 0);
      setState(() => canResendEmail = true);
    } catch (error) {
      Utils.schowSnackBar(
          'Houve um erro no envio do link de verificação do email do usuário ');

      debugPrint(error);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timerResendEmail = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _timerResendEmail?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    //É chamado quando o email é verificado
    await FirebaseAuth.instance.currentUser.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const RoleBasedUI()
      : VerifyEmailContent(
          start: _start,
          userEmail: widget.email,
          onPressed: canResendEmail
              ? () {
                  setState(() {
                    _start = 60;
                    startTimer();
                  });
                  sendVerificationEmail();
                }
              : null,
          onPressedCancel: () => FirebaseAuth.instance.signOut());
}

class RoleBasedUI extends StatelessWidget {
  const RoleBasedUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDAO authService = Provider.of<UserDAO>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: authService.usersRef.doc(authService.userId()).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return checkRole(snapshot.data);
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.get('tipo') == 'super_admin') {
      return const SuperAdminScreen();
    } else if (snapshot.get('tipo') == 'admin') {
      return const AdminScreen();
    } else {
      return const AllUsersHomePage();
    }
  }
}
