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

class FormDemanda extends StatefulWidget {
  const FormDemanda(
      {Key key,
      this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.vinculo,
      this.resultadosEsperados,
      this.propostaConjunto,
      this.dadosProponente,
      this.empresaEnvolvida,
      this.equipeColaboradores,
      this.docId,
      this.areaTematica})
      : super(key: key);

  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String vinculo;
  final String resultadosEsperados;
  final String propostaConjunto;
  final String dadosProponente;
  final String empresaEnvolvida;
  final String equipeColaboradores;
  final String areaTematica;
  final String docId;

  @override
  State<FormDemanda> createState() => _FormDemandaState();
}

class _FormDemandaState extends State<FormDemanda> {
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

  String documentID = '';

  final styleText = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  final styleTextFile =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w200);

  String _fileName;
  bool _carregando = false;
  List<PlatformFile> _caminhoDoArquivo;
  final FileType _tipoArquivo = FileType.custom;

  String areaTematicaSelecionada;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Área temática';

  List userFiles;

  @override
  void initState() {
    // Retornando os valores para os campos de texto
    _controladorTitulo.text = widget.titulo;
    _controladorTempoNecessario.text = widget.tempo;
    _controladorResumo.text = widget.resumo;
    _controladorObjetivo.text = widget.objetivo;
    _controladorContrapartida.text = widget.contrapartida;
    _controladorVinculo.text = widget.vinculo;
    _controladorResultadosEsperados.text = widget.resultadosEsperados;
    _controladorPropostaConjunto.text = widget.propostaConjunto;
    _controladorDadosProponete.text = widget.dadosProponente;
    _controladorEmpresaEnvolvida.text = widget.empresaEnvolvida;
    _controladorEquipeColaboradores.text = widget.equipeColaboradores;
    areaTematicaSelecionada = widget.areaTematica;
    documentID = widget.docId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var subcollectionRef = FirebaseFirestore.instance
        .collection('DEMANDAS')
        .doc(documentID)
        .collection('arquivos')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de cadastro", style: AppTheme.typo.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditorTextFormField(_controladorTitulo, "Título da proposta",
                  "Título da Proposta", 1, 150, true),
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
                                  'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
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
                                areaTematicaSelecionada = currencyValue;
                              });
                              debugPrint(currencyValue);
                            },
                            value: areaTematicaSelecionada,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: EditorTextFormField(
                          _controladorTempoNecessario,
                          "Informe o tempo necessário",
                          "Número de meses para ser realizada",
                          1,
                          150,
                          true)),
                ],
              ),
              EditorTextFormField(
                  _controladorResumo,
                  "Faça uma breve descrição da sua proposta",
                  "Explique da melhor forma que conseguir sobre o que se trata a proposta",
                  5,
                  600,
                  true),
              EditorTextFormField(
                  _controladorObjetivo,
                  "Descreva os objetivos que você espera serem atendidos",
                  "Coloque em forma de tópicos os objetivos da proposta",
                  5,
                  600,
                  true),
              EditorTextFormField(
                  _controladorContrapartida,
                  "Quais recursos a equipe dispõe para a execução da proposta?",
                  "Descreva quais recursos estão disponíveis para a execução da proposta, financeiros, humanos, estrutura, etc",
                  5,
                  600,
                  true),
              EditorTextFormField(
                  _controladorVinculo,
                  "Qual o seu vínculo com o projeto?",
                  "Descreva qual o seu vínculo com a entidade parceira envolvida com este projeto",
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
                  "Por que a proposta faz jus a uma ação em conjunto?  ",
                  "Por que precisa da Instituição de Ensino?",
                  7,
                  600,
                  true),
              EditorTextFormField(
                  _controladorDadosProponete,
                  "Dados do Proponente?  ",
                  "Dados Gerais, está vinculado a qual instituição/empresa?",
                  7,
                  600,
                  true),
              EditorTextFormField(
                  _controladorEmpresaEnvolvida,
                  "Quais serão as instituições / empresas envolvidas na proposta?  ",
                  "Instituições/empresas parceiras?",
                  7,
                  600,
                  true),
              EditorTextFormField(
                  _controladorEquipeColaboradores,
                  "Quem será a equipe de colaboradores externos?  ",
                  "Nome, formação, dados gerais, etc, ",
                  7,
                  600,
                  true),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selecionarArquivos(),
                child: const Text('Selecionar Arquivos'),
              ),
              documentID != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: subcollectionRef,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;

                        return Column(
                          children: [
                            Wrap(
                              children: List.generate(data.size, (int index) {
                                final fileName = data.docs[index]['file_name'];
                                return listFile(fileName, () {
                                  debugPrint('$_caminhoDoArquivo');
                                  debugPrint('${_caminhoDoArquivo.length}');
                                });
                              }).toList(),
                            ),
                            if (_caminhoDoArquivo != null) ...[
                              Wrap(
                                children: List.generate(
                                    _caminhoDoArquivo.length, (int index) {
                                  final fileName =
                                      _caminhoDoArquivo[index].name;
                                  return listFile(fileName, () {
                                    setState(() {
                                      _caminhoDoArquivo.removeAt(index);
                                    });
                                  });
                                }).toList(),
                              )
                            ]
                          ],
                        );
                      },
                    )
                  : Builder(
                      builder: (BuildContext context) => _caminhoDoArquivo !=
                              null
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
                                  final bool vetNaoVazio =
                                      _caminhoDoArquivo != null &&
                                          _caminhoDoArquivo.isNotEmpty;
                                  final String name = (vetNaoVazio
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
                                    trailing: IconButton(
                                        onPressed: () {
                                          //debugPrint('$index');
                                          debugPrint('$_caminhoDoArquivo');
                                          setState(() {
                                            _caminhoDoArquivo.removeAt(index);

                                            if (_caminhoDoArquivo.isEmpty) {
                                              _caminhoDoArquivo = null;
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.highlight_remove_rounded)),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              )),
                            )
                          : const Text('Nenhum aquivo selecionado...'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors.blue,
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (documentID == null) {
              _criarDemanda(context);

              //SnackBar
              const SnackBar snackBar = SnackBar(
                  content: Text("Sua demanda foi criada com sucesso! "));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              _editarDemanda();

              //SnackBar
              const SnackBar snackBar = SnackBar(
                  content: Text("Sua demanda foi atualizada com sucesso! "));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
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

    debugPrint('$_caminhoDoArquivo');

    setState(() {
      _carregando = false;
      _fileName = _caminhoDoArquivo != null
          ? _caminhoDoArquivo.map((e) => e.name).toString()
          : '...';
    });
  }

  void _editarDemanda() async {
    final CollectionReference demandaRef =
        FirebaseFirestore.instance.collection('DEMANDAS');

    demandaRef
        .doc(documentID)
        .update({
          'titulo': _controladorTitulo.text,
          'tempo': _controladorTempoNecessario.text,
          'resumo': _controladorResumo.text,
          'objetivo': _controladorObjetivo.text,
          'contrapartida': _controladorContrapartida.text,
          'vinculo': _controladorVinculo.text,
          'resultados_esperados': _controladorResultadosEsperados.text,
          'proposta_conjunto': _controladorPropostaConjunto.text,
          'dados_proponente': _controladorDadosProponete.text,
          'empresa_envolvida': _controladorEmpresaEnvolvida.text,
          'equipe_colaboradores': _controladorEquipeColaboradores.text,
          'area_tematica': areaTematicaSelecionada,
        })
        .then((value) => debugPrint("Demanda atualizada"))
        .catchError((error) => debugPrint(
            "Ocorreu um erro na atualização da sua demanda: $error"));

    limpaFormulario();

    Navigator.pop(context, '/listaDemanda');
  }

  void _criarDemanda(BuildContext context) async {
    // Recupera o usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    //Adicionando um novo documento a nossa coleção -> Demandas
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
      'area_tematica': areaTematicaSelecionada,
    }).catchError((error) =>
            debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    debugPrint("ID da demanda: " + _novaDemanda.id);

    limpaFormulario();

    Navigator.pushReplacementNamed(context, '/listaDemanda');

    debugPrint(_caminhoDoArquivo.length.toString());

    for (var arquivos in _caminhoDoArquivo) {
      String _nomeArquivo = arquivos.name;
      String _nomeArquivoExtensao;

      //Faz o upload do arquivo selecionado para o Firebase storage
      if (_caminhoDoArquivo != null && _caminhoDoArquivo.isNotEmpty) {
        _nomeArquivo =
            arquivos.name.substring(0, _nomeArquivo.lastIndexOf('.'));
        _nomeArquivoExtensao =
            _nomeArquivo + '_' + _novaDemanda.id + '.' + arquivos.extension;

        debugPrint("Nome do arquivo: " + _nomeArquivoExtensao);

        if (kIsWeb) {
          _uploadFile(_caminhoDoArquivo.first.bytes, _nomeArquivoExtensao,
              _novaDemanda.id, _nomeArquivo);
        } else {
          _uploadFile(await File(_caminhoDoArquivo.first.path).readAsBytes(),
              _nomeArquivoExtensao, _novaDemanda.id, _nomeArquivo);
        }
      }
    }
  }

  void limpaFormulario() {
    //Limpando os campos após a criação da proposta
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
  }

  Widget listFile(String fileName, VoidCallback onTap) {
    return ListTile(
      title: Text(fileName),
      trailing: IconButton(
        icon: const Icon(Icons.highlight_remove_rounded),
        onPressed: onTap,
      ),
    );
  }

  ///Função responsável por fazer o upload do arquivo para o storage
  Future<void> _uploadFile(Uint8List _data, String nameFile, String demandaId,
      String nomeArquivoReal) async {
    CollectionReference _arquivosDemanda = FirebaseFirestore.instance
        .collection('DEMANDAS')
        .doc(demandaId)
        .collection('arquivos');

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('arquivos/$nameFile');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(_data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      debugPrint('Arquivo enviado com sucesso!');
      debugPrint('URL do arquivo: $url');
      debugPrint(demandaId);
      _arquivosDemanda.add({'file_url': url, 'file_name': nomeArquivoReal});
    } else {
      print(uploadTask.state);
    }
  }
}
