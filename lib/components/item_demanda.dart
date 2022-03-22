import 'package:extensiona_if/data/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:extensiona_if/screens/demanda_edit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';


class ItemDemanda extends StatelessWidget {
  ItemDemanda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera o Usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    // Recupera a lista de Demandas do usuário
    final Stream<QuerySnapshot> colecaoDemandas =
    FirebaseFirestore.instance.collection('DEMANDAS').where('usuario', isEqualTo: userDao.userId()).snapshots();

    return StreamBuilder<QuerySnapshot> (
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
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center (
            child: SpinKitFadingCircle(color: Colors.green, size: 120),
          );
        }

        final data = snapshot.requireData;

        return AnimationLimiter(
          child: ListView.builder(
              itemCount: data.size,
              padding: const EdgeInsets.all(16.0),
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
                final infoResultadosEsperados = data.docs[index]['resultados_esperados'];
                final infoAreaTematica = data.docs[index]['area_tematica'];
                final infoPropostaConjunto = data.docs[index]['proposta_conjunto'];
                final infoDadosProponete = data.docs[index]['dados_proponente'];
                final infoEmpresaEnvolvida = data.docs[index]['empresa_envolvida'];
                final infoEquipeColaboradores = data.docs[index]['equipe_colaboradores'];
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
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),

                                child: ListTile(
                                  leading: const Icon(Icons.add_circle_outline),
                                  title: Text(infoTitulo),
                                  subtitle: Text(infoTempo),
                                  trailing: SizedBox(
                                    width: 50,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton (
                                          icon: const Icon(Icons.edit, color: Colors.green, size: 32),
                                          tooltip: 'Editar proposta',
                                          onPressed: () {
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
                                                  infoDadosProponete,
                                                  infoEmpresaEnvolvida,
                                                  infoEquipeColaboradores,
                                                  updateDados);
                                            }));

                                            future.then((demandaAtualizada) {
                                              debugPrint("$demandaAtualizada");
                                              debugPrint('A proposta foi alterada');
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
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
}