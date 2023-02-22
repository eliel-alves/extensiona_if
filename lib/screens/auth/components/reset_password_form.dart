import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/validation/validation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';

class ResetPasswordForm extends StatefulWidget {
  final Function() sendLink;
  final Function() goBack;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  const ResetPasswordForm(
      {Key key, this.sendLink, this.goBack, this.formKey, this.controller})
      : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Recuperar senha',
                style:
                    AppTheme.typo.extraBold(30, AppTheme.colors.dark, 1, -1.5)),
            Utils.addVerticalSpace(20),
            Text(
                'Um link de recuperação de senha será enviado para o endereço de e-mail fornecido por você.',
                textAlign: TextAlign.center,
                style: AppTheme.typo.regular(15, AppTheme.colors.dark, 1.5, 1)),
            Utils.addVerticalSpace(30),
            EditorAuth(
              controlador: widget.controller,
              rotulo: 'Email',
              dica: 'Informe o seu email',
              icon: const Icon(Icons.mail_outline),
              qtdCaracteres: 50,
              verSenha: false,
              confirmPasswordField: false,
              maskField: false,
              validateField: true,
              validator: FormValidation.validateEmail(),
            ),
            Utils.addVerticalSpace(10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.sendLink,
                child: Text('Enviar', style: AppTheme.typo.button),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppTheme.colors.blue,
                    padding: const EdgeInsets.all(23),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Utils.addVerticalSpace(20),
            TextButton(
                onPressed: widget.goBack,
                child: Text(
                  'Voltar para o login',
                  style: AppTheme.typo.medium(14, AppTheme.colors.blue, 1, 0),
                ))
          ],
        ),
      ),
    );
  }
}
