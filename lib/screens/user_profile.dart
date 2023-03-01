import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/components/edit_info_user.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:extensiona_if/widgets/editor_city_state.dart';
import 'package:extensiona_if/widgets/reauthenticate_box.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyProfile extends StatefulWidget {
  final String userId;

  const MyProfile({Key? key, required this.userId}) : super(key: key);

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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('USUARIOS')
                .doc(widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final userInfo = snapshot.data!;

              return BuildUserPage(
                  nome: userInfo['name'],
                  email: userInfo['email'],
                  foto: userInfo['url_photo'],
                  telefone: userInfo['telefone'],
                  id: userInfo['id'],
                  cidade: userInfo['cidade'],
                  estado: userInfo['estado'],
                  nomeArquivoFoto: userInfo['nome_arquivo_foto']);
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
      {super.key,
      required this.nome,
      required this.email,
      required this.foto,
      required this.telefone,
      required this.id,
      required this.cidade,
      required this.estado,
      required this.nomeArquivoFoto});

  @override
  State<BuildUserPage> createState() => _BuildUserPageState();
}

class _BuildUserPageState extends State<BuildUserPage> {
  final TextEditingController _userProvidedPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Faz referência a coleção DEMANDAS no Firebase
  final demandaRef = FirebaseFirestore.instance.collection('DEMANDAS');

  //Faz referência a coleção USUARIOS no Firebase
  final userRef = FirebaseFirestore.instance.collection('USUARIOS');

  @override
  Widget build(BuildContext context) {
    UserDAO authService = Provider.of<UserDAO>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.foto.isEmpty
                  ? const AssetImage('lib/assets/img/user-default.jpg')
                  : NetworkImage(widget.foto) as ImageProvider,
            ),
          ],
        ),
        Utils.addVerticalSpace(30),
        Text('Informações Básicas', style: AppTheme.typo.title),
        Utils.addVerticalSpace(10),
        Options(
            subtitle: widget.nome,
            editImage: false,
            onTap: () => Navigator.push(
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
                          validator: true,
                          docId: widget.id,
                          dbName: 'name')),
                ),
            isDeleteAccountOption: false,
            title: 'Nome:'),
        Options(
            subtitle: '${widget.cidade}/${widget.estado}',
            editImage: false,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeStateCity(
                        selectedCity: widget.cidade,
                        selectedState: widget.estado,
                        docId: widget.id))),
            isDeleteAccountOption: false,
            title: 'Localidade:'),
        Options(
            subtitle: 'Selecionar uma foto',
            editImage: true,
            onTap: () => selecionarFoto(widget.id, widget.nomeArquivoFoto),
            isDeleteAccountOption: false,
            title: 'Foto:'),
        Utils.addVerticalSpace(30),
        Text('Informações de Contato', style: AppTheme.typo.title),
        Utils.addVerticalSpace(10),
        Options(
            subtitle: widget.email,
            editImage: false,
            onTap: () => reauthenticateBox(
                context: context,
                controller: _userProvidedPassword,
                title: 'Atualizar E-mail',
                label: widget.email,
                formKey: _formKey,
                action: () {
                  if (_formKey.currentState!.validate()) {
                    authService.reauthenticateUser(
                        _userProvidedPassword.text,
                        context,
                        () => Navigator.push(
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
                                      validator: true,
                                      docId: widget.id,
                                      dbName: 'email')),
                            ));
                    _userProvidedPassword.clear();
                  }
                }),
            isDeleteAccountOption: false,
            title: 'E-mail:'),
        Options(
            subtitle: widget.telefone,
            editImage: false,
            onTap: () => Navigator.push(
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
                          validator: true,
                          docId: widget.id,
                          dbName: 'telefone')),
                ),
            isDeleteAccountOption: false,
            title: 'Telefone:'),
        Utils.addVerticalSpace(30),
        Text('Mais opções', style: AppTheme.typo.title),
        Utils.addVerticalSpace(10),
        Options(
            subtitle: 'Excluir sua conta',
            editImage: false,
            onTap: () => reauthenticateBox(
                context: context,
                controller: _userProvidedPassword,
                title: 'Deletar conta',
                label: widget.email,
                formKey: _formKey,
                action: () {
                  if (_formKey.currentState!.validate()) {
                    authService.reauthenticateUser(
                        _userProvidedPassword.text,
                        context,
                        () => confirmBox(context, authService.userId(),
                            authService.usuario!));

                    _userProvidedPassword.clear();
                  }
                }),
            isDeleteAccountOption: true)
      ],
    );
  }

  confirmBox(BuildContext context, String userId, User usuario) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Confirmação',
              textAlign: TextAlign.start,
            ),
            content: const Text('Tem certeza que deseja excluir sua conta?'),
            backgroundColor: AppTheme.colors.lightGrey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () => deleteAccount(context, userId, usuario),
                child: const Text('DELETAR'),
              )
            ],
          );
        });
  }

  deleteAccount(BuildContext context, String userId, User usuario) async {
    //Referências das coleções do banco de dados
    final demanda = await demandaRef.where("usuario", isEqualTo: userId).get();

    final user = await userRef.where("id", isEqualTo: userId).get();

    //Deletando todos os dados do usuário
    for (var demandaDocs in demanda.docs) {
      //Referência a subcoleção dos documentos deste usuário
      var subcollectionRef =
          await demandaRef.doc(demandaDocs.id).collection('arquivos').get();

      //Acessa as informações das subcoleções das demandas do usuário
      for (var subCollection in subcollectionRef.docs) {
        // Referência do arquivo a ser deletado no firebase_storage
        final storageFilesRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("arquivos/${subCollection.get('file_name_storage')}");

        // Deleta os arquivos
        await storageFilesRef.delete();

        //Deleta a subcoleção
        await subCollection.reference.delete();
      }

      // Deleta a demanda
      await demandaDocs.reference.delete();
    }

    for (var userDocs in user.docs) {
      final storagePhotoRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("foto_perfil/${userDocs.get('nome_arquivo_foto')}");

      // Deleta os arquivos de imagem
      await storagePhotoRef.delete();

      // Deleta os dados pessoais do usuário
      await userDocs.reference.delete();
    }

    //Deletando a conta do usuário
    await usuario.delete();

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/');
  }

  void selecionarFoto(String docId, String nomeArquivo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg'],
        allowMultiple: false);

    if (result == null) return;

    String nomeFoto =
        '${result.files.first.name}_$docId.${result.files.first.extension}';

    if (kIsWeb) {
      final fileBytes = result.files.first.bytes;
      uploadImageFile(fileBytes!, nomeFoto, nomeArquivo, docId);
    } else {
      final filePath = result.files.first.path;
      uploadImageFile(
          await File(filePath!).readAsBytes(), nomeFoto, nomeArquivo, docId);
    }
  }

  void uploadImageFile(Uint8List data, String nomeFoto, String nomeRefArquivo,
      String docId) async {
    final docRef = await FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(docId)
        .get();

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('foto_perfil/$nomeFoto');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(data);

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
