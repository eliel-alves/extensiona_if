import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/widgets/auth_check.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget drawerNavigation(context) {
  UserDAO authService = Provider.of<UserDAO>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Mais Opções',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTileOptions(
            icone: Icons.assignment_rounded,
            title: 'Formulário',
            onTap: () {
              Navigator.pushNamed(context, '/formDemanda',
                  arguments: Demandas(editarDemanda: false));
            }),
        ListTileOptions(
            icone: Icons.list_alt_rounded,
            title: 'Minhas propostas',
            onTap: () {
              Navigator.pushNamed(context, '/listaDemanda');
            }),
        ListTileOptions(
            icone: Icons.account_circle_rounded,
            title: 'Meu perfil',
            onTap: () async {
              var userRef = await FirebaseFirestore.instance
                  .collection('USUARIOS')
                  .doc(authService.userId())
                  .get();

              var userInfo = Users.fromJson(userRef.data());

              Navigator.pushNamed(context, '/profile',
                  arguments: Users(
                      userInfo.userId,
                      userInfo.email,
                      userInfo.tipo,
                      userInfo.userName,
                      userInfo.userPhone,
                      userInfo.userPhoto,
                      userInfo.userState,
                      userInfo.userCity));
            }),
        ListTileOptions(
            icone: Icons.logout_rounded,
            title: 'Sair',
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sair'),
                      content: const Text(
                          'Tem certeza que deseja desconectar sua conta desse aparelho?'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            debugPrint('O usuário saiu do app');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageAuthState()));
                            authService.logout();
                          },
                          child: const Text('SIM'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCELAR'),
                        ),
                      ],
                    );
                  });
            }),
      ],
    ),
  );
}
