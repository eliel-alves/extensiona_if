import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/validation/validation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

Future<void> reauthenticateBox({
  BuildContext context,
  String title,
  Function action,
  String label,
  GlobalKey<FormState> formKey,
  TextEditingController controller,
}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: AppTheme.typo.bold(16, AppTheme.colors.dark, 1.5, 1),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    avatar: Icon(
                      Icons.account_circle_outlined,
                      color: AppTheme.colors.dark,
                    ),
                    backgroundColor: AppTheme.colors.light,
                    label: Text(
                      label,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Utils.addVerticalSpace(15),
                  Text(
                    'Para continuar, primeiro confirme sua identidade',
                    textAlign: TextAlign.start,
                    style:
                        AppTheme.typo.regular(16, AppTheme.colors.dark, 1.5, 1),
                  ),
                  Utils.addVerticalSpace(16),
                  EditorAuth(
                    controlador: controller,
                    rotulo: 'Senha',
                    dica: 'Digite sua senha',
                    icon: const Icon(Ionicons.md_key),
                    qtdCaracteres: 20,
                    verSenha: true,
                    confirmPasswordField: false,
                    maskField: false,
                    validateField: true,
                    validator: FormValidation.validateField(),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: AppTheme.colors.lightGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCELAR',
                style: AppTheme.typo.medium(15, AppTheme.colors.blue, 1.5, 1),
              ),
            ),
            TextButton(
              onPressed: action,
              child: Text(
                'PROSSEGUIR',
                style: AppTheme.typo.medium(15, AppTheme.colors.blue, 1.5, 1),
              ),
            )
          ],
        );
      });
}
