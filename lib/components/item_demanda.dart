import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

enum Options { deletar, atualizar }

class ItemDemanda extends StatelessWidget {
  const ItemDemanda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera o Usuário
    UserDAO authService = Provider.of<UserDAO>(context);

    // Recupera a lista de Demandas do usuário
    final Stream<QuerySnapshot> colecaoDemandas = FirebaseFirestore.instance
        .collection('DEMANDAS')
        .where('usuario', isEqualTo: authService.userId())
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: colecaoDemandas,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Ocorreu algum erro!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.requireData;

        return AnimationLimiter(
          child: ListView.builder(
              itemCount: data.size,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                //Pegando as informações dos documentos do firebase da coleção Demandas
                final infoTitulo = data.docs[index]['titulo'];
                final infoTempo = data.docs[index]['tempo'];
                //final infoData = data.docs[index]['data'];
                final infoStatus = data.docs[index]['status'];
                final infoResumo = data.docs[index]['resumo'];
                final infoObjetivo = data.docs[index]['objetivo'];
                final infoContrapartida = data.docs[index]['contrapartida'];
                final infoVinculo = data.docs[index]['vinculo'];
                final infoResultadosEsperados =
                    data.docs[index]['resultados_esperados'];
                final infoAreaTematica = data.docs[index]['area_tematica'];
                final infoPropostaConjunto =
                    data.docs[index]['proposta_conjunto'];
                final infoDadosProponente =
                    data.docs[index]['dados_proponente'];
                final infoEmpresaEnvolvida =
                    data.docs[index]['empresa_envolvida'];
                final infoEquipeColaboradores =
                    data.docs[index]['equipe_colaboradores'];
                final docRef = snapshot.data.docs[index];

                return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 2500),
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ListTile(
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
                                      infoStatus.toString().substring(
                                          1, infoStatus.toString().length)),
                                ] //     Text(DateTime(infoData).year.toString());
                                    ),
                              ),
                              trailing: PopupMenuButton<Options>(
                                onSelected: (Options choice) {
                                  debugPrint(choice.name);
                                  choiceAction(
                                      choice.name,
                                      context,
                                      docRef,
                                      infoTitulo,
                                      infoTempo,
                                      infoResumo,
                                      infoObjetivo,
                                      infoContrapartida,
                                      infoVinculo,
                                      infoResultadosEsperados,
                                      infoPropostaConjunto,
                                      infoDadosProponente,
                                      infoEmpresaEnvolvida,
                                      infoEquipeColaboradores,
                                      infoAreaTematica);
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<Options>>[
                                    if (infoStatus == 'registrado') ...[
                                      const PopupMenuItem<Options>(
                                        value: Options.deletar,
                                        child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Deletar')),
                                      ),
                                    ],
                                    const PopupMenuItem<Options>(
                                      value: Options.atualizar,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Atualizar'),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            )),
                      ),
                    ));
              }),
        );
      },
    );
  }

  void choiceAction(
      String choice,
      BuildContext context,
      QueryDocumentSnapshot docRef,
      String infoTitulo,
      infoTempo,
      infoResumo,
      infoObjetivo,
      infoContrapartida,
      infoVinculo,
      infoResultadosEsperados,
      infoPropostaConjunto,
      infoDadosProponente,
      infoEmpresaEnvolvida,
      infoEquipeColaboradores,
      infoAreaTematica) {
    if (choice == 'deletar') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Deletar Atividade'),
              content: const Text('Você deseja deletar esta atividade?'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    //Deletando o documento do banco de dados
                    debugPrint('A atividade foi deletada');
                    docRef.reference.delete();

                    var subcollectionRef = await FirebaseFirestore.instance
                        .collection('DEMANDAS')
                        .doc(docRef.id)
                        .collection('arquivos')
                        .get();

                    if (subcollectionRef.docs.isEmpty) return;

                    //Deleta também a subcoleção do documento deletado
                    for (var document in subcollectionRef.docs) {
                      debugPrint('$document');
                      document.reference.delete();

                      // Referência do arquivo a ser deletado
                      final storageRef =
                          firebase_storage.FirebaseStorage.instance.ref().child(
                              "arquivos/${document.get('file_name_storage')}");

                      // Deleta o arquivo
                      await storageRef.delete();
                    }

                    //Navegando de volta para a página da lista de propostas
                    Navigator.of(context).pop(true);

                    //SnackBar
                    const SnackBar snackBar = SnackBar(
                        content: Text("A proposta foi deletada com sucesso! "));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Sim'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    debugPrint('A atividade não foi deletada');
                  },
                  child: const Text('Não'),
                ),
              ],
            );
          });
    } else if (choice == 'atualizar') {
      //Navegar para a tela de edição de demandas
      Navigator.pushNamed(context, '/formDemanda',
          arguments: Demandas(
              titulo: infoTitulo,
              tempo: infoTempo,
              resumo: infoResumo,
              objetivo: infoObjetivo,
              contrapartida: infoContrapartida,
              resultadosEsperados: infoResultadosEsperados,
              areaTematica: infoAreaTematica,
              vinculo: infoVinculo,
              propostaConjunto: infoPropostaConjunto,
              dadosProponente: infoDadosProponente,
              empresaEnvolvida: infoEmpresaEnvolvida,
              equipeColaboradores: infoEquipeColaboradores,
              docId: docRef.id,
              editarDemanda: true));
    }
  }
}
