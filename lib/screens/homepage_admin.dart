import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/demanda_edit_admin.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _filterController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  ///Chama a função que verifica qualquer mudança no que foi digitado no TextFild
  @override
  void initState() {
    super.initState();
    _filterController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _filterController.removeListener(_onSearchChanged);
    _filterController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = pegaDadosDemandaStreamSnapshots();
  }

  ///Detecta o que foi digitado pelo usuário
  _onSearchChanged() {
    searchResultsList();
  }

  ///Função responsável por filtrar as demandas cadastradas pela área temática de cada demanda
  searchResultsList() {
    //Esse vetor ira armazenar todos os resultados encontrados durante a pesquisa
    var mostrarResultados = [];

    //Caso o usuário tenha digitado alguma coisa no TextField
    if(_filterController.text != "") {
      for(var dataSnapshot in _allResults){
        //Pega as áreas temáticas de todos os documentos registrados no Firebase
        var areaTematica = Demandas.fromSnapshot(dataSnapshot).AreaTematica.toLowerCase();

        //Caso o usuário tenha pesquisado por uma área existente, será apresentado todas as demandas registradas com essa área temática
        if(areaTematica.contains(_filterController.text.toLowerCase())) {
          //Adiciona as demandas encontradas ao vetor mostrarResultados
          mostrarResultados.add(dataSnapshot);
        }
      }
      //Caso contrário, será apresentado o vetor que contém todas as demandas cadastradas no banco do Firebase
    } else {
      mostrarResultados = List.from(_allResults);
    }

    setState(() {
      _resultsList = mostrarResultados;
    });
  }

  ///Função que pega os documentos da coleção Demandas e passa para uma lista
  pegaDadosDemandaStreamSnapshots() async {
    List<QueryDocumentSnapshot> listaDeDocumentos = (await FirebaseFirestore.instance
        .collection("DEMANDAS")
        .get())
        .docs;

    setState(() {
      _allResults = listaDeDocumentos;
    });

    //Chama a função que traz os resultados da pesquisa feita
    searchResultsList();
  }

  final List<AreaTematica> _optionsAreaTematica = [
    AreaTematica(id: 1, name: 'Comunicação'),
    AreaTematica(id: 2, name: 'Cultura'),
    AreaTematica(id: 3, name: 'Direitos Humanos e Justiça'),
    AreaTematica(id: 4, name: 'Educação'),
    AreaTematica(id: 5, name: 'Meio Ambiente'),
    AreaTematica(id: 6, name: 'Saúde'),
    AreaTematica(id: 7, name: 'Tecnologia e Produção'),
    AreaTematica(id: 8, name: 'Trabalho')
  ];


  @override
  Widget build(BuildContext context) {

    final userDao = Provider.of<UserDAO>(context, listen: false);

    final _items = _optionsAreaTematica.map((areaTematica) => MultiSelectItem<AreaTematica>(areaTematica, areaTematica.name))
        .toList();

    List<AreaTematica> _selectedValue = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Propostas registradas", style: AppTheme.typo.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                userDao.logout();
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Pesquise por uma área temática',
                  helperText:
                  'Procure por demandas cadastradas através de sua área temática',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: MultiSelectDialogField(
                items: _items,
                title: Text("Selecionar áreas temáticas", style: AppTheme.typo.defaultText),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                buttonIcon: Icon(FontAwesome.chevron_circle_down, color: Theme.of(context).colorScheme.primary),
                buttonText: Text("Áreas Temáticas", style: AppTheme.typo.button),
                onConfirm: (results) {
                  _selectedValue = results;
                },
                chipDisplay: MultiSelectChipDisplay<AreaTematica>(
                  items: _selectedValue.map((e) => MultiSelectItem(e, e.name)).toList(),
                  onTap: (value) {
                    setState(() {
                      debugPrint(value.name.toLowerCase());
                      _selectedValue.remove(value);
                    });
                  },
                ),
              ),
            ),

            ListView.builder(
                itemCount: _resultsList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int index) {

                  //Pegando as informações dos documentos do firebase da coleção Demandas
                  final infoTitulo = _resultsList[index]['titulo'];
                  final infoTempo = _resultsList[index]['tempo'];
                  //final infoStatus = _resultsList[index]['status'];
                  final infoResumo = _resultsList[index]['resumo'];
                  final infoObjetivo = _resultsList[index]['objetivo'];
                  final infoContrapartida = _resultsList[index]['contrapartida'];
                  final infoVinculo = _resultsList[index]['vinculo'];
                  final infoResultadosEsperados = _resultsList[index]['resultados_esperados'];
                 // final infoAreaTematica = _resultsList[index]['area_tematica'];
                  final updateDados = _resultsList[index];

                  return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                          leading: const Icon(FontAwesome.file),
                          title: Text(infoTitulo),
                          subtitle: Text(infoTempo, style: const TextStyle(color: Colors.black45)),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(FontAwesome.pencil, size: 25),
                                  tooltip: 'Editar proposta',
                                  onPressed: () {
                                    debugPrint('consultou a demanda');
                                    final Future future =
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return EditarFormInfoAdmin(infoTitulo, infoTempo, infoResumo, infoObjetivo, infoContrapartida, infoVinculo, infoResultadosEsperados, updateDados);
                                    }));

                                    future.then((demandaAtualizada) {
                                      debugPrint("$demandaAtualizada");
                                      debugPrint('A proposta foi alterada');
                                    });
                                  },
                                ),


                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Deletar Proposta'),
                                            content: const Text('Você deseja deletar esta proposta?'),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                            actions: <Widget> [
                                              TextButton(
                                                onPressed: (){
                                                  //Deleta a proposta cadastrada no Firebase
                                                  debugPrint('Foi deletado a proposta');
                                                  updateDados.reference.delete();

                                                  //Fecha a janela de exclusão
                                                  Navigator.pop(context);

                                                  //Dispara um SnackBar
                                                  const SnackBar snackBar = SnackBar(content: Text("A proposta foi deletada com sucesso! "));
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                        }
                                    );
                                  },
                                  tooltip: 'Remover Proposta',
                                  icon: const Icon(FontAwesome.trash, size: 25),
                                )
                              ],
                            ),
                          )));
                }),
          ],
        ),
      ),
    );
  }
}

class AreaTematica {
  final int id;
  final String name;

  AreaTematica({
    this.id,
    this.name,
  });
}