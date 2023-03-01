import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/*class Editor extends StatelessWidget {
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
}*/

class EditorTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int lines;
  final String labelText;
  final String dica;
  final bool validaField;

  const EditorTextFormField(this.controller, this.labelText, this.dica,
      this.lines, this.maxLength, this.validaField,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, bottom: 13),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: lines,
        style: const TextStyle(
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: dica,
          helperText: dica,
          border: const OutlineInputBorder(),
        ),
        validator: validaField
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo Obrigatório!';
                }
                return null;
              }
            : null,
      ),
    );
  }
}

class EditorAuth extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final Icon icon;
  final int qtdCaracteres;
  final bool verSenha;
  final bool confirmPasswordField;
  final bool maskField;
  final bool validateField;
  final FormFieldValidator validator;

  const EditorAuth(
      {super.key,
      required this.controlador,
      required this.rotulo,
      required this.dica,
      required this.icon,
      required this.qtdCaracteres,
      required this.verSenha,
      required this.confirmPasswordField,
      required this.maskField,
      required this.validateField,
      required this.validator});

  @override
  State<EditorAuth> createState() => _EditorAuthState();
}

class _EditorAuthState extends State<EditorAuth> {
  late bool _habilitaVerSenha;
  late bool _verSenha;
  //bool _validation;
  var maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');

  @override
  void initState() {
    super.initState();
    _habilitaVerSenha = widget.verSenha;
    _verSenha = widget.verSenha;
    // _validation = widget.validator;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
            //enabled: false,
            // readOnly: widget.readOnly,
            obscureText: _verSenha,
            controller: widget.controlador,
            keyboardType:
                widget.maskField ? TextInputType.number : TextInputType.text,
            inputFormatters: widget.maskField ? [maskPhone] : null,
            style: AppTheme.typo.formText,
            decoration: InputDecoration(
              fillColor: AppTheme.colors.offWhite,
              contentPadding: const EdgeInsets.all(23),
              floatingLabelStyle: TextStyle(
                  color: AppTheme.colors.dark, fontWeight: FontWeight.bold),
              suffixIconConstraints: const BoxConstraints(minWidth: 50),
              prefixIconConstraints: const BoxConstraints(minWidth: 50),
              labelStyle: AppTheme.typo.defaultBoldText,
              labelText: widget.rotulo,
              hintText: widget.dica,
              prefixIcon: widget.icon,
              suffixIcon: _habilitaVerSenha
                  ? (_verSenha
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              //Quando o usuário clicar nesse ícone, ele mudará para falso
                              debugPrint('Você está vendo a sua senha');
                              _verSenha = false;
                            });
                          },
                          icon: const ImageIcon(
                            AssetImage("lib/assets/img/eye_off.png"),
                          ))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              //Quando o usuário clicar neste ícone, ele mudará para verdadeiro
                              debugPrint('Você não está vendo a sua senha');
                              _verSenha = true;
                            });
                          },
                          icon: const ImageIcon(
                            AssetImage("lib/assets/img/eye.png"),
                          )))
                  : null,
              errorStyle: const TextStyle(
                  fontSize: 13, letterSpacing: 0, fontWeight: FontWeight.w500),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppTheme.colors.white, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
            validator: widget.validateField
                ? widget.validator
                : (value) {
                    return null;
                  }));
  }
}

// class CampoSelecaoArquivos extends StatelessWidget {
//   final IconData uploadIcone;
//   final String subText;
//   final String mainText;
//   final Function setUploadAction;
//   final TextStyle styleText;
//   final TextStyle styleTextFile;
//   final String fileName;

//   const CampoSelecaoArquivos(this.uploadIcone, this.subText, this.mainText,
//       this.setUploadAction, this.styleText, this.fileName, this.styleTextFile,
//       {Key key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DottedBorder(
//       borderType: BorderType.RRect,
//       radius: const Radius.circular(12),
//       color: Colors.black,
//       dashPattern: const [10, 5],
//       child: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(12)),
//         child: Container(
//           padding: const EdgeInsets.only(top: 20),
//           height: 150,
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(uploadIcone, size: 60),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(subText, style: GoogleFonts.cabin(textStyle: styleText)),
//                   GestureDetector(
//                     onTap: setUploadAction,
//                     child: Text(mainText,
//                         style: GoogleFonts.cabin(
//                             textStyle: styleText,
//                             color: Theme.of(context).colorScheme.primary)),
//                   )
//                 ],
//               ),
//               Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(fileName,
//                       style: GoogleFonts.cabin(textStyle: styleTextFile)))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
