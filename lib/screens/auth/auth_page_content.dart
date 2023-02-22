import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/responsive/responsive.dart';
import 'package:extensiona_if/screens/auth/components/reset_password_form.dart';
import 'package:extensiona_if/screens/auth/widget/button.dart';
import 'package:extensiona_if/screens/auth/widget/logo.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPageContent extends StatefulWidget {
  final String title;
  final String actionButton;
  final String buttonText;
  final String toggleButtonText;
  final bool forgotPassword;
  final Widget formulario;
  final Function() setFormAction;
  final Function() authAction;

  const AuthPageContent(
      {Key key,
      this.title,
      this.actionButton,
      this.buttonText,
      this.toggleButtonText,
      this.formulario,
      this.forgotPassword,
      this.setFormAction,
      this.authAction})
      : super(key: key);

  @override
  State<AuthPageContent> createState() => _AuthPageContentState();
}

class _AuthPageContentState extends State<AuthPageContent> {
  final _formResetPasswordKey = GlobalKey<FormState>();

  //Controlador do campo do formulário de troca de senha
  final TextEditingController _verifyEmailController = TextEditingController();

  bool isforgotPasswordScream = false;

  @override
  void initState() {
    super.initState();
    forgotPasswordForm(false);
  }

  void forgotPasswordForm(bool acao) {
    setState(() {
      isforgotPasswordScream = acao;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.colors.lightGrey,
      body: Responsive(
        mobile: authPageMobile(size),
        desktop: authPageDesktop(size),
      ),
    );
  }

  Widget authPageDesktop(Size size) {
    return Row(
      children: [
        logoContainer(
            size.width / 2,
            size.height,
            (size.width > 900 && size.width <= 1200)
                ? const EdgeInsets.only(right: 50, left: 50)
                : const EdgeInsets.only(right: 110, left: 110)),
        isforgotPasswordScream
            ? SizedBox(
                height: size.height,
                width: size.width / 2,
                child: ResetPasswordForm(
                  formKey: _formResetPasswordKey,
                  controller: _verifyEmailController,
                  goBack: () => setState(() {
                    isforgotPasswordScream = false;
                  }),
                  sendLink: () {
                    if (_formResetPasswordKey.currentState.validate()) {
                      context
                          .read<UserDAO>()
                          .resetPassword(_verifyEmailController.text.trim());
                      _verifyEmailController.clear();
                    }
                  },
                ),
              )
            : SingleChildScrollView(child: formContainer(size.width / 2, 0)),
      ],
    );
  }

  Widget authPageMobile(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logoContainer(size.width, 150, const EdgeInsets.all(50)),
          isforgotPasswordScream
              ? ResetPasswordForm(
                  formKey: _formResetPasswordKey,
                  controller: _verifyEmailController,
                  goBack: () => setState(() {
                    isforgotPasswordScream = false;
                  }),
                  sendLink: () {
                    if (_formResetPasswordKey.currentState.validate()) {
                      _verifyEmailController.clear();
                    }
                  },
                )
              : formContainer(size.width, 0)
        ],
      ),
    );
  }

  Widget formContainer(double width, double height) {
    return Container(
      width: width,
      height: (height == 0) ? null : height,
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.title,
              style:
                  AppTheme.typo.extraBold(38, AppTheme.colors.dark, 1, -1.5)),
          Utils.addVerticalSpace(20),
          toggleButton(
              widget.buttonText, widget.toggleButtonText, widget.setFormAction),
          Utils.addVerticalSpace(20),
          widget.formulario,
          if (widget.forgotPassword) ...[
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => forgotPasswordForm(!isforgotPasswordScream),
                child: Text(
                  'Esqueceu sua senha?',
                  style: AppTheme.typo.medium(14, AppTheme.colors.blue, 1, 0),
                ),
              ),
            ),
          ],
          Utils.addVerticalSpace(20),
          AuthButton(
            title: widget.actionButton,
            onPressed: widget.authAction,
          )
        ],
      ),
    );
  }
}
