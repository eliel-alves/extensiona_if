import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/register.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AuthenticationPages extends StatefulWidget {
  const AuthenticationPages({Key key}) : super(key: key);

  @override
  State<AuthenticationPages> createState() => _AuthenticationPagesState();
}

class _AuthenticationPagesState extends State<AuthenticationPages> {

  int initialPage = 0;
  PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: initialPage);
  }

  setInitialPage(page) {
    setState(() {
      initialPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        pageSnapping: false,
        controller: pc,
        children: [
          LoginPage(pageController: pc),
          RegisterUser(pageController: pc)
        ],
        onPageChanged: setInitialPage,
      ),
    );
  }
}


class LoginPage extends StatefulWidget {

  final PageController pageController;

  const LoginPage({Key key, this.pageController}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String validaMassage = 'Campo Obrigatório!';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserDAO>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const AppBarLogo("Escola de Extensão do IFSul"),
        centerTitle: true,
        backgroundColor: AppTheme.colors.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 10),
                child: Text('LOGIN', style: AppTheme.typo.title),
              ),

              registerOrLogin(
                  'Não possui uma conta?',
                  'Cadastre-se',
                      () {
                    widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                  },
                  context),

              EditorAuth(_emailController, 'Email', 'Informe seu email', const Icon(Ionicons.md_mail), 30, false, validaMassage, false),

              EditorAuth(_passwordController, 'Senha', 'Informe sua senha', const Icon(Ionicons.md_key), 10, true, validaMassage, false),

              trocarSenha(),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        authService.login(_emailController.text, _passwordController.text, context);
                      }
                      /*setState(() {
                        _emailController.text.isEmpty ? _valida = true : _valida = false;
                        _passwordController.text.isEmpty ? _valida = true : _valida = false;
                      });

                      if(!_valida) {
                        authService.login(_emailController.text, _passwordController.text, context);
                      }*/
                    },
                    child: Text('Entrar', style: AppTheme.typo.button),
                  style: ElevatedButton.styleFrom(
                      primary: AppTheme.colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                ),
              ),


              Padding(
                  padding: const EdgeInsets.only(top: 15), child: Divisor()),

              const SizedBox(height: 10),

              socialButtons(
                  Colors.white,
                      () {
                    authService.signInWithGoogle();
                  },
                  "Cadastre-se com o Google",
                  FontAwesome.google
              ),

              const SizedBox(height: 20),

              socialButtons(
                  Colors.blue[600],
                      () {
                    authService.signInWithFacebook();
                  },
                  "Cadastre-se com o Facebook",
                  FontAwesome.facebook
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trocarSenha() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19, top: 13),
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () {
            debugPrint('O usuário trocou de senha');
          },
          child: Text('Esqueceu sua senha?', style: AppTheme.typo.defaultText),
        ),
      ),
    );
  }


  Widget socialButtons(Color backgroundColor, Function onTap, String title, IconData iconData) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),

            const SizedBox(width: 10),

            Text(title, style: AppTheme.typo.button)
          ],
        ),
      ),
    );
  }
}