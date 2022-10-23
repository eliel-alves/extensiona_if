import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:extensiona_if/widgets/editor_city_state.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

                    return BuildUserPage(
                        nome: userInfo['name'],
                        email: userInfo['email'],
                        foto: userInfo['url_photo'],
                        telefone: userInfo['telefone'],
                        id: userInfo['id'],
                        cidade: userInfo['cidade'],
                        estado: userInfo['estado'],
                        nomeArquivoFoto: userInfo['nome_arquivo_foto']);
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

class BuildUserPage extends StatefulWidget {
  final String nome;
  final String email;
  final String foto;
  final String telefone;
  final String id;
  final String cidade;
  final String estado;
  final String nomeArquivoFoto;

  const BuildUserPage(
      {Key key,
      this.nome,
      this.email,
      this.foto,
      this.telefone,
      this.id,
      this.cidade,
      this.estado,
      this.nomeArquivoFoto})
      : super(key: key);

  @override
  State<BuildUserPage> createState() => _BuildUserPageState();
}

class _BuildUserPageState extends State<BuildUserPage> {
  //Converte String para Uint8List
  bytes() {
    List<int> list = widget.foto.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    debugPrint('$bytes');
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.foto == ''
                  ? const AssetImage('lib/assets/img/user-default.jpg')
                  : NetworkImage(widget.foto),
            ),
          ],
        ),
        addVerticalSpace(30),
        Text('Informações Básicas', style: AppTheme.typo.title),
        addVerticalSpace(10),
        Options('Nome:', widget.nome, false, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarInfoUsuario(
                    titulo: 'Nome',
                    conteudo: widget.nome,
                    rotulo: 'Nome',
                    dica: 'Informe o seu nome',
                    errorText: 'Informe um nome',
                    icon: const Icon(Icons.person_outline),
                    qtdCaracteres: 20,
                    maskField: false,
                    docId: widget.id,
                    dbName: 'name')),
          );
        }),
        Options('Localidade:', '${widget.cidade}/${widget.estado}', false, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeStateCity(
                      selectedCity: widget.cidade,
                      selectedState: widget.estado,
                      docId: widget.id)));
        }),
        Options('Foto:', 'Selecionar uma foto', true, () {
          selecionarFoto(widget.id, widget.nomeArquivoFoto);
        }),
        addVerticalSpace(30),
        Text('Informações de Contato', style: AppTheme.typo.title),
        const SizedBox(height: 10),
        Options('E-mail:', widget.email, false, () {
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
                    maskField: false,
                    docId: widget.id,
                    dbName: 'email')),
          );
        }),
        Options('Telefone:', widget.telefone, false, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarInfoUsuario(
                    titulo: 'Telefone',
                    conteudo: widget.telefone,
                    rotulo: 'Telefone',
                    dica: 'Informe o seu telefone',
                    errorText: 'Informe um telefone',
                    icon: const Icon(Icons.phone_outlined),
                    qtdCaracteres: 20,
                    maskField: true,
                    docId: widget.id,
                    dbName: 'telefone')),
          );
        }),
      ],
    );
  }

  void selecionarFoto(String docId, String nomeArquivo) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg'],
        allowMultiple: false);

    if (result == null) return;

    String _nomeFoto = result.files.first.name +
        '_' +
        docId +
        '.' +
        result.files.first.extension;

    if (kIsWeb) {
      final fileBytes = result.files.first.bytes;
      uploadImageFile(fileBytes, _nomeFoto, nomeArquivo, docId);
    } else {
      final filePath = result.files.first.path;
      uploadImageFile(
          await File(filePath).readAsBytes(), _nomeFoto, nomeArquivo, docId);
    }
  }

  void uploadImageFile(Uint8List _data, String nomeFoto, String nomeRefArquivo,
      String docId) async {
    final docRef = await FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(docId)
        .get();

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('foto_perfil/$nomeFoto');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (widget.foto != '') {
      // Referência do arquivo a ser deletado
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("foto_perfil/$nomeRefArquivo");

      // Deleta o arquivo
      await storageRef.delete();
    }

    docRef.reference.update({'url_photo': url, "nome_arquivo_foto": nomeFoto});
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
