import 'package:flutter/material.dart';
import 'package:extensiona_if/Screens/demanda_form.dart';
import 'package:extensiona_if/Screens/user_options.dart';


class AllUsersHomePage extends StatefulWidget{
  const AllUsersHomePage({Key key}) : super(key: key);

  @override
  State<AllUsersHomePage> createState() => _AllUsersHomePageState();
}

class _AllUsersHomePageState extends State<AllUsersHomePage> {

  int paginaAtual = 0;
  PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          FormDemanda(),
          MoreOptions(),
        ],
        onPageChanged: setPaginaAtual,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
          items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Formulário'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'Mais')
          ],
          onTap: (pagina) {
          pc.animateToPage(pagina, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    },
        backgroundColor: Colors.grey[200],
      ),
    );
    throw UnimplementedError();
  }
}
