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

  static String validaMassage = 'Campo Obrigatório!';
  bool _valida = false;

  String confirmPasswordMessage = 'Campo Obrigatório!';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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

              EditorAuth(_nameController, 'Nome', 'Informe o seu nome', const Icon(Ionicons.md_person), 20, false, validaMassage, false),

              EditorAuth(_phoneController, 'Telefone', 'Informe o seu telefone', const Icon(Icons.phone), 20, false, validaMassage, false),

              EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Ionicons.md_mail), 30, false, validaMassage, false),

              EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Ionicons.md_key), 10, true, validaMassage, false),

              EditorAuth(_confirmPassword, 'Confirmar senha', 'Insira novamente a sua senha', const Icon(Ionicons.md_key), 10, true, confirmPasswordMessage, _valida),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if(_confirmPassword.text == _passwordController.text) {
                          authService.signup(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _phoneController.text,
                              context);
                        } else {
                          setState(() {
                            _valida = true;
                            confirmPasswordMessage = 'Senha Incorreta! Verifique novamente a sua senha';
                          });
                        }
                      }
                      /*setState(() {
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
                      }*/
                    },
                    child: const Text('Criar conta')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}