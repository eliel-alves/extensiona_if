import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:flutter/material.dart';

class AllUsersHomePage extends StatefulWidget {
  const AllUsersHomePage({Key key}) : super(key: key);

  @override
  State<AllUsersHomePage> createState() => _AllUsersHomePageState();
}

class _AllUsersHomePageState extends State<AllUsersHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extensiona IF'),
      ),
      drawer: drawerNavigation(context)
    );
  }
}
