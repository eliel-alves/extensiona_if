import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class RegisterUser extends StatefulWidget {
  final PageController pageController;

  const RegisterUser({Key key, this.pageController}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _valida = false;
  String validaMassage = 'Campo Obrigatório!';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            registerOrLogin(
                'Já possui uma conta?',
                'Entrar',
                    () {
                  widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                },
                context),

            EditorAuth(_nameController, 'Nome', 'Informe o seu nome', const Icon(Ionicons.md_person), _valida, 20, false, validaMassage),

            EditorAuth(_phoneController, 'Telefone', 'Informe o seu telefone', const Icon(Icons.phone), _valida, 20, false, validaMassage),

            EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Ionicons.md_mail), _valida, 30, false, validaMassage),

            EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Ionicons.md_key), _valida, 10, true, validaMassage),

            EditorAuth(_confirmPassword, 'Confirmar senha', 'Insira novamente a sua senha', const Icon(Ionicons.md_key), _valida, 10, true, 'Senha Incorreta! Verifique novamente a sua senha'),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nameController.text.isEmpty ? _valida = true : _valida = false;
                      _phoneController.text.isEmpty ? _valida = true : _valida = false;
                      _emailController.text.isEmpty ? _valida = true : _valida = false;
                      _passwordController.text.isEmpty ? _valida = true : _valida = false;
                      _confirmPassword.text != _passwordController.text ? _valida = true : _valida = false;
                    });

                    debugPrint('criar conta');

                    if(!_valida) {
                      authService.signup(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _phoneController.text,
                          context);
                    }
                  },
                  child: const Text('Criar conta')
              ),
            )
          ],
        ),
      ),
    );
  }
}