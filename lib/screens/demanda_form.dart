import 'dart:io';
import 'dart:typed_data';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;

class FormDemandaState extends State<FormDemanda> {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario =
      TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida =
      TextEditingController();
  final TextEditingController _controladorVinculo = TextEditingController();
  final TextEditingController _controladorResultadosEsperados =
      TextEditingController();
  final TextEditingController _controladorPropostaConjunto =
      TextEditingController();
  final TextEditingController _controladorDadosProponete =
      TextEditingController();
  final TextEditingController _controladorEmpresaEnvolvida =
      TextEditingController();
  final TextEditingController _controladorEquipeColaboradores =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  final styleTextFile =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  //FilePickerResult result;
  //PlatformFile name;

  FilePickerResult _result;
  PlatformFile _arquivo;
  String _fileName;
  bool _carregando = false;
  List<PlatformFile> _caminhoDoArquivo;
  final FileType _tipoArquivo = FileType.custom;

  String selectedCurrency;

  String areaTematicaSelecionada;
  DocumentSnapshot areaTematicaAtual;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = '??rea tem??tica';

  //bool _valida = false;

  @override
  Widget build(BuildContext context) {
    //final fileName = name != null ? basename(name.name) : 'Nenhum aquivo selecionado...';

    return Scaffold(
      appBar: AppBar(
        title: Text("Formul??rio de cadastro", style: AppTheme.typo.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditorTextFormField(_controladorTitulo, "T??tulo da proposta",
                  "T??tulo da Proposta", 1, 150, true),

              Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('AREAS_TEMATICAS')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Carregando ...');
                      } else {
                        return Expanded(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              helperText:
                                  'Qual a ??rea do conhecimento que voc?? acha que mais se aproxima da sua proposta?',
                              hintText: hintText,
                            ),
                            items: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                child: Text(document['nome']),
                                value: document['nome'],
                              );
                            }).toList(),
                            onChanged: (currencyValue) {
                              setState(() {
                                selectedCurrency = currencyValue;
                              });
                              debugPrint(currencyValue);
                            },
                            value: selectedCurrency,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: EditorTextFormField(
                          _controladorTempoNecessario,
                          "Informe o tempo necess??rio",
                          "N??mero de meses para ser realizada",
                          1,
                          150,
                          true)),
                ],
              ),

              EditorTextFormField(
                  _controladorResumo,
                  "Fa??a uma breve descri????o da sua proposta",
                  "Explique da melhor forma que conseguir sobre o que se trata a proposta",
                  5,
                  600,
                  true),

              EditorTextFormField(
                  _controladorObjetivo,
                  "Descreva os objetivos que voc?? espera serem atendidos",
                  "Coloque em forma de t??picos os objetivos da proposta",
                  5,
                  600,
                  true),

              EditorTextFormField(
                  _controladorContrapartida,
                  "Quais recursos a equipe disp??e para a execu????o da proposta?",
                  "Descreva quais recursos est??o dispon??veis para a execu????o da proposta, financeiros, humanos, estrutura, etc",
                  5,
                  600,
                  true),

              EditorTextFormField(
                  _controladorVinculo,
                  "Qual o seu v??nculo com o projeto?",
                  "Descreva qual o seu v??nculo com a entidade parceira envolvida com este projeto",
                  1,
                  100,
                  true),

              EditorTextFormField(
                  _controladorResultadosEsperados,
                  "Quais os resultados esperados?  ",
                  "Descreva os resultados esperados",
                  5,
                  600,
                  false),

              EditorTextFormField(
                  _controladorPropostaConjunto,
                  "Por que a proposta faz jus a uma a????o em conjunto?  ",
                  "Por que precisa da Institui????o de Ensino?",
                  7,
                  600,
                  true),

              EditorTextFormField(
                  _controladorDadosProponete,
                  "Dados do Proponente?  ",
                  "Dados Gerais, est?? vinculado a qual institui????o/empresa?",
                  7,
                  600,
                  true),

              EditorTextFormField(
                  _controladorEmpresaEnvolvida,
                  "Quais ser??o as institui????es / empresas envolvidas na proposta?  ",
                  "Institui????es/empresas parceiras?",
                  7,
                  600,
                  true),

              EditorTextFormField(
                  _controladorEquipeColaboradores,
                  "Quem ser?? a equipe de colaboradores externos?  ",
                  "Nome, forma????o, dados gerais, etc, ",
                  7,
                  600,
                  true),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => _selecionarArquivos(),
                child: const Text('Selecionar Arquivos'),
              ),

              Builder(
                  builder: (BuildContext context) => _caminhoDoArquivo != null
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Scrollbar(
                              child: ListView.separated(
                            itemCount: _caminhoDoArquivo != null &&
                                    _caminhoDoArquivo.isNotEmpty
                                ? _caminhoDoArquivo.length
                                : 1,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMultiPath =
                                  _caminhoDoArquivo != null &&
                                      _caminhoDoArquivo.isNotEmpty;
                              final String name = 'File $index: ' +
                                  (isMultiPath
                                      ? _caminhoDoArquivo
                                          .map((e) => e.name)
                                          .toList()[index]
                                      : _fileName ?? '...');

                              final path = kIsWeb
                                  ? null
                                  : _caminhoDoArquivo
                                      .map((e) => e.path)
                                      .toList()[index]
                                      .toString();

                              return ListTile(
                                title: Text(
                                  name,
                                ),
                                subtitle: Text(path ?? ''),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )),
                        )
                      : const Text('Nenhum aquivo selecionado...'))

              // CampoSelecaoArquivos(
              //     Icons.cloud_upload_rounded,
              //     'Fa??a o upload de arquivos ',
              //     'AQUI',
              //         () async {
              //       result = await FilePicker.platform.pickFiles(allowMultiple: false);
              //
              //       if(result != null) {
              //         final file = result.files.first;
              //         //Pega o nome do arquivo selecionado
              //         setState(() => name = PlatformFile(name: file.name, size: file.size));
              //       } else {
              //
              //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
              //           'Arquivo n??o selecionado e/ou Falha ao selecionar arquivo',
              //         ),
              //         ));
              //       }
              //     },
              //     styleText,
              //     fileName,
              //     styleTextFile
              // ),

              // const SizedBox(height: 10),
              //
              // SizedBox(
              //   height: 40,
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       primary: AppTheme.colors.blue,
              //       textStyle: AppTheme.typo.button,
              //     ),
              //     onPressed: (){
              //       setState((){
              //         _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorVinculo.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorPropostaConjunto.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorDadosProponete.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorEmpresaEnvolvida.text.isEmpty ? _valida = true : _valida = false;
              //         _controladorEquipeColaboradores.text.isEmpty ? _valida = true : _valida = false;
              //       });
              //
              //       // Caso n??o tenha erros de valida????o
              //       if(!_valida){
              //         _criarDemanda(context);
              //         widget.pagina.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              //       }
              //     },
              //     child: const Text("Criar Nova Demanda")
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors.blue,
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _criarDemanda(context);
            widget.pagina.animateToPage(1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);

            //SnackBar
            const SnackBar snackBar =
                SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  void _selecionarArquivos() async {
    //Abre o explorador de arquivos
    _caminhoDoArquivo = (await FilePicker.platform.pickFiles(
      type: _tipoArquivo,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'txt'],
    ))
        .files;

    if (!mounted) return;
    //if (_result == null) return;

    setState(() {
      _carregando = false;
      _fileName = _caminhoDoArquivo != null
          ? _caminhoDoArquivo.map((e) => e.name).toString()
          : '...';
    });
  }

  void _criarDemanda(BuildContext context) async {
    // Recupera o usu??rio
    final userDao = Provider.of<UserDAO>(context, listen: false);

    //Adicionando um novo documento a nossa cole????o -> Demandas
    DocumentReference _novaDemanda = await FirebaseFirestore.instance
        .collection('DEMANDAS')
        .add({
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
      'proposta_conjunto': _controladorPropostaConjunto.text,
      'dados_proponente': _controladorDadosProponete.text,
      'empresa_envolvida': _controladorEmpresaEnvolvida.text,
      'equipe_colaboradores': _controladorEquipeColaboradores.text,
      'area_tematica': selectedCurrency,
    }).catchError((error) =>
            debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    debugPrint("ID da demanda: " + _novaDemanda.id);

    //Limpando os campos ap??s a cria????o da proposta
    _controladorTitulo.text = '';
    _controladorTempoNecessario.text = '';
    _controladorResumo.text = '';
    _controladorObjetivo.text = '';
    _controladorContrapartida.text = '';
    _controladorVinculo.text = '';
    _controladorResultadosEsperados.text = '';
    _controladorPropostaConjunto.text = '';
    _controladorDadosProponete.text = '';
    _controladorEmpresaEnvolvida.text = '';
    _controladorEquipeColaboradores.text = '';

    debugPrint(_caminhoDoArquivo.length.toString());

    for (var arquivos in _caminhoDoArquivo) {
      String _nomeArquivo = arquivos.name;
      String _nomeArquivoExtensao;

      //Faz o upload do arquivo selecionado para o Firebase storage
      if(_caminhoDoArquivo != null && _caminhoDoArquivo.isNotEmpty) {
        _nomeArquivo = arquivos.name.substring(0, _nomeArquivo.lastIndexOf('.'));
        _nomeArquivoExtensao = _nomeArquivo + '_' + _novaDemanda.id + '.' + arquivos.extension;

        debugPrint("Nome do arquivo: " + _nomeArquivoExtensao);

        if (kIsWeb) {
          _uploadFile(_caminhoDoArquivo.first.bytes, _nomeArquivoExtensao, _novaDemanda.id);
        } else {
          _uploadFile(await File(_caminhoDoArquivo.first.path).readAsBytes(), _nomeArquivoExtensao, _novaDemanda.id);
        }
      }
    }

    //String _nomeArquivo = result.files.first.name;
    //String _nomeArquivoExtensao;

    //Faz o upload do arquivo selecionado para o Firebase storage
    // if(result != null && result.files.isNotEmpty) {
    //   _nomeArquivo = _nomeArquivo.substring(0, _nomeArquivo.lastIndexOf('.'));
    //   _nomeArquivoExtensao = _nomeArquivo + '_' + _novaDemanda.id + '.' + result.files.first.extension;
    //
    //   debugPrint("Nome do arquivo: " + _nomeArquivoExtensao);
    //
    //   if (kIsWeb) {
    //     _uploadFile(result.files.first.bytes, _nomeArquivoExtensao, _novaDemanda.id);
    //   } else {
    //     _uploadFile(await File(result.files.first.path).readAsBytes(), _nomeArquivoExtensao, _novaDemanda.id);
    //   }
    // }
  }

  ///Fun????o respons??vel por fazer o upload do arquivo para o storage
  Future<void> _uploadFile(
      Uint8List _data, String nameFile, String demandaId) async {
    CollectionReference _arquivosDemanda = FirebaseFirestore.instance
        .collection('DEMANDAS')
        .doc(demandaId)
        .collection('arquivos');

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('arquivos/$nameFile');

    ///Mostrar a progress??o do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      print('Arquivo enviado com sucesso!');
      print('URL do arquivo: $url');
      print(demandaId);
      _arquivosDemanda.add({'file_url': url});
    } else {
      print(uploadTask.state);
    }
  }
}

class FormDemanda extends StatefulWidget {
  final PageController pagina;

  const FormDemanda({Key key, this.pagina}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormDemandaState();
  }
}
