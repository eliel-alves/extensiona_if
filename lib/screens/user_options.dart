import 'package:extensiona_if/data/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/screens/user_profile.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:provider/provider.dart';


class MoreOptions extends StatelessWidget {

  MoreOptions({Key key, this.userDao}) : super(key: key);

  final styleTextTitle = const TextStyle(fontSize: 23, fontWeight: FontWeight.bold);

  UserDAO userDao;

  @override
  Widget build(BuildContext context) {
    userDao = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Image.asset(
          'lib/assets/img/logo.png',
          width: 240,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
          'Mais Serviços',
          style: GoogleFonts.quicksand(textStyle: styleTextTitle),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Options(Icons.person_pin_rounded, 'Meu Perfil', 'Visualize seus dados cadastrados', () {
                    debugPrint('Meus dados');
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MyProfile();
                    }));
                  },
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 10),

                  Options(Icons.feedback_outlined , 'Retornos', 'Visualize atualizações sobre a sua demanda', () {
                    debugPrint("Página retorno");
                  },
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 10),

                  Options(Icons.list , 'Minhas Demandas', 'Visualize suas demandas cadastradas', () {
                    debugPrint("Página ListaDemandas");
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ListaDemanda();
                    }));

                  },
                      Theme.of(context).colorScheme.primary
                  ),

                  const SizedBox(height: 10),

                  Options(Icons.logout, 'Sair', 'Desconectar sua conta desse aparelho', () {
                    debugPrint("Usuário saiu");
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sair'),
                            content: const Text('Tem certeza que deseja desconectar sua conta desse aparelho?'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            actions: <Widget> [
                              TextButton(
                                onPressed: (){
                                  debugPrint('O usuário saiu do app');
                                  Navigator.of(context).pop();
                                  userDao.logout();
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
                        }
                    );
                  },
                  Colors.redAccent
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class Options extends StatelessWidget {

  final IconData icone;
  final String title;
  final String subtitle;
  final Function onTap;
  final Color color;

  const Options(this.icone, this.title, this.subtitle, this.onTap, this.color, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone, size: 50, color: color),
      title: Text(title, style: GoogleFonts.quicksand(textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      subtitle: Text(subtitle, style: GoogleFonts.quicksand(textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      onTap: onTap
    );
  }

}