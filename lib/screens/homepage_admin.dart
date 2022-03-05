import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/models/demanda.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Propostas registradas pelos usuários"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
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
                fillColor: const Color.fromRGBO(64, 64, 64, 0.4),
              ),
            ),
          ),

          ListView.builder(
              itemCount: _resultsList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {

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
                        leading: Icon(Icons.assignment_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .primary),
                        textColor: Colors.black,
                        title: Text(_resultsList[index]['titulo']),
                        subtitle: Text(_resultsList[index]['tempo'],
                            style: const TextStyle(
                                color: Colors.black45)),
                        trailing: SizedBox(
                          width: 50,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    size: 32),
                                tooltip: 'Editar proposta',
                                onPressed: () {
                                  debugPrint('consultou a demanda');
                                },
                              ),
                            ],
                          ),
                        )));
              }),
        ],
      ),
    );
  }
}