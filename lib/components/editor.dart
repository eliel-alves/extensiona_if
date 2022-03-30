import 'package:dotted_border/dotted_border.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final int lines;
  final bool valida;
  final int qtdCaracteres;

  const Editor(this.controlador, this.rotulo, this.dica, this.lines, this.valida, this.qtdCaracteres, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 13, bottom: 13),
        child: TextField(
          maxLength: qtdCaracteres,
          controller: controlador,
          style: const TextStyle(
            fontSize: 18.0,
          ),
          maxLines: lines,
          decoration: InputDecoration(
            labelText: rotulo,
            hintText: dica,
            helperText: dica,
            errorText: valida ? 'Campo obrigatório!' : null,
            border: const OutlineInputBorder(),
          ),
        )
    );
  }
}

class EditorAuth extends StatefulWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final String errorText;
  final Icon icon;
  final bool valida;
  final int qtdCaracteres;
  final bool verSenha;

  EditorAuth(this.controlador, this.rotulo, this.dica, this.icon, this.valida, this.qtdCaracteres, this.verSenha, this.errorText);

  @override
  State<EditorAuth> createState() => _EditorAuthState();
}

class _EditorAuthState extends State<EditorAuth> {

  bool _habilitaVerSenha;
  bool _verSenha;

  @override
  void initState() {
    super.initState();
    _habilitaVerSenha = widget.verSenha;
    _verSenha = widget.verSenha;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 6),
      child: TextField(
        obscureText: _verSenha,
        controller: widget.controlador,
        style: AppTheme.typo.defaultText,
        decoration: InputDecoration(
          labelStyle: AppTheme.typo.defaultText,
          labelText: widget.rotulo,
          hintText: widget.dica,
          prefixIcon: widget.icon,
          suffixIcon: _habilitaVerSenha ? (
              _verSenha ?
          IconButton(
              onPressed: () {
                setState(() {
                  //Quando o usuário clicar nesse ícone, ele mudará para falso
                  debugPrint('Você está vendo a sua senha');
                  _verSenha = false;
                });
              },
              icon: const Icon(Ionicons.md_eye_off)
          )
              :
              IconButton(
                  onPressed: () {
                      setState(() {
                        //Quando o usuário clicar nesse ícone, ele mudará para verdadeiro
                        debugPrint('Você não está vendo a sua senha');
                        _verSenha = true;
                      });
                  },
                  icon: const Icon(Ionicons.md_eye)
              )
      ) : null,
          errorText: widget.valida ? widget.errorText : null,
          border: const OutlineInputBorder()
        ),
      ),
    );
  }
}

class CampoSelecaoArquivos extends StatelessWidget{

  final IconData uploadIcone;
  final String subText;
  final String mainText;
  final Function setUploadAction;
  final TextStyle styleText;
  final TextStyle styleTextFile;
  final String fileName;

  const CampoSelecaoArquivos(this.uploadIcone, this.subText, this.mainText, this.setUploadAction, this.styleText, this.fileName, this.styleTextFile);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      color: Colors.black,
      dashPattern: const [10, 5],
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          height: 150,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(uploadIcone, size: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      subText,
                      style: GoogleFonts.cabin(textStyle: styleText)),

                  GestureDetector(
                    onTap: setUploadAction,
                    child: Text(
                        mainText,
                        style: GoogleFonts.cabin(textStyle: styleText, color: Theme.of(context).colorScheme.primary)),
                  )
                ],
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(fileName, style: GoogleFonts.cabin(textStyle: styleTextFile))
              )
            ],
          ),
        ),
      ),

    );
  }

}

