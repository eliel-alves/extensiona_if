import 'package:flutter/material.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/user_options.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {

  UserDAO userDao;

  MyProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userDao = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[700],
                    child: Image.network(
                      userDao.photoURL(),
                      width: 100,
                      height: 100,
                    ),
                  )
              ),
            ],
          ),

          Options(Icons.email, 'Email', userDao.userEmail(), () {debugPrint('user email');}, Theme.of(context).colorScheme.primary)

        ]
      ),
    );
  }

}