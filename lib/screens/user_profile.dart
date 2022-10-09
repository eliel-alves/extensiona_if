import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/theme/app_theme.dart';

class MyProfile extends StatefulWidget {
  final String userId;
  final String email;
  final String tipo;
  final String userName;
  final String userPhone;
  final String userPhoto;
  final String userState;
  final String userCity;

  const MyProfile(
      {Key key,
      this.userId,
      this.email,
      this.tipo,
      this.userName,
      this.userPhone,
      this.userPhoto,
      this.userState,
      this.userCity})
      : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações pessoais'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Informações básicas', style: AppTheme.typo.title),
          const SizedBox(height: 10),
          Options('Nome', widget.userName, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarInfoUsuario(
                      titulo: 'Nome',
                      conteudo: widget.userName,
                      rotulo: 'Nome',
                      dica: 'Informe o seu nome',
                      errorText: 'Informe um nome',
                      icon: const Icon(Icons.person_outline),
                      qtdCaracteres: 20,
                      maskField: false)),
            );
          }),
          Options(
              'Localidade', '${widget.userCity}/${widget.userState}', () {}),
          const SizedBox(height: 10),
          Text('Informações de contato', style: AppTheme.typo.title),
          const SizedBox(height: 10),
          Options('E-mail', widget.email, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarInfoUsuario(
                      titulo: 'E-mail',
                      conteudo: widget.email,
                      rotulo: 'E-mail',
                      dica: 'Informe seu email',
                      errorText: 'Informe um e-mail',
                      icon: const Icon(Icons.mail_outlined),
                      qtdCaracteres: 30,
                      maskField: false)),
            );
          }),
          Options('Telefone', widget.userPhone, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarInfoUsuario(
                      titulo: 'Telefone',
                      conteudo: widget.userPhone,
                      rotulo: 'Telefone',
                      dica: 'Informe o seu telefone',
                      errorText: 'Informe um telefone',
                      icon: const Icon(Icons.phone_outlined),
                      qtdCaracteres: 20,
                      maskField: true)),
            );
          }),
        ]),
      ),
    );
  }
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

  const EditarInfoUsuario(
      {Key key,
      this.titulo,
      this.conteudo,
      this.rotulo,
      this.dica,
      this.errorText,
      this.icon,
      this.qtdCaracteres,
      this.maskField})
      : super(key: key);

  @override
  State<EditarInfoUsuario> createState() => _EditarInfoUsuarioState();
}

class _EditarInfoUsuarioState extends State<EditarInfoUsuario> {
  final TextEditingController _controlador = TextEditingController();

  bool editandoInfo = false;

  @override
  void initState() {
    setState(() {
      _controlador.text = widget.conteudo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, style: AppTheme.typo.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            !editandoInfo
                ? Card(
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
                : Column(
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
                              onPressed: () {
                                if (_controlador.text.isNotEmpty) {
                                  debugPrint('editou a informação');
                                }
                              },
                              child: const Text('Salvar'))
                        ],
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
