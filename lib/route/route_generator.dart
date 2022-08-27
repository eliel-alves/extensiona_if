import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/screens/demanda_form.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:extensiona_if/screens/login.dart';
import 'package:extensiona_if/screens/register.dart';
import 'package:extensiona_if/screens/user_profile.dart';
import 'package:extensiona_if/widgets/auth_check.dart';
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
        Demandas argument = settings.arguments as Demandas;
        return MaterialPageRoute(
            builder: (_) => FormDemanda(
                  titulo: argument.titulo,
                  tempo: argument.tempo,
                  resumo: argument.resumo,
                  objetivo: argument.objetivo,
                  contrapartida: argument.contrapartida,
                  vinculo: argument.vinculo,
                  resultadosEsperados: argument.resultadosEsperados,
                  propostaConjunto: argument.propostaConjunto,
                  dadosProponente: argument.dadosProponente,
                  empresaEnvolvida: argument.empresaEnvolvida,
                  equipeColaboradores: argument.equipeColaboradores,
                  areaTematica: argument.areaTematica,
                  docId: argument.docId,
                  editarDemanda: argument.editarDemanda,
                ));
      case '/listaDemanda':
        return MaterialPageRoute(builder: (_) => const ListaDemanda());
      case '/profile':
        return MaterialPageRoute(builder: (_) => MyProfile());

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
