import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/report/demanda_report.dart';
import 'package:extensiona_if/screens/demanda_edit_admin.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<String> _categoryFiltered = [];
  List<String> _cityFiltered = [];

  @override
  void initState() {
    super.initState();
    filteringData();
  }

  //Método responsável por fazer o filtro das áreas temáticas
  filteringData() {
    if (_categoryFiltered.isEmpty) {
      // Verifica se o vetor que contém as áreas selecionadas está vazio - irá pegar todas as demandas do banco
      final Stream<QuerySnapshot> _demandaStream =
          FirebaseFirestore.instance.collection('DEMANDAS').snapshots();
      return StreamBuilderDemandas(stream: _demandaStream);
    } else {
      // caso não esteja, ele realizará o filtro baseado nos valores que ele encontrar no vetor _selectedValue
      final Stream<QuerySnapshot> _filterDemandaStream = FirebaseFirestore
          .instance
          .collection('DEMANDAS')
          .where('area_tematica', whereIn: _categoryFiltered)
          .snapshots();
      return StreamBuilderDemandas(stream: _filterDemandaStream);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Propostas Registradas", style: AppTheme.typo.appBar),
        actions: [
          IconButton(
              onPressed: () {
                userDao.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
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
                    return const Text('Carregando...');
                  } else {
                    final _items = snapshot.data.docs
                        .map((DocumentSnapshot document) =>
                            MultiSelectItem<String>(
                                document['nome'], document['nome']))
                        .toList();

                    final _itemsChip = _categoryFiltered
                        .map((e) => MultiSelectItem<String>(e, e))
                        .toList();

                    return MultiSelectDialogField(
                        items: _items,
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
                        buttonText: Text("Áreas Temáticas",
                            style: AppTheme.typo.button),
                        onConfirm: (results) {
                          setState(() {
                            _categoryFiltered = results;
                          });
                          debugPrint(_categoryFiltered.toString());
                        },
                        cancelText: const Text('CANCELAR'),
                        confirmText: const Text('FILTRAR'),
                        chipDisplay: MultiSelectChipDisplay<String>(
                          items: _itemsChip,
                          onTap: (value) {
                            setState(() {
                              debugPrint(value);
                              _categoryFiltered.remove(value);
                            });
                            debugPrint(_categoryFiltered.toString());
                          },
                        ));
                  }
                }),
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
        final updateDados = dataSnapshot.docs[index];

        return estilizacaoLista(
            context,
            infoTitulo,
            infoTempo,
            infoResumo,
            infoStatus,
            infoObjetivo,
            infoContrapartida,
            infoVinculo,
            infoResultadosEsperados,
            updateDados);
      });
}

Widget estilizacaoLista(
    BuildContext context,
    String infoTitulo,
    String infoTempo,
    String infoResumo,
    String infoStatus,
    String infoObjetivo,
    String infoContrapartida,
    String infoVinculo,
    String infoResultadosEsperados,
    DocumentSnapshot updateDados) {
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
      title: Text(infoTitulo),
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
          Text(infoTempo),

          // Espaçamento entre as informações
          const SizedBox(width: 10),

          // Informação Status
          Icon(
            Icons.flag_outlined,
            size: 18,
            color: AppTheme.colors.blue,
          ),
          const SizedBox(width: 4),
          Text(infoStatus[0].toString().toUpperCase() +
              infoStatus.toString().substring(1, infoStatus.toString().length)),
        ] //     Text(DateTime(infoData).year.toString());
            ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DemandaReport(docid: updateDados),
                    ),
                  );
                },
                icon: Icon(FontAwesome.print,
                    size: 20, color: Colors.grey.shade800),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  debugPrint('consultou a demanda');
                  final Future future = Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return EditarFormInfoAdmin(
                        infoTitulo,
                        infoTempo,
                        infoResumo,
                        infoObjetivo,
                        infoContrapartida,
                        infoVinculo,
                        infoResultadosEsperados,
                        updateDados);
                  }));

                  future.then((demandaAtualizada) {
                    debugPrint("$demandaAtualizada");
                    debugPrint('A proposta foi alterada');
                  });
                },
                icon: Icon(FontAwesome.pencil,
                    size: 20, color: Colors.grey.shade800),
              ),
              SizedBox(
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
                          content:
                              const Text('Você deseja deletar esta proposta?'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                //Deleta a proposta cadastrada no Firebase
                                debugPrint('Foi deletado a proposta');
                                updateDados.reference.delete();

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
