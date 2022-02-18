import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;

class FormDemanda extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FormDemandaState();
  }

}

class FormDemandaState extends State<FormDemanda>{

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorVinculo = TextEditingController();
  final TextEditingController _controladorResultadosEsperados = TextEditingController();

  final List<String> buttonOptions = [
    'Comunicação',
    'Cultura',
    'Direitos Humanos e Justiça',
    'Educação',
    'Meio Ambiente',
    'Saúde',
    'Tecnologia e Produção',
    ' Trabalho'
  ];

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  final styleTextFile = const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  FilePickerResult result;
  PlatformFile name;

  String areaTematicaSelecionada;
  DocumentSnapshot areaTematicaAtual;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Selecione a área temática';

  bool _valida = false;

  @override
  Widget build(BuildContext context) {

    final fileName = name != null ? basename(name.name) : 'Nenhum aquivo selecionado...';

    // Recupera a coleção
    final Stream<QuerySnapshot> colecaoAreasTematicas = FirebaseFirestore.instance.collection('AREAS_TEMATICAS').snapshots();
    //CollectionReference colecaoAreasTematicas = FirebaseFirestore.instance.collection('AREAS_TEMATICAS');

    return Scaffold(
      appBar: AppBar(
          title: const Text('Formulário de Cadastro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Editor(_controladorTitulo, "Título da proposta", "Título da Proposta", 1, _valida, 150),

            Editor(_controladorTempoNecessario, "Informe o tempo necessário", "Número de meses para ser realizada", 1, _valida, 150),

            Editor(_controladorResumo, "Faça uma breve descrição da sua proposta",
                "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, _valida, 600),

            Editor(_controladorObjetivo, "Descreva os objetivos que você espera serem atendidos",
                "Coloque em forma de tópicos os objetivos da proposta", 5, _valida, 600),

            Editor(_controladorContrapartida, "Quais recursos a equipe dispõe para a execução da proposta?",
                "Descreva quais recursos estão disponíveis para a execução da proposta, financeiros, humanos, estrutura, etc", 5, _valida, 600),

            Editor(_controladorVinculo, "Qual o seu vínculo com o projeto?",
                "Descreva qual o seu vínculo com a entidade parceira envolvida com este projeto", 1, _valida, 100),

            Editor(_controladorResultadosEsperados, "Quais os resultados esperados?  ",
                "Descreva os resultados esperados", 5, false, 600),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                        style: GoogleFonts.cabin(textStyle: style),
                    ),
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<QuerySnapshot>(
                    stream: colecaoAreasTematicas,
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot
                        ) {
                      if (snapshot.hasError) {
                        return const Text("Carregando...");
                      } else {
                        return DropdownButtonFormField<DocumentSnapshot>(
                          hint: const Text('Selecione a área temática'),
                          items: snapshot.data.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                            return DropdownMenuItem<DocumentSnapshot>(
                                value: document,
                                child:Text(
                                  data['nome'],
                                ),
                            );
                          }).toList(),
                        );
                      }
                  }),

                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //     border: const OutlineInputBorder(),
                  //     helperText: 'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                  //     hintText: hintText,
                  //   ),
                  //   // items: buttonOptions.map((options) {
                  //   //   return DropdownMenuItem(
                  //   //     value: options,
                  //   //     child: Text(options),
                  //   //   );
                  //   // }).toList(),
                  //   onChanged: (value) => setState(() => areaTematicaSelecionada = value),
                  // ),
                ],
              ),
            ),

            CampoSelecaoArquivos(
                Icons.cloud_upload_rounded,
                'Faça o upload de arquivos ',
                'AQUI',
                    () async {
                  result = await FilePicker.platform.pickFiles(allowMultiple: false);

                  if(result != null) {
                    final file = result.files.first;
                    //Pega o nome do arquivo selecionado
                    setState(() => name = PlatformFile(name: file.name, size: file.size));
                  } else {

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
                      'Arquivo não selecionado e/ou Falha ao selecionar arquivo',
                    ),
                    ));
                  }
                },
                styleText,
                fileName,
                styleTextFile
            ),


            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.colors.blue,
                  textStyle: AppTheme.typo.button,
                ),
                onPressed: (){
                  setState((){
                    _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
                    _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
                    _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
                    _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
                    _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
                    _controladorVinculo.text.isEmpty ? _valida = true : _valida = false;
                    //optionSelected.isEmpty ? _valida = true : _valida = false;
                  });

                  // Caso não tenha erros de validação
                  if(!_valida){
                    _criarDemanda(context);
                  }
                },
                child: const Text("Criar Nova Demanda")
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _criarDemanda(BuildContext context) async {
    // Recupera o usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    //Adicionando um novo documento a nossa coleção -> Demandas
    DocumentReference _novaDemanda = await FirebaseFirestore.instance.collection('DEMANDAS').add({
      'usuario': userDao.userId(),
      'titulo': _controladorTitulo.text,
      'tempo': _controladorTempoNecessario.text,
      'data': DateTime.now(),
      'status': 'registrado',
      'resumo': _controladorResumo.text,
      'objetivo': _controladorObjetivo.text,
      'contrapartida': _controladorContrapartida.text,
      'vinculo': _controladorVinculo.text,
      'resultados_esperados': _controladorResultadosEsperados.text,
      'area_tematica': areaTematicaSelecionada,
    })
    .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    debugPrint("ID da demanda: " + _novaDemanda.id);

    //Limpando os campos após a criação da proposta
    _controladorTitulo.text = '';
    _controladorTempoNecessario.text = '';
    _controladorResumo.text = '';
    _controladorObjetivo.text = '';
    _controladorContrapartida.text = '';
    _controladorVinculo.text = '';
    _controladorResultadosEsperados.text = '';

    String _nomeArquivo = result.files.first.name;
    String _nomeArquivoExtensao;

    //Faz o upload do arquivo selecionado para o Firebase storage
    if(result != null && result.files.isNotEmpty) {
      _nomeArquivo = _nomeArquivo.substring(0, _nomeArquivo.lastIndexOf('.'));
      _nomeArquivoExtensao = _nomeArquivo + '_' + _novaDemanda.id + '.' + result.files.first.extension;

      debugPrint("Nome do arquivo: " + _nomeArquivoExtensao);

      if (kIsWeb) {
        _uploadFile(result.files.first.bytes, _nomeArquivoExtensao, _novaDemanda.id);
      } else {
        _uploadFile(await File(result.files.first.path).readAsBytes(), _nomeArquivoExtensao, _novaDemanda.id);
      }
    }

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///Função responsável por fazer o upload do arquivo para o storage
  Future<void> _uploadFile(Uint8List _data, String nameFile, String demandaId) async {

    CollectionReference _arquivosDemanda = FirebaseFirestore.instance.
    collection('DEMANDAS').doc(demandaId).collection('arquivos');

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
        .ref('arquivos/$nameFile');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      print('Arquivo enviado com sucesso!');
      print('URL do arquivo: $url');
      print(demandaId);
      _arquivosDemanda.add({'file_url' : url});
    } else {
      print(uploadTask.state);
    }
  }
}