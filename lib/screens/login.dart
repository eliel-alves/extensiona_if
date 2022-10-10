import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/screens/register.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
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
        automaticallyImplyLeading: false
      ),
      backgroundColor: AppTheme.colors.lightGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 40, left: 40),
                child: Text('Olá, bem-vindo!',
                    style: AppTheme.typo.homeText),
              ),

              registerOrLogin(
                'Não possui uma conta?',
                'Cadastre-se agora!',
                () {
                  widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                },
                context
              ),

              addVerticalSpace(30),

              EditorAuth(
                  _emailController,
                  'Email',
                  'Informe seu email',
                  const Icon(Icons.mail_outline),
                  30,
                  false,
                  'Insira um e-mail válido',
                  false, false),

              EditorAuth(
                  _passwordController,
                  'Senha',
                  'Informe sua senha',
                  const Icon(Ionicons.md_key),
                  10,
                  true,
                  'Insira uma senha',
                  false, false),

              trocarSenha(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      authService.login(_emailController.text,
                        _passwordController.text, context);
                    }
                  },
                  child: Text('Entrar', style: AppTheme.typo.button),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(23),
                    primary: AppTheme.colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                ),
              ),
              // addVerticalSpace(30),
              // Divisor(),
              // addVerticalSpace(30),
              // socialButtons(Colors.white, () {
              //   authService.signInWithGoogle();
              // }, "Cadastre-se com o Google", FontAwesome.google),
              // const SizedBox(height: 20),
              // socialButtons(Colors.blue[600], () {
              //   authService.signInWithFacebook();
              // }, "Cadastre-se com o Facebook", FontAwesome.facebook),
            ],
          ),
        ),
      ),)
    );
  }

  Widget trocarSenha() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 5),
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

  Widget socialButtons(
      Color backgroundColor, Function onTap, String title, IconData iconData) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
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
