import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/demanda_form.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:extensiona_if/screens/login.dart';
import 'package:extensiona_if/screens/register.dart';
import 'package:extensiona_if/screens/user_options.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ManegeAuthState());
      case '/authPages':
        return MaterialPageRoute(builder: (_) => const AuthenticationPages());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterUser());
      case '/formDemanda':
        return MaterialPageRoute(builder: (_) => const FormDemanda());
      case '/listaDemanda':
        return MaterialPageRoute(builder: (_) => const ListaDemanda());
      case '/settings':
        return MaterialPageRoute(builder: (_) => MoreOptions());

      default:
      //caso não tenha o nome da rota definida no switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}