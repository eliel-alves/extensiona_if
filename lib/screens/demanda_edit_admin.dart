
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_questions/conditional_questions.dart';

class EditarFormInfoAdmin extends StatefulWidget {

  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String vinculo;
  final String resultadosEsperados;
  final QueryDocumentSnapshot updateDados;

  const EditarFormInfoAdmin(
      this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.vinculo,
      this.resultadosEsperados,
      this.updateDados);

  @override
  State<StatefulWidget> createState() {
    return EditarFormInfoState();
  }

}

class EditarFormInfoState extends State<EditarFormInfoAdmin> {

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorVinculo = TextEditingController();
  final TextEditingController _controladorResultadosEsperados = TextEditingController();

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

              EditorTextFormField(_controladorTitulo, "Título da proposta", "Título da Proposta", 1, 150, true),

              EditorTextFormField(_controladorTempoNecessario, "Informe o tempo necessário", "Número de meses para ser realizada", 1, 150, true),

              EditorTextFormField(_controladorResumo, "Faça uma breve descrição da sua proposta",
                  "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, 600, true),

              EditorTextFormField(_controladorObjetivo, "Descreva os objetivos que você espera serem atendidos",
                  "Coloque em forma de tópicos os objetivos da proposta", 5, 600, true),

              EditorTextFormField(_controladorContrapartida, "Quais recursos a equipe dispõe para a execução da proposta?",
                  "Descreva quais recursos estão disponíveis para a execução da proposta, financeiros, humanos, estrutura, etc", 5, 600, true),

              EditorTextFormField(_controladorVinculo, "Qual o seu vínculo com o projeto?",
                  "Descreva qual o seu vínculo com a entidade parceira envolvida com este projeto", 1, 100, true),

              EditorTextFormField(_controladorResultadosEsperados, "Quais os resultados esperados?  ",
                  "Descreva os resultados esperados", 5, 600, false),

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
          onPressed: (){
            if (_formKey.currentState.validate()) {

              _editarDemanda(context);

              //SnackBar
              const SnackBar snackBar = SnackBar(content: Text("A demanda foi editada com sucesso!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Icon(Icons.done)
      ),
    );

  }

  void _editarDemanda(BuildContext context) {

    widget.updateDados.reference.update({
      'titulo': _controladorTitulo.text,
      'tempo': _controladorTempoNecessario.text,
      'resumo': _controladorResumo.text,
      'objetivo': _controladorObjetivo.text,
      'contrapartida': _controladorContrapartida.text,
      'vinculo': _controladorVinculo.text,
      'resultados_esperados': _controladorResultadosEsperados.text,
      'status': 'aprovado'
    }).then((value) => debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));


    //Retorna para a página com as demandas listadas
    Navigator.pop(context);
  }
}



