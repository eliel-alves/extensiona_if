import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/validation/validation.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditarInfoUsuario extends StatefulWidget {
  final String titulo;
  final String conteudo;
  final String rotulo;
  final String dica;
  final String errorText;
  final Icon icon;
  final int qtdCaracteres;
  final bool maskField;
  final bool validator;
  final String docId;
  final String dbName;

  const EditarInfoUsuario(
      {super.key,
      required this.titulo,
      required this.conteudo,
      required this.rotulo,
      required this.dica,
      required this.errorText,
      required this.icon,
      required this.qtdCaracteres,
      required this.maskField,
      required this.validator,
      required this.docId,
      required this.dbName});

  @override
  State<EditarInfoUsuario> createState() => _EditarInfoUsuarioState();
}

class _EditarInfoUsuarioState extends State<EditarInfoUsuario> {
  final TextEditingController _controlador = TextEditingController();
  bool editandoInfo = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _controlador.text = widget.conteudo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDAO auth = Provider.of<UserDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo, style: AppTheme.typo.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            !editandoInfo
                ? CardInfo(
                    titulo: widget.titulo,
                    conteudo: widget.conteudo,
                    onTap: () {
                      setState(() {
                        editandoInfo = true;
                      });
                    })
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EditorAuth(
                          controlador: _controlador,
                          rotulo: widget.rotulo,
                          dica: widget.dica,
                          icon: widget.icon,
                          qtdCaracteres: widget.qtdCaracteres,
                          verSenha: false,
                          confirmPasswordField: false,
                          maskField: widget.maskField,
                          validateField: true,
                          validator: FormValidation.validateField(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editandoInfo = false;
                                  });
                                },
                                child: const Text('Cancelar')),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_controlador.text.isNotEmpty) {
                                      debugPrint('editou a informação');
                                    }

                                    final doc = await FirebaseFirestore.instance
                                        .collection('USUARIOS')
                                        .doc(widget.docId)
                                        .get();

                                    doc.reference.update(
                                        {widget.dbName: _controlador.text});

                                    if (widget.dbName == 'email') {
                                      auth.usuario!
                                          .updateEmail(_controlador.text);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Salvar'))
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
