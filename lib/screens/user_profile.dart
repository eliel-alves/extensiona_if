import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:extensiona_if/widgets/editor_city_state.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  final String userId;

  const MyProfile({Key key, this.userId}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações Pessoais', style: AppTheme.typo.title),
      ),
      drawer: drawerNavigation(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('USUARIOS')
                .doc(widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final userInfo = snapshot.data;

                    return _buildUserPage(
                        context,
                        userInfo['name'],
                        userInfo['email'],
                        userInfo['url_photo'],
                        userInfo['telefone'],
                        userInfo['id'],
                        userInfo['cidade'],
                        userInfo['estado']);
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Ocorreu algum erro ao tentar recuperar informações do usuário');
                  }
              }

              return null;
            },
          )
        ]),
      ),
    );
  }
}

Widget _buildUserPage(
  context,
  nome,
  email,
  foto,
  telefone,
  id,
  cidade,
  estado,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: foto == ''
                ? const AssetImage('lib/assets/img/user-default.jpg')
                : NetworkImage(foto),
          ),
        ],
      ),
      addVerticalSpace(30),
      Text('Informações Básicas', style: AppTheme.typo.title),
      addVerticalSpace(10),
      Options('Nome:', nome, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditarInfoUsuario(
                  titulo: 'Nome',
                  conteudo: nome,
                  rotulo: 'Nome',
                  dica: 'Informe o seu nome',
                  errorText: 'Informe um nome',
                  icon: const Icon(Icons.person_outline),
                  qtdCaracteres: 20,
                  maskField: false,
                  docId: id,
                  dbName: 'name')),
        );
      }),
      Options('Localidade:', '$cidade/$estado', () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeStateCity(
                    selectedCity: cidade, selectedState: estado, docId: id)));
      }),
      addVerticalSpace(30),
      Text('Informações de Contato', style: AppTheme.typo.title),
      const SizedBox(height: 10),
      Options('E-mail:', email, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditarInfoUsuario(
                  titulo: 'E-mail',
                  conteudo: email,
                  rotulo: 'E-mail',
                  dica: 'Informe seu email',
                  errorText: 'Informe um e-mail',
                  icon: const Icon(Icons.mail_outlined),
                  qtdCaracteres: 30,
                  maskField: false,
                  docId: id,
                  dbName: 'email')),
        );
      }),
      Options('Telefone:', telefone, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditarInfoUsuario(
                  titulo: 'Telefone',
                  conteudo: telefone,
                  rotulo: 'Telefone',
                  dica: 'Informe o seu telefone',
                  errorText: 'Informe um telefone',
                  icon: const Icon(Icons.phone_outlined),
                  qtdCaracteres: 20,
                  maskField: true,
                  docId: id,
                  dbName: 'telefone')),
        );
      }),
    ],
  );
}

class EditarInfoUsuario extends StatefulWidget {
  final String titulo;
  final String conteudo;
  final String rotulo;
  final String dica;
  final String errorText;
  final Icon icon;
  final int qtdCaracteres;
  final bool maskField;
  final String docId;
  final String dbName;

  const EditarInfoUsuario(
      {Key key,
      this.titulo,
      this.conteudo,
      this.rotulo,
      this.dica,
      this.errorText,
      this.icon,
      this.qtdCaracteres,
      this.maskField,
      this.docId,
      this.dbName})
      : super(key: key);

  @override
  State<EditarInfoUsuario> createState() => _EditarInfoUsuarioState();
}

class _EditarInfoUsuarioState extends State<EditarInfoUsuario> {
  final TextEditingController _controlador = TextEditingController();
  bool editandoInfo = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _controlador.text = widget.conteudo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDAO auth = Provider.of<UserDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, style: AppTheme.typo.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            !editandoInfo
                ? Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: AppTheme.colors.offWhite,
                        width: 2.0,
                      ),
                    ),
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.titulo, style: AppTheme.typo.title),
                          ListTile(
                            title: Text(widget.conteudo,
                                style: AppTheme.typo.defaultText),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              setState(() {
                                editandoInfo = true;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EditorAuth(
                            _controlador,
                            widget.rotulo,
                            widget.dica,
                            widget.icon,
                            widget.qtdCaracteres,
                            false,
                            widget.errorText,
                            false,
                            widget.maskField),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editandoInfo = false;
                                  });
                                },
                                child: const Text('Cancelar')),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (_controlador.text.isNotEmpty) {
                                      debugPrint('editou a informação');
                                    }

                                    final doc = await FirebaseFirestore.instance
                                        .collection('USUARIOS')
                                        .doc(widget.docId)
                                        .get();

                                    doc.reference.update(
                                        {widget.dbName: _controlador.text});

                                    if (widget.dbName == 'email') {
                                      auth.usuario
                                          .updateEmail(_controlador.text);
                                    }

                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Salvar'))
                          ],
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
