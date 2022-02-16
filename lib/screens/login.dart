import 'package:extensiona_if/data/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/screens/tela_admin.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:extensiona_if/data/user_dao.dart';


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _valida = false;

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  final styleTextTitle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  bool isLogin = true;

  String title;
  String textActionButton;
  String firstTextNavigation;
  String secondTextNavigation;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao){
    setState(() {
      isLogin = acao;

      if(isLogin) {
        title = 'LOGIN';
        textActionButton = 'FAZER LOGIN';
        firstTextNavigation = 'Não possui uma conta?';
        secondTextNavigation = 'Cadastre-se';
      } else {
        title = 'CADASTRO';
        textActionButton = 'CADASTRAR';
        firstTextNavigation = 'Já possui uma conta?';
        secondTextNavigation = 'Conecte-se';
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
          title: AppBarLogo(styleTextTitle),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(45),
                child: Text(
                title,
                style: GoogleFonts.cabin(textStyle: styleTextTitle),
                ),
              ),

              //We are calling the EditorLogin to give our password and email
              EditorLogin(_emailController, 'Email', 'Email', const Icon(Icons.email_outlined), _valida, 25, false),

              const SizedBox(height: 10),

              EditorLogin(_passwordController, 'Senha','Senha', const Icon(Icons.lock_outline), _valida, 10, true),

              const SizedBox(height: 10),

              
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _emailController.text.isEmpty ? _valida = true : _valida = false;
                    _passwordController.text.isEmpty ? _valida = true : _valida = false;
                  });

                  if(!_valida){
                    if(isLogin){
                      userDao.login(_emailController.text, _passwordController.text);

                    } else {
                      userDao.signup(_emailController.text, _passwordController.text);
                    }

                  }
                },
                  child: Text(textActionButton, style: GoogleFonts.roboto(textStyle: styleText)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    )
                  ),
              ),
              ),

              CadastrarConta(styleText, firstTextNavigation, secondTextNavigation, () => setFormAction(!isLogin)),

              ContaAdministrador(styleText),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                  child: Divisor()
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconesMedia(
                        'lib/assets/img/logo_google.png',
                            () {
                          debugPrint('Você logou com o google');

                          userDao.signInWithGoogle();
                        },
                        'Cadastre-se com o Google',
                      18,
                      5
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconesMedia(
                          'lib/assets/img/logo_facebook.png',
                              () {
                            debugPrint('Você logou com o facebook');

                            userDao.signInWithFacebook();
                          },
                          'Cadastre-se com o Facebook',
                        0,
                        5
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      );
  }



}

class CadastrarConta extends StatelessWidget{

  final TextStyle styleText;
  final String firstTextNavigation;
  final String secondTextNavigation;
  final Function setFormAction;

  const CadastrarConta(this.styleText, this.firstTextNavigation, this.secondTextNavigation, this.setFormAction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                firstTextNavigation,
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

            GestureDetector(
              onTap: setFormAction,
              child: Text(
                  secondTextNavigation,
                  style: GoogleFonts.cabin(textStyle: styleText, color: Colors.black)),
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              'Entrar como',
              style: GoogleFonts.cabin(textStyle: styleText, color: Colors.grey[700])),

          GestureDetector(
            onTap: () {
              debugPrint('Página de login do administrador');
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdmApp(),
              ));
            },

            child: Text(
                ' administrador',
                style: GoogleFonts.cabin(textStyle: styleText, color: Colors.black)),
          )

        ]);
  }

}
