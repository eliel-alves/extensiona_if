import 'dart:convert';

import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/data/user_dao.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:extensiona_if/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  String confirmPasswordMessage = 'Campo Obrigatório!';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getStateList();
    super.initState();
  }

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
                padding: const EdgeInsets.only(
                    top: 50, bottom: 0, right: 40, left: 40),
                child: Text('Cadastre-se', style: AppTheme.typo.homeText),
              ),

              registerOrLogin('Já possui uma conta?', 'Entrar', () {
                widget.pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease);
              }, context),

              addVerticalSpace(30),

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
                  false),

              // campo email
              EditorAuth(
                  _emailController,
                  'Email',
                  'Informe seu email',
                  const Icon(Icons.mail_outlined),
                  30,
                  false,
                  'Informe um e-mail',
                  false,
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
                  true),

              // campo estado
              buildDropdownState(),

              addVerticalSpace(20),

              buildDropdownCity(),

              addVerticalSpace(20),

              // campo senha
              EditorAuth(
                  _passwordController,
                  'Senha',
                  'Informe sua senha',
                  const Icon(Ionicons.md_key),
                  10,
                  true,
                  'Informe uma senha',
                  false,
                  false),

              // campo confirmar senha
              EditorAuth(
                  _confirmPassword,
                  'Confirmar senha',
                  'Insira novamente a sua senha',
                  const Icon(Ionicons.md_key),
                  10,
                  true,
                  'Informa a mesma senha',
                  _valida,
                  false),

              addVerticalSpace(12),

              // botão registrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (_confirmPassword.text == _passwordController.text) {
                        authService.signup(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                            _phoneController.text,
                            _myState, _myCity,
                            context);
                      } else {
                        setState(() {
                          _valida = true;
                          confirmPasswordMessage =
                              'Senha Incorreta! Verifique novamente a sua senha';
                        });
                      }
                    }
                  },
                  child: Text(
                    'Cadastrar Nova Conta',
                    style: AppTheme.typo.button,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(23),
                      backgroundColor: AppTheme.colors.blue,
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

  Widget buildDropdownState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
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
                    debugPrint('depois estado: ' + _myState);
                  });

                  _getCitiesList();
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
                    debugPrint('depois cidade: ' + _myCity);
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
      prefixIcon: label == 'Estado' ? const Icon(Icons.location_on_outlined) : const Icon(Icons.location_city_outlined),
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
