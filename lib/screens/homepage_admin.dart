import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/report/demanda_report.dart';
import 'package:extensiona_if/screens/demanda_edit_admin.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/admin_drawer_navigation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  final String tipoUsuario;

  const AdminScreen({Key key, this.tipoUsuario}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<String> _areaFiltered = [];
  List<String> _locationFiltered = [];
  List<String> _areaLocationFiltered = [];
  final List<String> _uniqueLocalidadeList = [];

  final _formKeyArea = GlobalKey<FormFieldState>();
  final _formKeyLocalidade = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    filteringData();
  }

  filterAreaLocation() {
    //Concatena as áreas selecionadas com as localidades

    String _areaLocalidade;

    for (var area in _areaFiltered) {
      for (var localidade in _locationFiltered) {
        _areaLocalidade = area + '-' + localidade;
        _areaLocationFiltered.add(_areaLocalidade);
      }
    }

    return _areaLocationFiltered;
  }

  removeAreaLocation(index) {
    setState(() {
      _areaLocationFiltered.removeAt(index);
    });
  }

  //Método responsável por fazer o filtro das áreas temáticas
  filteringData() {
    if (_areaFiltered.isEmpty && _locationFiltered.isEmpty) {
      // Verifica se o vetor que contém as áreas selecionadas e a localização está vazio
      final Stream<QuerySnapshot> _demandaStream =
          FirebaseFirestore.instance.collection('DEMANDAS').snapshots();
      return StreamBuilderDemandas(stream: _demandaStream);
    } else if (_areaFiltered.isEmpty) {
      // caso não esteja, ele realizará o filtro baseado nos valores que ele encontrar no vetor _categoryFiltered
      final Stream<QuerySnapshot> _filterDemandaStream = FirebaseFirestore
          .instance
          .collection('DEMANDAS')
          .where('localidade', whereIn: _locationFiltered)
          .snapshots();
      return StreamBuilderDemandas(stream: _filterDemandaStream);
    } else if (_locationFiltered.isEmpty) {
      // caso não esteja no primeiro vetor, ele realizará o filtro baseado nos valores que ele encontrar no vetor _locationFiltered
      final Stream<QuerySnapshot> _filterDemandaStream = FirebaseFirestore
          .instance
          .collection('DEMANDAS')
          .where('area_tematica', whereIn: _areaFiltered)
          .snapshots();
      return StreamBuilderDemandas(stream: _filterDemandaStream);
    } else {
      // por fim, se os dois vetores tiver alguma informação, ele faz um filtro utilizando os dois vetores

      final Stream<QuerySnapshot> _filterDemandaStream = FirebaseFirestore
          .instance
          .collection('DEMANDAS')
          .where('filtro_area_localidade', whereIn: filterAreaLocation())
          .snapshots();
      return StreamBuilderDemandas(stream: _filterDemandaStream);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Propostas Registradas", style: AppTheme.typo.title),
        automaticallyImplyLeading:
            widget.tipoUsuario == 'super_admin' ? true : false,
        actions: widget.tipoUsuario == 'super_admin'
            ? null
            : [
                IconButton(
                    onPressed: () {
                      userDao.logout();
                    },
                    icon: const Icon(Icons.logout))
              ],
      ),
      drawer: widget.tipoUsuario == 'super_admin'
          ? adminDrawerNavigation(context)
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('AREAS_TEMATICAS')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    final _items = snapshot.data.docs
                        .map((DocumentSnapshot document) =>
                            MultiSelectItem<String>(
                                document['nome'], document['nome']))
                        .toList();

                    final _itemsChip = _areaFiltered
                        .map((e) => MultiSelectItem<String>(e, e))
                        .toList();

                    return MultiSelectDialogField(
                      items: _items,
                      key: _formKeyArea,
                      title: Text("Filtrar por Áreas Temáticas",
                          style: AppTheme.typo.defaultBoldText),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                      ),
                      buttonIcon: Icon(Icons.expand_more,
                          color: AppTheme.colors.greyText),
                      buttonText:
                          Text("Áreas Temáticas", style: AppTheme.typo.button),
                      onConfirm: (results) {
                        if (_formKeyArea.currentState.validate()) {
                          setState(() {
                            _areaFiltered = results;
                          });
                          debugPrint(_areaFiltered.toString());
                        } else {
                          return;
                        }
                      },
                      cancelText: const Text('CANCELAR'),
                      confirmText: const Text('FILTRAR'),
                      chipDisplay: MultiSelectChipDisplay<String>(
                        items: _itemsChip,
                        onTap: (value) {
                          setState(() {
                            debugPrint(value);
                            _areaFiltered.remove(value);
                          });
                          debugPrint(_areaFiltered.toString());

                          _areaLocationFiltered = [];
                          for (var areaLocation in _areaLocationFiltered) {
                            if (areaLocation.contains(value)) {
                              debugPrint('Index = $areaLocation');
                              var index =
                                  _areaLocationFiltered.indexOf(areaLocation);
                              removeAreaLocation(index);
                            }
                          }
                          debugPrint('vetor de areas e localidades:' +
                              _areaLocationFiltered.toString());
                        },
                      ),
                      validator: (list) {
                        if (list.length > 10) {
                          return 'O número máximo de opções selecionáveis é 10';
                        }

                        return null;
                      },
                    );
                  }
                }),
            Utils.addVerticalSpace(10),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('DEMANDAS')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    for (var itens in snapshot.data.docs) {
                      _uniqueLocalidadeList.add(itens.get('localidade'));
                    }

                    final _items = _uniqueLocalidadeList
                        .toSet()
                        .map((document) =>
                            MultiSelectItem<String>(document, document))
                        .toList();

                    // final _items = snapshot.data.docs
                    //     .map((DocumentSnapshot document) =>
                    //         MultiSelectItem<String>(
                    //             document['localidade'], document['localidade']))
                    //     .toList();

                    final _itemsChip = _locationFiltered
                        .map((e) => MultiSelectItem<String>(e, e))
                        .toList();

                    return MultiSelectDialogField(
                        items: _items,
                        key: _formKeyLocalidade,
                        title: Text("Filtrar por Localidade",
                            style: AppTheme.typo.defaultBoldText),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                        buttonIcon: Icon(Icons.expand_more,
                            color: AppTheme.colors.greyText),
                        buttonText:
                            Text("Localidade", style: AppTheme.typo.button),
                        onConfirm: (results) {
                          if (_formKeyLocalidade.currentState.validate()) {
                            setState(() {
                              _locationFiltered = results;
                            });
                            debugPrint(_locationFiltered.toString());
                          }
                        },
                        cancelText: const Text('CANCELAR'),
                        confirmText: const Text('FILTRAR'),
                        chipDisplay: MultiSelectChipDisplay<String>(
                          items: _itemsChip,
                          onTap: (value) {
                            debugPrint(value);

                            setState(() {
                              debugPrint(value);
                              _locationFiltered.remove(value);
                            });

                            _areaLocationFiltered = [];
                            for (var areaLocation in _areaLocationFiltered) {
                              if (areaLocation.contains(value)) {
                                debugPrint('Index = $areaLocation');
                                var index =
                                    _areaLocationFiltered.indexOf(areaLocation);
                                removeAreaLocation(index);
                              }
                            }
                            debugPrint('vetor de areas e localidades:' +
                                _areaLocationFiltered.toString());
                            // debugPrint(_locationFiltered.toString());
                          },
                        ),
                        validator: (list) {
                          if (list.length > 10) {
                            return 'O número máximo de opções selecionáveis é 10';
                          }

                          return null;
                        });
                  }
                }),
            Utils.addVerticalSpace(10),
            filteringData()
          ],
        ),
      ),
    );
  }
}

class StreamBuilderDemandas extends StatelessWidget {
  final Stream<QuerySnapshot> stream;

  const StreamBuilderDemandas({Key key, this.stream}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Algo deu errado!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Carregando dados..."));
          }

          final data = snapshot.requireData;

          return criarLista(data);
        });
  }
}

Widget criarLista(QuerySnapshot dataSnapshot) {
  return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: dataSnapshot.size,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        //Pegando as informações dos documentos do firebase da coleção Demandas
        final infoTitulo = dataSnapshot.docs[index]['titulo'];
        final infoTempo = dataSnapshot.docs[index]['tempo'];
        final infoStatus = dataSnapshot.docs[index]['status'];
        final infoResumo = dataSnapshot.docs[index]['resumo'];
        final infoObjetivo = dataSnapshot.docs[index]['objetivo'];
        final infoContrapartida = dataSnapshot.docs[index]['contrapartida'];
        final infoVinculo = dataSnapshot.docs[index]['vinculo'];
        final infoResultadosEsperados =
            dataSnapshot.docs[index]['resultados_esperados'];
        // final infoAreaTematica = dataSnapshot.docs[index]['area_tematica'];
        final docRef = dataSnapshot.docs[index];

        return EstilizacaoLista(
          infoTitulo: infoTitulo,
          infoTempo: infoTempo,
          infoResumo: infoResumo,
          infoStatus: infoStatus,
          infoObjetivo: infoObjetivo,
          infoContrapartida: infoContrapartida,
          infoVinculo: infoVinculo,
          infoResultadosEsperados: infoResultadosEsperados,
          docRef: docRef,
        );
      });
}

class EstilizacaoLista extends StatefulWidget {
  final String infoTitulo;
  final String infoTempo;
  final String infoResumo;
  final String infoStatus;
  final String infoObjetivo;
  final String infoContrapartida;
  final String infoVinculo;
  final String infoResultadosEsperados;
  final DocumentSnapshot docRef;

  const EstilizacaoLista(
      {Key key,
      this.infoTitulo,
      this.infoTempo,
      this.infoResumo,
      this.infoStatus,
      this.infoObjetivo,
      this.infoContrapartida,
      this.infoVinculo,
      this.infoResultadosEsperados,
      this.docRef})
      : super(key: key);

  @override
  State<EstilizacaoLista> createState() => _EstilizacaoListaState();
}

class _EstilizacaoListaState extends State<EstilizacaoLista> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      // height: 70.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(FontAwesome.file),
            ]),
        title: Text(widget.infoTitulo),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(children: [
            // Informação Tempo
            Icon(
              Icons.alarm_outlined,
              size: 18,
              color: AppTheme.colors.blue,
            ),
            const SizedBox(width: 4),
            Text(widget.infoTempo),

            // Espaçamento entre as informações
            const SizedBox(width: 10),

            // Informação Status
            Icon(
              Icons.flag_outlined,
              size: 18,
              color: AppTheme.colors.blue,
            ),
            const SizedBox(width: 4),
            Text(widget.infoStatus[0].toString().toUpperCase() +
                widget.infoStatus
                    .toString()
                    .substring(1, widget.infoStatus.toString().length)),
          ] //     Text(DateTime(infoData).year.toString());
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    var subcolecaoRef = await FirebaseFirestore.instance
                        .collection('DEMANDAS')
                        .doc(widget.docRef.id)
                        .collection('arquivos')
                        .get();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DemandaReport(
                            docid: widget.docRef,
                            vetDadoSubcolecao: subcolecaoRef.docs),
                      ),
                    );
                  },
                  icon: Icon(FontAwesome.print,
                      size: 20, color: Colors.grey.shade800),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    debugPrint('consultou a demanda');
                    final Future future = Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditarFormInfoAdmin(
                          widget.infoTitulo,
                          widget.infoTempo,
                          widget.infoResumo,
                          widget.infoObjetivo,
                          widget.infoContrapartida,
                          widget.infoVinculo,
                          widget.infoResultadosEsperados,
                          widget.infoStatus,
                          widget.docRef);
                    }));

                    future.then((demandaAtualizada) {
                      debugPrint("$demandaAtualizada");
                      debugPrint('A proposta foi alterada');
                    });
                  },
                  icon: Icon(FontAwesome.pencil,
                      size: 20, color: Colors.grey.shade800),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Deletar Proposta'),
                            content: const Text(
                                'Você deseja deletar esta proposta?'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  //Deleta a proposta cadastrada no Firebase
                                  debugPrint('Foi deletado a proposta');
                                  widget.docRef.reference.delete();

                                  //Fecha a janela de exclusão
                                  Navigator.pop(context);

                                  //Dispara um SnackBar
                                  const SnackBar snackBar = SnackBar(
                                      content: Text(
                                          "A proposta foi deletada com sucesso! "));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: const Text('Sim'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  //Navigator.of(context).pop();
                                  debugPrint('Não foi deletado a proposta');
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          );
                        });
                  },
                  tooltip: 'Remover Proposta',
                  icon: Icon(FontAwesome.trash,
                      size: 20, color: Colors.grey.shade800),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
