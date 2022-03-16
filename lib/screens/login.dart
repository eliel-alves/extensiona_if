import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/screens/tela_admin.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _userPhoneController = TextEditingController();

  bool _valida = false;

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  final styleTextTitle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  bool isLogin = true;

  String title;
  String textActionButton;
  String firstTextNavigation;
  String secondTextNavigation;
  Widget camposCadastro;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;

      if (isLogin) {
        title = 'LOGIN';
        textActionButton = 'FAZER LOGIN';
        firstTextNavigation = 'Não possui uma conta?';
        secondTextNavigation = 'Cadastre-se';
        camposCadastro = const Text('');
      } else {
        title = 'CADASTRO';
        textActionButton = 'CADASTRAR';
        firstTextNavigation = 'Já possui uma conta?';
        secondTextNavigation = 'Conecte-se';
        camposCadastro = camposExtras(_nameController, _userPhoneController, _valida);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: const AppBarLogo("Escola de Extensão do IFSul"),
          centerTitle: true,
          backgroundColor: AppTheme.colors.dark,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 10),
                child: Text(
                  title,
                  style: AppTheme.typo.title,
                ),
              ),

              //We are calling the EditorLogin to give our password and email
              EditorAuth(_emailController, 'Email', 'Informe o seu e-mail',
                  const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorAuth(_passwordController, 'Senha', 'Informe a sua senha',
                  const Icon(Icons.lock_outline), _valida, 10, true),

              camposCadastro,

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(isLogin){
                        _emailController.text.isEmpty ? _valida = true : _valida = false;
                        _passwordController.text.isEmpty ? _valida = true : _valida = false;
                      } else {
                        _emailController.text.isEmpty ? _valida = true : _valida = false;
                        _passwordController.text.isEmpty ? _valida = true : _valida = false;
                        _nameController.text.isEmpty ? _valida = true : _valida = false;
                        _userPhoneController.text.isEmpty ? _valida = true : _valida = false;
                      }
                    });

                    // Valida os campos
                    if (!_valida) {
                      if (isLogin) {
                        userDao.login(_emailController.text, _passwordController.text);
                      } else {
                        userDao.signup(_emailController.text, _passwordController.text, _nameController.text, _userPhoneController.text);
                      }
                    }
                  },
                  child: Text(
                    textActionButton,
                    style: AppTheme.typo.button
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppTheme.colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                ),
              ),

              CadastrarConta(styleText, firstTextNavigation,
                  secondTextNavigation, () => setFormAction(!isLogin)),

              ContaAdministrador(styleText),

              Padding(
                  padding: const EdgeInsets.only(top: 15), child: Divisor()),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        Buttons.Google,
                        text: "Cadastre-se com o Google",
                        onPressed: () {
                          userDao.signInWithGoogle();
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        Buttons.FacebookNew,
                        text: "Cadastre-se com o Facebook",
                        onPressed: () {
                          userDao.signInWithFacebook();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

class CadastrarConta extends StatelessWidget {
  final TextStyle styleText;
  final String firstTextNavigation;
  final String secondTextNavigation;
  final Function setFormAction;

  const CadastrarConta(this.styleText, this.firstTextNavigation,
      this.secondTextNavigation, this.setFormAction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(firstTextNavigation,
            style: GoogleFonts.cabin(
                textStyle: styleText, color: Colors.grey[700])),
        GestureDetector(
          onTap: setFormAction,
          child: Text(secondTextNavigation,
              style:
                  GoogleFonts.cabin(textStyle: styleText, color: Colors.black)),
        )
      ]),
    );
  }
}

class ContaAdministrador extends StatelessWidget {
  final TextStyle styleText;

  const ContaAdministrador(this.styleText);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text('Entrar como',
          style:
              GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),
      GestureDetector(
        onTap: () {
          debugPrint('Página de login do administrador');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdmApp(),
              ));
        },
        child: Text(' administrador',
            style:
                GoogleFonts.cabin(textStyle: styleText, color: Colors.black)),
      )
    ]);
  }
}

Widget camposExtras(TextEditingController _nameController, TextEditingController _userPhoneController, bool _valida) {
  return Column(
    children: [
      const SizedBox(height: 10),

      EditorAuth(_nameController, 'Nome','Informe o seu nome completo', const Icon(Icons.lock_outline), _valida, 10, false),

      const SizedBox(height: 10),

      EditorAuth(_userPhoneController, 'Telefone','Informe um número de contato', const Icon(Icons.lock_outline), _valida, 10, false),
    ],
  );
}
