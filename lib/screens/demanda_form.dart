import 'dart:io';
import 'dart:typed_data';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/drawer_navigation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class FormDemanda extends StatefulWidget {
  final String? titulo;
  final String? tempo;
  final String? resumo;
  final String? objetivo;
  final String? contrapartida;
  final String? resultadosEsperados;
  final String? areaTematica;
  final String? vinculo;
  final String? propostaConjunto;
  final String? dadosProponente;
  final String? empresaEnvolvida;
  final String? equipeColaboradores;
  final String? docId;
  final bool editarDemanda;
  final Users usuario;

  const FormDemanda(
      {super.key,
      this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.resultadosEsperados,
      this.areaTematica,
      this.vinculo,
      this.propostaConjunto,
      this.dadosProponente,
      this.empresaEnvolvida,
      this.equipeColaboradores,
      this.docId,
      required this.editarDemanda,
      required this.usuario});

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
  Stream<QuerySnapshot>? subcollectionRef;

  String fileName = '';
  List<PlatformFile> _caminhoDoArquivo = [];
  final FileType _tipoArquivo = FileType.custom;

  String? areaTematicaSelecionada;

  String hintText = 'Área temática';

  @override
  void initState() {
    //Retornando os valores para os campos de texto
    widget.titulo != null ? _controladorTitulo.text = widget.titulo! : '';
    widget.tempo != null
        ? _controladorTempoNecessario.text = widget.tempo!
        : '';
    widget.resumo != null ? _controladorResumo.text = widget.resumo! : '';
    widget.objetivo != null ? _controladorObjetivo.text = widget.objetivo! : '';
    widget.contrapartida != null
        ? _controladorContrapartida.text = widget.contrapartida!
        : '';
    widget.vinculo != null ? _controladorVinculo.text = widget.vinculo! : '';
    widget.resultadosEsperados != null
        ? _controladorResultadosEsperados.text = widget.resultadosEsperados!
        : '';
    widget.propostaConjunto != null
        ? _controladorPropostaConjunto.text = widget.propostaConjunto!
        : '';
    widget.dadosProponente != null
        ? _controladorDadosProponete.text = widget.dadosProponente!
        : '';
    widget.empresaEnvolvida != null
        ? _controladorEmpresaEnvolvida.text = widget.empresaEnvolvida!
        : '';
    widget.equipeColaboradores != null
        ? _controladorEquipeColaboradores.text = widget.equipeColaboradores!
        : '';
    widget.areaTematica != null
        ? areaTematicaSelecionada = widget.areaTematica!
        : '';
    widget.docId != null ? documentID = widget.docId! : '';
    widget.editarDemanda
        ? subcollectionRef = FirebaseFirestore.instance
            .collection('DEMANDAS')
            .doc(documentID)
            .collection('arquivos')
            .snapshots()
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de Cadastro", style: AppTheme.typo.title),
      ),
      drawer: drawerNavigation(context),
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
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              helperText:
                                  'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                              hintText: hintText,
                            ),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document['nome'].toString(),
                                child: Text(document['nome']),
                              );
                            }).toList(),
                            onChanged: (currencyValue) {
                              setState(() {
                                areaTematicaSelecionada =
                                    currencyValue as String;
                              });
                              debugPrint('$currencyValue');
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
                          false)),
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
                  false),
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
                  false),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _selecionarArquivos(),
                label: const Text('Selecionar Arquivos'),
                icon: const Icon(Icons.upload_file_outlined),
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(16))),
              ),
              Utils.addVerticalSpace(10),
              widget.editarDemanda
                  ? StreamBuilder<QuerySnapshot>(
                      stream: subcollectionRef,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Erro ...'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;

                        if (snapshot.data!.docs.isNotEmpty) {
                          return Column(
                            children: [
                              Wrap(
                                children: List.generate(data.size, (int index) {
                                  final fileName =
                                      data.docs[index]['file_name'];
                                  final docRef = data.docs[index];

                                  return listFile(fileName, () {
                                    deleteUserFile(docRef);
                                  });
                                }).toList(),
                              ),
                              if (_caminhoDoArquivo != []) ...[
                                Wrap(
                                  children: List.generate(
                                      _caminhoDoArquivo.length, (int index) {
                                    final fileName =
                                        _caminhoDoArquivo[index].name;
                                    return listFile(fileName, () {
                                      setState(() {
                                        _caminhoDoArquivo.removeAt(index);

                                        if (_caminhoDoArquivo.isEmpty) {
                                          _caminhoDoArquivo = [];
                                        }
                                      });
                                    });
                                  }).toList(),
                                )
                              ]
                            ],
                          );
                        } else {
                          return _caminhoDoArquivo != []
                              ? Wrap(
                                  children: List.generate(
                                      _caminhoDoArquivo.length, (int index) {
                                    final fileName =
                                        _caminhoDoArquivo[index].name;
                                    return listFile(fileName, () {
                                      setState(() {
                                        _caminhoDoArquivo.removeAt(index);

                                        if (_caminhoDoArquivo.isEmpty) {
                                          _caminhoDoArquivo = [];
                                        }
                                      });
                                    });
                                  }).toList(),
                                )
                              : const Text('Nenhum aquivo selecionado...');
                        }
                      },
                    )
                  : _caminhoDoArquivo != []
                      ? Wrap(
                          children: List.generate(_caminhoDoArquivo.length,
                              (int index) {
                            final fileName = _caminhoDoArquivo[index].name;
                            return listFile(fileName, () {
                              setState(() {
                                _caminhoDoArquivo.removeAt(index);

                                if (_caminhoDoArquivo.isEmpty) {
                                  _caminhoDoArquivo = [];
                                }
                              });
                            });
                          }).toList(),
                        )
                      : const Text('Nenhum aquivo selecionado...')
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors.blue,
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!widget.editarDemanda) {
              _criarDemanda(context);

              //SnackBar
              Utils.schowSnackBar("Sua demanda foi criada com sucesso! ");
            } else {
              _editarDemanda();

              //SnackBar
              Utils.schowSnackBar("Sua demanda foi atualizada com sucesso! ");
            }

            //Limpa o formulário após adição ou edição da demanda
            limpaFormulario();
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
    ))!
        .files;

    if (!mounted) return;

    setState(() {
      fileName = _caminhoDoArquivo != []
          ? _caminhoDoArquivo.map((e) => e.name).toString()
          : '...';
    });
  }

  void deleteUserFile(QueryDocumentSnapshot docRef) async {
    await docRef.reference.delete();
  }

  void _editarDemanda() async {
    final CollectionReference demandaRef =
        FirebaseFirestore.instance.collection('DEMANDAS');

    // Define a localidade da demanda de acordo com a localidade do usuário
    final String localidade =
        '(${widget.usuario.userState}) ${widget.usuario.userCity}';

    var areaLocalidade = '$areaTematicaSelecionada-$localidade';

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
          'localidade': localidade,
          'filtro_area_localidade': areaLocalidade
        })
        .then((value) => debugPrint("Demanda atualizada"))
        .catchError((error) => debugPrint(
            "Ocorreu um erro na atualização da sua demanda: $error"));

    Navigator.pop(context, '/listaDemanda');

    uploadFile(documentID);
  }

  void _criarDemanda(BuildContext context) async {
    // Recupera o usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    // Define a localidade da demanda de acordo com a localidade do usuário
    final String localidade =
        '(${widget.usuario.userState}) ${widget.usuario.userCity}';

    final String areaLocalidade = '$areaTematicaSelecionada-$localidade';

    //Adicionando um novo documento a nossa coleção -> Demandas
    DocumentReference novaDemanda =
        await FirebaseFirestore.instance.collection('DEMANDAS').add({
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
      'localidade': localidade,
      'filtro_area_localidade': areaLocalidade
    }).catchError((error) {
      Utils.schowSnackBar('Erro no registro de sua demanda!');
      debugPrint("Ocorreu um erro ao registrar sua demanda: $error");
    });

    debugPrint("ID da demanda: ${novaDemanda.id}");

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/listaDemanda');

    uploadFile(novaDemanda.id);
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
      leading: IconButton(
        icon:
            const Icon(Icons.highlight_remove_rounded, color: Colors.redAccent),
        onPressed: onTap,
      ),
    );
  }

  void uploadFile(String docId) async {
    if (_caminhoDoArquivo == [] && _caminhoDoArquivo.isEmpty) return;

    for (var arquivos in _caminhoDoArquivo) {
      String nomeArquivo = arquivos.name;
      String nomeArquivoExtensao;

      //Faz o upload do arquivo selecionado para o Firebase storage
      nomeArquivo = arquivos.name.substring(0, nomeArquivo.lastIndexOf('.'));
      nomeArquivoExtensao = '${nomeArquivo}_$docId.${arquivos.extension}';

      debugPrint("Nome do arquivo: $nomeArquivoExtensao");

      if (kIsWeb) {
        _uploadFileToFirebase(_caminhoDoArquivo.first.bytes!,
            nomeArquivoExtensao, docId, nomeArquivo);
      } else {
        _uploadFileToFirebase(
            await File(_caminhoDoArquivo.first.path!).readAsBytes(),
            nomeArquivoExtensao,
            docId,
            nomeArquivo);
      }
    }
  }

  ///Função responsável por fazer o upload do arquivo para o storage
  Future<void> _uploadFileToFirebase(Uint8List data, String nameFile,
      String demandaId, String nomeArquivoReal) async {
    CollectionReference arquivosDemanda = FirebaseFirestore.instance
        .collection('DEMANDAS')
        .doc(demandaId)
        .collection('arquivos');

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('arquivos/$nameFile');

    ///Mostrar a progressão do upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(data);

    ///Pega o download url do arquivo
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      debugPrint('Arquivo enviado com sucesso!');
      debugPrint('URL do arquivo: $url');
      debugPrint(demandaId);
      arquivosDemanda.add({
        'file_url': url,
        'file_name': nomeArquivoReal,
        'file_name_storage': nameFile
      });
    } else {
      if (kDebugMode) {
        print(uploadTask.state);
      }
    }
  }
}
