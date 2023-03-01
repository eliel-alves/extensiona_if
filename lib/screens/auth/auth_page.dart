import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:extensiona_if/data/user_dao.dart';

import 'package:extensiona_if/screens/auth/auth_page_content.dart';
import 'package:extensiona_if/screens/auth/components/login_form.dart';
import 'package:extensiona_if/screens/auth/components/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //Controladores dos campos do formulário de login
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Controladores dos campos do formulário de cadastro
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _lattesController = TextEditingController();

  final _formLoginKey = GlobalKey<FormState>();
  final _formRegisterKey = GlobalKey<FormState>();

  String myState = '';
  String myCity = '';
  bool _representative = true;

  bool isLogin = true;
  late String title;
  late bool forgotPassword;
  late String actionButton;
  late String buttonText;
  late String toggleButtonText;
  late Widget formulario;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
    });

    if (isLogin) {
      title = 'Olá, bem-vindo!';
      actionButton = 'Entrar';
      buttonText = 'Ainda não tem conta?';
      toggleButtonText = 'Cadastre-se agora!';
      forgotPassword = true;
      formulario = LoginForm(
        formKey: _formLoginKey,
        emailController: _emailController,
        passwordController: _passwordController,
      );
    } else {
      title = 'Crie uma conta';
      actionButton = 'Cadastrar';
      buttonText = 'Já possui uma conta?';
      toggleButtonText = 'Entrar';
      forgotPassword = false;
      formulario = RegisterForm(
          formKey: _formRegisterKey,
          registerEmailController: _registerEmailController,
          registerPasswordController: _registerPasswordController,
          nameController: _nameController,
          phoneController: _phoneController,
          confirmPassword: _confirmPassword,
          lattesController: _lattesController,
          representative: (representative) => setState(() {
                _representative = representative;
              }),
          myState: (state) => setState(() {
                myState = state;
              }),
          myCity: (city) => setState(() {
                myCity = city;
              }));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _confirmPassword.dispose();
    _phoneController.dispose();
    _lattesController.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageContent(
      title: title,
      actionButton: actionButton,
      buttonText: buttonText,
      toggleButtonText: toggleButtonText,
      formulario: formulario,
      forgotPassword: forgotPassword,
      setFormAction: () => setFormAction(!isLogin),
      authAction: () => authAction(),
    );
  }

  void authAction() {
    if (isLogin) {
      if (_formLoginKey.currentState!.validate()) {
        context
            .read<UserDAO>()
            .login(_emailController.text, _passwordController.text);
      }
    } else {
      if (_formRegisterKey.currentState!.validate()) {
        debugPrint('cadastro');
        // Chama o método de cadastro
        context.read<UserDAO>().signup(
            _registerEmailController.text,
            _registerPasswordController.text,
            _nameController.text,
            _phoneController.text,
            myState,
            myCity);

        //Usuário não solicitou ser representante
        if (!_representative) return;
        debugPrint('enviou email');
        sendEmail(
            name: _nameController.text,
            email: _registerEmailController.text,
            message:
                'Link do currículo lattes do usuário ${_nameController.text}: ${_lattesController.text}');
      }
    }
  }

  Future sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    const serviceId = 'service_1j5vjqk';
    const templateId = 'template_n9b4nva';
    const userId = 'iEnkRYVbn840jPKTh';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'origin': '*', 'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_message': message
          }
        }));

    debugPrint(response.body);
  }
}
