import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
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
    UserDAO authService = Provider.of<UserDAO>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const AppBarLogo("Escola de Extensão do IFSul"),
        centerTitle: true,
        backgroundColor: AppTheme.colors.dark,
      ),
      backgroundColor: AppTheme.colors.lightGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 0, right: 40, left: 40),
                child: Text('Cadastre-se',
                    style: AppTheme.typo.homeText),
              ),

              registerOrLogin(
                'Já possui uma conta?',
                'Entrar',
                () {
                  widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                },
                context
              ),
                  
              addVerticalSpace(30),

              EditorAuth(_nameController, 'Nome', 'Informe o seu nome', const Icon(Icons.person_outline), 20, false, validaMassage, false),

              EditorAuth(_phoneController, 'Telefone', 'Informe o seu telefone', const Icon(Icons.phone_outlined), 20, false, validaMassage, false),

              EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Icons.mail_outlined), 30, false, validaMassage, false),

              EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Ionicons.md_key), 10, true, validaMassage, false),

              EditorAuth(_confirmPassword, 'Confirmar senha', 'Insira novamente a sua senha', const Icon(Ionicons.md_key), 10, true, confirmPasswordMessage, _valida),

              addVerticalSpace(12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if( _formKey.currentState.validate() ) {
                      if( _confirmPassword.text == _passwordController.text ) {
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
                  },
                  child: Text('Cadastrar Nova Conta', style: AppTheme.typo.button,),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(23),
                    primary: AppTheme.colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}