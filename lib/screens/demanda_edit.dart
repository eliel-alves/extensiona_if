
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_questions/conditional_questions.dart';

class EditarFormInfo extends StatefulWidget {

  final String titulo;
  final String tempo;
  final String resumo;
  final String objetivo;
  final String contrapartida;
  final String vinculo;
  final String resultadosEsperados;
  final String propostaConjunto;
  final String dadosProponente;
  final String empresaEnvolvida;
  final String equipeColaboradores;
  final QueryDocumentSnapshot updateDados;

  const EditarFormInfo(
      this.titulo,
      this.tempo,
      this.resumo,
      this.objetivo,
      this.contrapartida,
      this.vinculo,
      this.resultadosEsperados,
      this.propostaConjunto,
      this.dadosProponente,
      this.empresaEnvolvida,
      this.equipeColaboradores,
      this.updateDados);

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
  final TextEditingController _controladorPropostaConjunto = TextEditingController();
  final TextEditingController _controladorDadosProponente = TextEditingController();
  final TextEditingController _controladorEmpresaEnvolvida = TextEditingController();
  final TextEditingController _controladorEquipeColaboradores = TextEditingController();

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
    _controladorPropostaConjunto.text = widget.propostaConjunto;
    _controladorDadosProponente.text = widget.dadosProponente;
    _controladorEmpresaEnvolvida.text = widget.empresaEnvolvida;
    _controladorEquipeColaboradores.text = widget.equipeColaboradores;

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

              EditorTextFormField(_controladorTitulo, "T??tulo da proposta", "T??tulo da Proposta", 1, 150, true),

              EditorTextFormField(_controladorTempoNecessario, "Informe o tempo necess??rio", "N??mero de meses para ser realizada", 1, 150, true),

              EditorTextFormField(_controladorResumo, "Fa??a uma breve descri????o da sua proposta",
                  "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, 600, true),

              EditorTextFormField(_controladorObjetivo, "Descreva os objetivos que voc?? espera serem atendidos",
                  "Coloque em forma de t??picos os objetivos da proposta", 5, 600, true),

              EditorTextFormField(_controladorContrapartida, "Quais recursos a equipe disp??e para a execu????o da proposta?",
                  "Descreva quais recursos est??o dispon??veis para a execu????o da proposta, financeiros, humanos, estrutura, etc", 5, 600, true),

              EditorTextFormField(_controladorVinculo, "Qual o seu v??nculo com o projeto?",
                  "Descreva qual o seu v??nculo com a entidade parceira envolvida com este projeto", 1, 100, true),

              EditorTextFormField(_controladorResultadosEsperados, "Quais os resultados esperados?  ",
                  "Descreva os resultados esperados", 5, 600, true),

              EditorTextFormField(_controladorPropostaConjunto, "Por que a proposta faz jus a uma a????o em conjunto?  ",
                  "Por que precisa da Institui????o de Ensino?", 7, 600, true),

              EditorTextFormField(_controladorDadosProponente, "Dados do Proponente?  ",
                  "Dados Gerais, est?? vinculado a qual institui????o/empresa?", 7, 600, true),

              EditorTextFormField(_controladorEmpresaEnvolvida, "Quais ser??o as institui????es / empresas envolvidas na proposta?  ",
                  "Institui????es/empresas parceiras?", 7, 600, true),

              EditorTextFormField(_controladorEquipeColaboradores, "Quem ser?? a equipe de colaboradores externos?  ",
                  "Nome, forma????o, dados gerais, etc, ", 7, 600, true),

              // SizedBox(
              //   height: 40,
              //   width: double.infinity,
              //   // child: ElevatedButton(
              //   //     onPressed: (){
              //   //       setState((){
              //   //         _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorVinculo.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorPropostaConjunto.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorDadosProponete.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorEmpresaEnvolvida.text.isEmpty ? _valida = true : _valida = false;
              //   //         _controladorEquipeColaboradores.text.isEmpty ? _valida = true : _valida = false;
              //   //       });
              //   //
              //   //       // Caso n??o tenha erros de valida????o
              //   //       if(!_valida){
              //   //         _editarDemanda(context);
              //   //       }
              //   //     },
              //   //     child: const Text("SALVAR MUDAN??AS")
              //   // ),
              // ),
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
          /*setState((){
            _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
            _controladorTempoNecessario.text.isEmpty ? _valida = true : _valida = false;
            _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
            _controladorObjetivo.text.isEmpty ? _valida = true : _valida = false;
            _controladorContrapartida.text.isEmpty ? _valida = true : _valida = false;
            _controladorVinculo.text.isEmpty ? _valida = true : _valida = false;
            _controladorPropostaConjunto.text.isEmpty ? _valida = true : _valida = false;
            _controladorDadosProponente.text.isEmpty ? _valida = true : _valida = false;
            _controladorEmpresaEnvolvida.text.isEmpty ? _valida = true : _valida = false;
            _controladorEquipeColaboradores.text.isEmpty ? _valida = true : _valida = false;
          });

          // Caso n??o tenha erros de valida????o
          if(!_valida){
            _editarDemanda(context);
          }*/
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
      'resultados_esperados': _controladorResultadosEsperados.text,
      'proposta_conjunto': _controladorPropostaConjunto.text,
      'dados_proponente': _controladorDadosProponente.text,
      'empresa_envolvida': _controladorEmpresaEnvolvida.text,
      'equipe_colaboradores': _controladorEquipeColaboradores.text,
    }).then((value) => debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));


    //Retorna para a p??gina com as demandas listadas
    Navigator.pop(context);
  }
}



