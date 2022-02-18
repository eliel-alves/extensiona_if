import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/screens/demanda_lista.dart';
import 'package:conditional_questions/conditional_questions.dart';

class EditarFormInfo extends StatefulWidget {

  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String vinculo;
  final String resultadosEsperados;
  final QueryDocumentSnapshot updateDados;

  const EditarFormInfo(this.titulo, this.tempo, this.resumo, this.objetivo, this.contrapartida, this.vinculo, this.resultadosEsperados, this.updateDados);

  @override
  State<StatefulWidget> createState() {
    return EditarFormInfoState();
  }

}

class EditarFormInfoState extends State<EditarFormInfo> {

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTempoNecessario = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorObjetivo = TextEditingController();
  final TextEditingController _controladorContrapartida = TextEditingController();
  final TextEditingController _controladorVinculo = TextEditingController();
  final TextEditingController _controladorResultadosEsperados = TextEditingController();

  bool _valida = false;

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
        actions: [
          SizedBox(
            width: 80,
            child: IconButton (
              icon: Icon(Icons.delete, color: AppTheme.colors.red, size: 32),
              tooltip: 'Remover Proposta',
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
                            // Deletando demanda do Firebase
                            debugPrint('Foi deletado a proposta');
                            widget.updateDados.reference.delete();

                            // Voltando para a página da lista de Demandas
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ListaDemanda();
                            }));

                            // SnackBar
                            const SnackBar snackBar = SnackBar(content: Text("A proposta foi deletada com sucesso! "));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: const Text('Sim'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            debugPrint('Não foi deletado a proposta');
                          },
                          child: const Text('Não'),
                        ),
                      ],
                    );
                  }
                );
              },
            ),
          )

        ],
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
                    });

                    // Caso não tenha erros de validação
                    if(!_valida){
                      _editarDemanda(context);
                    }
                  },
                  child: const Text("SALVAR MUDANÇAS")
              ),
            ),
          ],
        ),
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
      'resultados_esperados': _controladorResultadosEsperados.text
    }).then((value) => debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("A demanda foi editada com sucesso!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}



