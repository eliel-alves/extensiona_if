import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/screens/auth/auth_page.dart';
import 'package:extensiona_if/screens/demanda_form.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:extensiona_if/screens/homepage_admin.dart';
import 'package:extensiona_if/screens/homepage_super_admin.dart';

import 'package:extensiona_if/screens/user_profile.dart';
import 'package:extensiona_if/widgets/auth_check.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ManageAuthState());
      case '/login':
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case '/formDemanda':
        DemandaArguments argument = settings.arguments as DemandaArguments;
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
                usuario: argument.usuario));
      case '/listaDemanda':
        return MaterialPageRoute(builder: (_) => const ListaDemanda());
      case '/adminListaDemanda':
        final argument = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AdminScreen(tipoUsuario: argument));
      case '/usersList':
        return MaterialPageRoute(builder: (_) => const SuperAdminScreen());
      case '/profile':
        final argument = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MyProfile(userId: argument));

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
