
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
  final String dadosProponete;
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
      this.dadosProponete,
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
  final TextEditingController _controladorDadosProponete = TextEditingController();
  final TextEditingController _controladorEmpresaEnvolvida = TextEditingController();
  final TextEditingController _controladorEquipeColaboradores = TextEditingController();

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
    _controladorPropostaConjunto.text = widget.propostaConjunto;
    _controladorDadosProponete.text = widget.dadosProponete;
    _controladorEmpresaEnvolvida.text = widget.empresaEnvolvida;
    _controladorEquipeColaboradores.text = widget.equipeColaboradores;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Atualizar Demanda"),
        elevation: 0,
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

            Editor(_controladorPropostaConjunto, "Por que a proposta faz jus a uma ação em conjunto?  ",
                "Por que precisa da Instituição de Ensino?", 7, _valida, 600),

            Editor(_controladorDadosProponete, "Dados do Proponente?  ",
                "Dados Gerais, está vinculado a qual instituição/empresa?", 7, _valida, 600),

            Editor(_controladorEmpresaEnvolvida, "Quais serão as instituições / empresas envolvidas na proposta?  ",
                "Instituições/empresas parceiras?", 7, _valida, 600),

            Editor(_controladorEquipeColaboradores, "Quem será a equipe de colaboradores externos?  ",
                "Nome, formação, dados gerais, etc, ", 7, _valida, 600),

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
                      _controladorPropostaConjunto.text.isEmpty ? _valida = true : _valida = false;
                      _controladorDadosProponete.text.isEmpty ? _valida = true : _valida = false;
                      _controladorEmpresaEnvolvida.text.isEmpty ? _valida = true : _valida = false;
                      _controladorEquipeColaboradores.text.isEmpty ? _valida = true : _valida = false;
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
      'resultados_esperados': _controladorResultadosEsperados.text,
      'proposta_conjunto': _controladorPropostaConjunto.text,
      'dados_proponente': _controladorDadosProponete.text,
      'empresa_envolvida': _controladorEmpresaEnvolvida.text,
      'equipe_colaboradores': _controladorEquipeColaboradores.text,
    }).then((value) => debugPrint("Sua proposta foi atualizada no banco de dados"))
        .catchError((error) => debugPrint("Ocorreu um erro ao registrar sua demanda: $error"));


    //Retorna para a página com as demandas listadas
    Navigator.pop(context);

    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("A demanda foi editada com sucesso!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}



