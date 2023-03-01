import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarFormInfoAdmin extends StatefulWidget {
  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String vinculo;
  final String resultadosEsperados;
  final String status;
  final DocumentSnapshot updateDados;

  const EditarFormInfoAdmin(
      this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.vinculo,
      this.resultadosEsperados,
      this.status,
      this.updateDados,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditarFormInfoState();
  }
}

class EditarFormInfoState extends State<EditarFormInfoAdmin> {
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
  late String _statusDemandaAtual;

  @override
  initState() {
    _statusDemandaAtual = widget.status;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Retornando os valores para os campos de texto
    _controladorTitulo.text = widget.titulo;
    _controladorTempoNecessario.text = widget.tempo;
    _controladorResumo.text = widget.resumo;
    _controladorObjetivo.text = widget.objetivo;
    _controladorContrapartida.text = widget.contrapartida;
    _controladorVinculo.text = widget.vinculo;
    _controladorResultadosEsperados.text = widget.resultadosEsperados;

    List<String> optionsStatus = [
      'registrado',
      'em análise',
      'aprovado',
      'indeferido'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Demanda"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditorTextFormField(_controladorTitulo, "Título da proposta",
                  "Título da Proposta", 1, 150, true),
              DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: 'O status da demanda atual',
                  hintText: 'Selecione o status da demanda atual',
                ),
                items: optionsStatus.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(Utils.toCapitalization(item)),
                  );
                }).toList(),
                onChanged: (statusValue) {
                  setState(() {
                    _statusDemandaAtual = statusValue as String;
                  });
                  debugPrint('$statusValue');
                },
                value: _statusDemandaAtual,
              ),
              Utils.addVerticalSpace(13),
              EditorTextFormField(
                  _controladorTempoNecessario,
                  "Informe o tempo necessário",
                  "Número de meses para ser realizada",
                  1,
                  150,
                  true),
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
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) =>
              //               DemandaReport(docid: widget.updateDados),
              //         ),
              //       );
              //     },
              //     child: const Text('Gerar PDF'))

              /*SizedBox(
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
                      });

                      // Caso não tenha erros de validação
                      if(!_valida){
                        _editarDemanda(context);
                      }
                    },
                    child: const Text("SALVAR MUDANÇAS")
                ),
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _editarDemanda(context);

              //SnackBar
              const SnackBar snackBar =
                  SnackBar(content: Text("A demanda foi editada com sucesso!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Icon(Icons.done)),
    );
  }

  void _editarDemanda(BuildContext context) {
    widget.updateDados.reference
        .update({
          'titulo': _controladorTitulo.text,
          'tempo': _controladorTempoNecessario.text,
          'resumo': _controladorResumo.text,
          'objetivo': _controladorObjetivo.text,
          'contrapartida': _controladorContrapartida.text,
          'vinculo': _controladorVinculo.text,
          'resultados_esperados': _controladorResultadosEsperados.text,
          // A demanda é atualizada para o status "aprovado" caso o administrador salve
          'status': _statusDemandaAtual
        })
        .then((value) =>
            debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) =>
            debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    //Retorna para a página com as demandas listadas
    Navigator.pop(context);
  }
}
