import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/homepage.dart';
import 'package:extensiona_if/screens/homepage_admin.dart';
import 'package:extensiona_if/screens/login.dart';
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
      return const LoginScreen();
    } else {
      return const RoleBasedUI();
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
    // if (snapshot.data == null) {
    //   return const Center(
    //     child: Text('Usuário não encontrado'),
    //   );
    // }
    if (snapshot.get('tipo') == 'admin') {
      return const AdminScreen();
    } else {
      return const AllUsersHomePage();
    }
  }
}
