import 'dart:convert';

import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final _formCadastroKey = GlobalKey<FormState>();
  final _formResetPasswordKey = GlobalKey<FormState>();

//Controlador do campo do formulário de troca de senha
  final TextEditingController _verifyEmailController = TextEditingController();

  //Controladores dos campos do formulário de login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Controladores dos campos do formulário de cadastro
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _lattesController = TextEditingController();

  bool _valida = false;
  bool _representative = true;
  bool isforgotPasswordScream = false;

  bool isLogin = true;
  String title;
  bool forgotPassword;
  String actionButton;
  String buttonText;
  String toggleButtonText;
  Widget formulario;

  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _lattesController.dispose();

    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title = isLogin ? 'Olá, bem-vindo!' : 'Crie uma conta';
    forgotPassword = isLogin ? true : false;
    actionButton = isLogin ? 'Entrar' : 'Cadastrar';
    buttonText = isLogin ? 'Ainda não tem conta?' : 'Já possui uma conta?';
    toggleButtonText = isLogin ? 'Cadastre-se agora!' : 'Entrar';
    formulario =
        isLogin ? formLogin(_formLoginKey) : formRegister(_formCadastroKey);

    return Scaffold(
        backgroundColor: AppTheme.colors.lightGrey, body: buildLayout());
  }

  Widget buildLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var size = MediaQuery.of(context).size;

        if (constraints.maxWidth < 900) {
          return SingleChildScrollView(
            child: Column(
              children: [
                logo(size.height / 5, size.width),
                Utils.addVerticalSpace(16),
                forms(size.width)
              ],
            ),
          );
        } else {
          return Row(
            children: [
              logo(size.height, constraints.maxWidth / 2),
              SingleChildScrollView(child: forms(constraints.maxWidth / 2))
            ],
          );
        }
      },
    );
  }

  Widget logo(height, width) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: AppTheme.colors.dark),
      child: SvgPicture.asset('lib/assets/svg/extensiona-logo-light.svg',
          width: 200),
    );
  }

  Widget forms(width) {
    if (isforgotPasswordScream) {
      return Container(
        width: width,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Form(
          key: _formResetPasswordKey,
          child: Column(
            children: [
              EditorAuth(
                  _verifyEmailController,
                  'Email',
                  'Informe seu email',
                  const Icon(Icons.mail_outline),
                  30,
                  false,
                  'Insira um e-mail válido',
                  false,
                  false,
                  true,
                  true),
              Utils.addVerticalSpace(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formResetPasswordKey.currentState.validate()) {
                      context
                          .read<UserDAO>()
                          .resetPassword(_verifyEmailController.text.trim());

                      //Limpa o campo
                      _verifyEmailController.text = '';
                    }
                  },
                  child: Text('Recuperar senha', style: AppTheme.typo.button),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(23),
                      primary: AppTheme.colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Utils.addVerticalSpace(20),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isforgotPasswordScream = false;
                    });
                  },
                  child: const Text('Voltar para o login'))
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: width,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: AppTheme.typo.homeText),
            Utils.addVerticalSpace(16),
            toggleButton(
                buttonText, toggleButtonText, () => setFormAction(!isLogin)),
            Utils.addVerticalSpace(30),
            formulario,
            if (forgotPassword)
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isforgotPasswordScream = !isforgotPasswordScream;
                    });
                  },
                  child: const Text('Esqueceu sua senha?'),
                ),
              ),
            Utils.addVerticalSpace(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isLogin) {
                    if (_formLoginKey.currentState.validate()) {
                      // debugPrint('login');
                      // Chama o método de login
                      context.read<UserDAO>().login(
                          _emailController.text, _passwordController.text);
                    }
                  } else {
                    if (_formCadastroKey.currentState.validate()) {
                      if (_confirmPassword.text ==
                          _registerPasswordController.text) {
                        debugPrint('cadastro');
                        // Chama o método de cadastro
                        context.read<UserDAO>().signup(
                            _registerEmailController.text,
                            _registerPasswordController.text,
                            _nameController.text,
                            _phoneController.text,
                            _myState,
                            _myCity);

                        //Usuário não solicitou ser representante
                        if (!_representative) return;

                        //Envia o email
                        // sendEmail(
                        //     name: _nameController.text,
                        //     subject:
                        //         'Solicitação para ser representante institucional no app Extensiona',
                        //     message:
                        //         'Link do currículo lattes do usuário ${_nameController.text}: ${_lattesController.text}',
                        //     email: 'joaopetuco.pf006@academico.ifsul.edu.br');

                        setState(() {
                          _valida = false;
                        });
                      } else {
                        setState(() {
                          _valida = true;
                        });
                      }
                    }
                  }
                },
                child: Text(actionButton, style: AppTheme.typo.button),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(23),
                    primary: AppTheme.colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget formLogin(GlobalKey _formKey) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EditorAuth(
              _emailController,
              'Email',
              'Informe seu email',
              const Icon(Icons.mail_outline),
              30,
              false,
              'Informe um e-mail válido',
              false,
              false,
              true,
              true),
          EditorAuth(
              _passwordController,
              'Senha',
              'Informe sua senha',
              const Icon(Ionicons.md_key),
              10,
              true,
              'Informe uma senha',
              false,
              false,
              true,
              false),
        ],
      ),
    );
  }

  Widget formRegister(GlobalKey _formKey) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // campo nome
          EditorAuth(
              _nameController,
              'Nome',
              'Informe o seu nome',
              const Icon(Icons.person_outline),
              20,
              false,
              'Informe um nome',
              false,
              false,
              true,
              false),

          // campo email
          EditorAuth(
              _registerEmailController,
              'Email',
              'Informe seu email',
              const Icon(Icons.mail_outlined),
              30,
              false,
              'Informe um e-mail válido',
              false,
              false,
              true,
              false),

          // campo telefone
          EditorAuth(
              _phoneController,
              'Telefone',
              'Informe o seu telefone',
              const Icon(Icons.phone_outlined),
              20,
              false,
              'Informe um telefone',
              false,
              true,
              true,
              false),

          // campo quero ser representante
          Row(
            children: [
              Checkbox(
                  value: _representative,
                  activeColor: AppTheme.colors.blue,
                  onChanged: (bool value) {
                    setState(() {
                      _representative = value;
                    });
                    debugPrint('deseja ser representante: ' +
                        _representative.toString());
                  }),
              Text('Deseja ser um representante de sua instituição?',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppTheme.colors.greyText))
            ],
          ),

          Utils.addVerticalSpace(20),

          // campo telefone
          EditorAuth(
              _lattesController,
              'Lattes',
              'Link do seu Currículo Lattes',
              const Icon(Icons.description_outlined),
              256,
              false,
              'Informe o link do seu currículo',
              false,
              false,
              _representative,
              false),

          Row(children: [
            // campo estado
            Expanded(child: buildDropdownState()),

            Utils.addHorizontalSpace(10),

            // campo cidade
            Expanded(child: buildDropdownCity()),
          ]),

          Utils.addVerticalSpace(20),

          Row(
            children: [
              // campo senha
              Expanded(
                child: EditorAuth(
                    _registerPasswordController,
                    'Senha',
                    'Informe sua senha',
                    const Icon(Ionicons.md_key),
                    10,
                    true,
                    'Informe uma senha',
                    false,
                    false,
                    true,
                    false),
              ),

              Utils.addHorizontalSpace(10),

              // campo confirmar senha
              Expanded(
                child: EditorAuth(
                    _confirmPassword,
                    'Confirmar senha',
                    'Insira novamente a sua senha',
                    const Icon(Ionicons.md_key),
                    10,
                    true,
                    'Informar a mesma senha!',
                    _valida,
                    false,
                    true,
                    false),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildDropdownState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: selectedDecoration('Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um estado';
                  }
                  return null;
                },
                dropdownColor: AppTheme.colors.grey,
                focusColor: AppTheme.colors.lightGrey,
                iconEnabledColor: AppTheme.colors.greyText,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: _myState,
                icon: const Icon(Icons.expand_more),
                style: AppTheme.typo.formText,
                onChanged: (String newValue) {
                  setState(() {
                    _myState = newValue;
                    _myCity = null;
                    // debugPrint('depois estado: ' + _myState);
                  });

                  _getCitiesList();
                  // debugPrint('Permitir seleção');
                },
                items: statesList?.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem(
                        child: Text(item['nome']),
                        value: item['sigla'].toString(),
                      );
                    })?.toList() ??
                    [],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownCity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: selectedDecoration('Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma cidade';
                  }
                  return null;
                },
                dropdownColor: AppTheme.colors.grey,
                focusColor: AppTheme.colors.lightGrey,
                iconEnabledColor: AppTheme.colors.greyText,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: _myCity,
                icon: const Icon(Icons.expand_more),
                style: AppTheme.typo.formText,
                onChanged: (String newValue) {
                  setState(() {
                    _myCity = newValue;
                    // debugPrint('depois cidade: ' + _myCity);
                  });
                },
                items: citiesList?.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['nome']),
                        value: item['nome'].toString(),
                      );
                    })?.toList() ??
                    [],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future sendEmail({
    String name,
    String email,
    String subject,
    String message,
  }) async {
    const serviceId = 'service_9pnqmiy';
    const templateId = 'template_ubwfpbr';
    const userId = 'v9WZ9oRAJH_iPE_1q';

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
            'user_subject': subject,
            'user_message': message
          }
        }));

    debugPrint(response.body);
  }
  /* Future<void> sendEmail() async {
    final url = Mailto(
      to: ['renanigordl04@gmail.com'],
      subject:
          'Solicitação para ser representante institucional no app Extensiona',
      body:
          'Link do currículo lattes do usuário solicitante: ${_lattesController.text}',
    ).toString();

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      debugPrint("Erro no envio do email: " + url);
    }
  } */
  // Future<void> sendEmail() async {
  //   //joaopetuco.pf006@academico.ifsul.edu.br
  //   final Email email = Email(
  //       body:
  //           'Link do currículo lattes do usuário solicitante: ${_lattesController.text}',
  //       subject:
  //           'Solicitação para ser representante institucional no app Extensiona',
  //       recipients: ['joaopetuco0512@gmail.com'],
  //       isHTML: false);

  //   String platformResponse;

  //   try {
  //     await FlutterEmailSender.send(email);
  //     platformResponse = 'success';
  //   } catch (error) {
  //     debugPrint(error);
  //     platformResponse = error.toString();
  //   }

  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(platformResponse),
  //     ),
  //   );
  // }

  /// API Estados e Cidades
  // Buscando estados
  List statesList;
  String _myState;

  final stateInfoUrl = Uri.parse(
      'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome');

  Future<dynamic> _getStateList() async {
    await http.get(stateInfoUrl).then((response) {
      var data = json.decode(response.body);

      setState(() {
        statesList = data;
      });
    });
  }

  // Buscando cidades
  List citiesList;
  String _myCity;

  Future<dynamic> _getCitiesList() async {
    String cityInfoUrl;
    cityInfoUrl =
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados/$_myState/municipios?orderBy=nome";

    await http.get(Uri.parse(cityInfoUrl)).then((response) {
      var data = json.decode(response.body);

      setState(() {
        citiesList = data;
      });

      // debugPrint(citiesList.toString());
    });
  }

  InputDecoration selectedDecoration(String label) {
    return InputDecoration(
      alignLabelWithHint: true,
      label: Text(label),
      labelStyle: AppTheme.typo.defaultBoldText,
      floatingLabelStyle:
          TextStyle(color: AppTheme.colors.dark, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.only(right: 10, top: 20, bottom: 20),
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      prefixStyle: TextStyle(color: AppTheme.colors.black),
      prefixIcon: label == 'Estado'
          ? const Icon(Icons.location_on_outlined)
          : const Icon(Icons.location_city_outlined),
      errorStyle: const TextStyle(
          fontSize: 13, letterSpacing: 0, fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.white, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }
}
