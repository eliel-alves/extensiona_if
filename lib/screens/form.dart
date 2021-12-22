import 'package:extensiona_if/components/TextEditor.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/models/demanda.dart';

class FormDemanda extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FormDemandaState();
  }

}

class FormDemandaState extends State<FormDemanda> {

  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerTempo = TextEditingController();
  final TextEditingController _controllerResumo = TextEditingController();
  final TextEditingController _controllerObjetivo = TextEditingController();
  final TextEditingController _controllerContrapartida = TextEditingController();
  final TextEditingController _controllerVinculo = TextEditingController();

  // Validadores dos campos obrigatórios
  bool _validTitulo = false;
  bool _validTempo = false;
  bool _validResumo = false;
  bool _validObjetivo = false;
  bool _validVinculo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Nova Demanda")),
      body: SingleChildScrollView(
          child: Column (
            children: [

              /// Campos do Form

              // Campo Título
              TextEditor(_controllerTitulo, 'Título', 'Dê um nome para esta demanda',
                  Icons.title, 50, _validTitulo),

              // Campo Tempo
              TextEditor(_controllerTempo, 'Tempo', 'Número de meses para ser realizada',
                  Icons.timer_outlined, 25, _validTempo),

              // Campo Resumo
              TextEditor(_controllerResumo, 'Resumo', 'Escreva um resumo do que será o projeto',
                  Icons.message_outlined, 600, _validResumo),

              // Campo Objetivo
              TextEditor(_controllerObjetivo, 'Objetivo', 'Qual o objetivo do projeto?',
                  Icons.control_point, 250, _validObjetivo),

              // Campo Contrapartida
              TextEditor(_controllerContrapartida, 'Contrapartida', 'Qual o envolvimento da comunidade na proposta?',
                  Icons.content_paste, 100, false),

              // Campo Vínculo
              TextEditor(_controllerVinculo, 'Vínculo', 'Qual o seu vínculo com a entidade parceira?',
                  Icons.insert_link, 50, _validVinculo),

              // Botão fim do Form
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 40.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Verifica se os controladores dos campos obrigatórios foram preenchidos
                      setState((){
                        _controllerTitulo.text.isEmpty ? _validTitulo = true : _validTitulo = false;
                        _controllerTempo.text.isEmpty ? _validTempo = true : _validTempo = false;
                        _controllerResumo.text.isEmpty ? _validResumo = true : _validResumo = false;
                        _controllerObjetivo.text.isEmpty ? _validObjetivo = true : _validObjetivo = false;
                        _controllerVinculo.text.isEmpty ? _validVinculo = true : _validVinculo = false;
                      });

                      // Verifica se todos os validadores dos controladores estão nulos
                      if(!_validTitulo && !_validTempo && !_validResumo && !_validObjetivo && !_validVinculo){
                        _createDemanda(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Cadastrar Nova Demanda', style: TextStyle(fontSize: 18.0)),
                        Icon(Icons.add),
                      ],
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                      ),
                    )

                ),
              ),
            ],
          )
      ),
    );
  }

  void _createDemanda(BuildContext context) {
    print('Clicou no botão de cadastrar');

    final demandaCriada = Demanda(_controllerTitulo.text, DateTime.now(), _controllerTempo.text,
        _controllerResumo.text,'C', _controllerObjetivo.text,
        _controllerContrapartida.text, _controllerVinculo.text);
    debugPrint('Demanda criada: $demandaCriada');

    Navigator.pop(context, demandaCriada);

    final SnackBar snackBar = SnackBar(content: Text('Demanda criada com sucesso!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}