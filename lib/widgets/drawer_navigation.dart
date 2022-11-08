import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/auth_check.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget drawerNavigation(context) {
  UserDAO authService = Provider.of<UserDAO>(context);

  return Drawer(
    backgroundColor: AppTheme.colors.lightGrey,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: AppTheme.colors.dark,
          ),
          child: SvgPicture.asset(
            'lib/assets/svg/extensiona-logo-light.svg',
            width: 200
          ),
        ),
        ListTileOptions(
            icone: Icons.home_outlined,
            title: 'Página Inicial',
            onTap: () {
              Navigator.pushNamed(context, '/');
            }),
        ListTileOptions(
            icone: Icons.assignment_outlined,
            title: 'Nova Proposta',
            onTap: () async {
              var userRef = await FirebaseFirestore.instance
                  .collection('USUARIOS')
                  .doc(authService.userId())
                  .get();

              var userInfo = Users.fromJson(userRef.data());

              Navigator.pushNamed(context, '/formDemanda',
                  arguments: Demandas(editarDemanda: false, usuario: userInfo));
            }),
        ListTileOptions(
            icone: Icons.list_alt_rounded,
            title: 'Minhas Propostas',
            onTap: () {
              Navigator.pushNamed(context, '/listaDemanda');
            }),
        ListTileOptions(
            icone: Icons.account_circle_outlined,
            title: 'Meu Perfil',
            onTap: () async {
              var userRef = await FirebaseFirestore.instance
                  .collection('USUARIOS')
                  .doc(authService.userId())
                  .get();

              var userInfo = Users.fromJson(userRef.data());

              Navigator.pushNamed(context, '/profile',
                  arguments: userInfo.userId);
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Divider(
            color: AppTheme.colors.grey,
            height: 10,
            thickness: 2,
          ),
        ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageAuthState()));
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
