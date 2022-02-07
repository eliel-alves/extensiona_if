import 'package:extensiona_if/data/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:extensiona_if/models/demanda.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FormDemanda extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FormDemandaState();
  }

}

class FormDemandaState extends State<FormDemanda>{

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorVinculo = TextEditingController();
  final TextEditingController _controladorResultadosEsperados = TextEditingController();

  final List<String> buttonOptions = [
    'Comunicação',
    'Cultura',
    'Direitos Humanos e Justiça',
    'Educação',
    'Meio Ambiente',
    'Saúde',
    'Tecnologia e Produção',
    ' Trabalho'
  ];

  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);

  String hintText = 'Selecione a área temática';

  bool _valida = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Formulário de Cadastro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Editor(_controladorTitulo, "Título da proposta", "Título da Proposta", 1, _valida, 150),

            Editor(_controladorTempoNecessario, "Informe o tempo necessário", "Número de meses para ser realizada", 1, _valida, 150),

            Editor(_controladorResumo, "Faça uma breve descrição da sua proposta",
                "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, _valida, 600),

            Editor(_controladorObjetivo, "Descreva os objetivos que você espera serem atendidos",
                "Coloque em forma de tópicos os objetivos da proposta", 5, _valida, 600),

            Editor(_controladorContrapartida, "Quais recursos a equipe dispõe para a execução da proposta?",
                "Descreva quais recursos estão disponíveis para a execução da proposta, financeiros, humanos, estrutura, etc", 5, _valida, 600),

            Editor(_controladorVinculo, "Qual o seu vínculo com o projeto?",
                "Descreva qual o seu vínculo com a entidade parceira envolvida com este projeto", 1, _valida, 100),

            Editor(_controladorResultadosEsperados, "Quais os resultados esperados?  ",
                "Descreva os resultados esperados", 5, false, 600),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
              alignment: Alignment.centerLeft,
                    child: Text('Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                        style: GoogleFonts.cabin(textStyle: style),
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      helperText: 'Qual a área do conhecimento que você acha que mais se aproxima da sua proposta?',
                      hintText: hintText,
                    ),
                    items: buttonOptions.map((options) {
                      return DropdownMenuItem(
                        value: options,
                        child: Text(options),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => optionSelected = value),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
                      _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
                      _controladorVinculo.text.isEmpty ? _valida = true : _valida = false;
                      //optionSelected.isEmpty ? _valida = true : _valida = false;
                    });

                    // Caso não tenha erros de validação
                    if(!_valida){
                      _criarDemanda(context);
                    }
                  },
                  child: const Text("CONFIRMAR")
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _criarDemanda(BuildContext context) {
    // Recupera o usuário
    final userDao = Provider.of<UserDAO>(context, listen: false);

    // Recupera a coleção
    CollectionReference colecaoDemandas = FirebaseFirestore.instance.collection('DEMANDAS');

    //Adicionando um novo documento a nossa coleção -> Demandas
    colecaoDemandas.add({
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
      'area_tematica': optionSelected,
    })
        .then((value) => debugPrint("Sua proposta foi registrada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    //Limpando os campos após a criação da proposta
    _controladorTitulo.text = '';
    _controladorTempoNecessario.text = '';
    _controladorResumo.text = '';
    _controladorObjetivo.text = '';
    _controladorContrapartida.text = '';
    _controladorVinculo.text = '';
    _controladorResultadosEsperados.text = '';

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("Sua demanda foi criada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}