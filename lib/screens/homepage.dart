import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllUsersHomePage extends StatefulWidget {
  const AllUsersHomePage({Key key}) : super(key: key);

  @override
  State<AllUsersHomePage> createState() => _AllUsersHomePageState();
}

class _AllUsersHomePageState extends State<AllUsersHomePage> {
  @override
  Widget build(BuildContext context) {
    UserDAO authService = Provider.of<UserDAO>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: AppTheme.colors.dark,
        appBar: AppBar(
          title: Text('extensiona', style: AppTheme.typo.title),
          backgroundColor: AppTheme.colors.dark,
          elevation: 0,
        ),
        drawer: drawerNavigation(context),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: width > 1200
                  ? 4
                  : width > 800
                      ? 3
                      : 2,
              childAspectRatio: width > 900 ? 1.4 : 0.75,
              children: [
                _buildCard(
                    'Criar Proposta',
                    'Preencha o formulário para sugerir um novo projeto de extensão.',
                    'notepad.png', () async {
                  var userRef = await FirebaseFirestore.instance
                      .collection('USUARIOS')
                      .doc(authService.userId())
                      .get();

                  var userInfo = Users.fromJson(userRef.data());

                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/formDemanda',
                      arguments: DemandaArguments(
                          editarDemanda: false, usuario: userInfo));
                }),
                _buildCard(
                    'Minhas Propostas',
                    'Gerencie todas as suas propostas enviadas.',
                    'pie-chart.png', () {
                  Navigator.pushNamed(context, '/listaDemanda');
                }),
                _buildCard(
                    'Meu Perfil',
                    'Gerencie o seu perfil, altere informações da sua conta.',
                    'profile.png', () async {
                  var userRef = await FirebaseFirestore.instance
                      .collection('USUARIOS')
                      .doc(authService.userId())
                      .get();

                  var userInfo = Users.fromJson(userRef.data());

                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/profile',
                      arguments: userInfo.userId);
                }),
                _buildCard(
                  'Áreas de Conhecimento',
                  'Veja a lista oficial do Lattes contendo todas as áreas de conhecimento disponíveis.',
                  'check-list.png',
                  () {
                    _linkAreasConhecimento();
                  },
                ),
              ]),
        ));
  }

  Widget _buildCard(
      String titulo, String descricao, String icone, Function pagina) {
    final TextStyle title = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Inter',
        color: AppTheme.colors.dark);

    final TextStyle subtitle = TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        fontFamily: 'Inter',
        color: AppTheme.colors.greyText);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: pagina,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/img/$icone', width: 50),
              Utils.addVerticalSpace(20),
              Text(titulo, style: title, textAlign: TextAlign.center),
              Utils.addVerticalSpace(10),
              Text(descricao, style: subtitle, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _linkAreasConhecimento() async {
  final Uri url = Uri.parse(
      'http://lattes.cnpq.br/documents/11871/24930/TabeladeAreasdoConhecimento.pdf/d192ff6b-3e0a-4074-a74d-c280521bd5f7');

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Não foi possível abrir o link: $url';
  }
}
