import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:extensiona_if/screens/demanda_edit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum options { deletar, atualizar}


class ItemDemanda extends StatelessWidget {
  const ItemDemanda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera o Usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    // Recupera a lista de Demandas do usuário
    final Stream<QuerySnapshot> colecaoDemandas =
    FirebaseFirestore.instance.collection('DEMANDAS').where(
        'usuario', isEqualTo: userDao.userId()).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: colecaoDemandas,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Ocorreu algum erro!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center (
            child: SpinKitFadingCircle(color: Colors.green, size: 120),
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
                final infoData = data.docs[index]['data'];
                final infoStatus = data.docs[index]['status'];
                final infoResumo = data.docs[index]['resumo'];
                final infoObjetivo = data.docs[index]['objetivo'];
                final infoContrapartida = data.docs[index]['contrapartida'];
                final infoVinculo = data.docs[index]['vinculo'];
                final infoResultadosEsperados = data
                    .docs[index]['resultados_esperados'];
                final infoAreaTematica = data.docs[index]['area_tematica'];
                final infoPropostaConjunto = data
                    .docs[index]['proposta_conjunto'];
                final infoDadosProponente = data
                    .docs[index]['dados_proponente'];
                final infoEmpresaEnvolvida = data
                    .docs[index]['empresa_envolvida'];
                final infoEquipeColaboradores = data
                    .docs[index]['equipe_colaboradores'];
                final updateDados = snapshot.data.docs[index];

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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10)),
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
                                  ]
                              ),
                              title: Text(infoTitulo),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                    children: [
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
                                      Text(
                                          infoStatus[0]
                                              .toString()
                                              .toUpperCase() +
                                              infoStatus.toString().substring(
                                                  1, infoStatus
                                                  .toString()
                                                  .length)
                                      ),
                                    ] //     Text(DateTime(infoData).year.toString());
                                ),
                              ),
                              trailing: PopupMenuButton<options>(
                                onSelected: (options choice) {
                                  debugPrint(choice.name);
                                  choiceAction(
                                    choice.name,
                                    context,
                                    updateDados,
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
                                    infoEquipeColaboradores,);
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<options>>[
                                    if(infoStatus == 'registrado') ... [
                                      const PopupMenuItem<options>(
                                        value: options.deletar,
                                        child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Deletar')
                                        ),
                                      ),
                                    ],

                                    const PopupMenuItem<options>(
                                      value: options.atualizar,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Atualizar'),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            )
                        ),
                      ),
                    )
                );
              }),
        );
      },
    );
  }

  void choiceAction(String choice,
      BuildContext context,
      QueryDocumentSnapshot updateData,
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
      infoEquipeColaboradores) {
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
                  onPressed: () {
                    //Deletando o documento do banco de dados
                    debugPrint('A atividade foi deletada');
                    updateData.reference.delete();

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
          }
      );
    } else if (choice == 'atualizar') {
      //Navegar para a tela de edição de demandas
      final Future future =
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditarFormInfo(
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
            updateData
        );
      }));

      future.then((demandaAtualizada) {
        // debugPrint(demandaAtualizada);
        debugPrint('A proposta foi alterada');
      });
    }
  }

}