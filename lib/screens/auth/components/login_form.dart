import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/validation/validation.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginForm(
      {Key? key,
      required this.emailController,
      required this.passwordController,
      required this.formKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorAuth(
            controlador: emailController,
            rotulo: 'Email',
            dica: 'Informe o seu email',
            icon: const Icon(Icons.mail_outlined),
            qtdCaracteres: 50,
            verSenha: false,
            confirmPasswordField: false,
            maskField: false,
            validateField: true,
            validator: FormValidation.validateEmail(),
          ),
          EditorAuth(
            controlador: passwordController,
            rotulo: 'Senha',
            dica: 'Informe a sua senha',
            icon: const Icon(Icons.key_rounded),
            qtdCaracteres: 10,
            verSenha: true,
            confirmPasswordField: false,
            maskField: false,
            validateField: true,
            validator: FormValidation.validateField(),
          ),
        ],
      ),
    );
  }
}
