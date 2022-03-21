import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/homepage_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:extensiona_if/screens/homepage.dart';
import 'package:extensiona_if/screens/login.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserDAO(),
        child: ExtensionaApp(),
      )
    ],
    child: ExtensionaApp()
  ));
}

class ExtensionaApp extends StatelessWidget {
  ExtensionaApp({Key key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexColorScheme.light(scheme: FlexScheme.green).toTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("You have an error!");
            return const Text('Algo não deu certo!');
          } else if (snapshot.hasData) {
            return Consumer<UserDAO>(builder: (context, userDao, child) {
              if (userDao.isLoggedIn()) {
                //Chama a função que verifica o usuário que logou e passa o id do mesmo
                userDao.checkUser(userDao.userId());

                //Mostra o tipo de usuário logado(admin ou user)
                debugPrint(userDao.userType);

                //Verifica o tipo de usuário logado(admin ou user)
                if(userDao.userType == 'admin'){
                  debugPrint('É um admin');
                  return AdminScreen();
                } else { // Caso contrário, retornará para a página dos usuários comuns
                  debugPrint('Não é um admin');
                  return const AllUsersHomePage();
                }
              } else {
                return const Login();
              }
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
