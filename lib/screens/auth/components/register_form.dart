import 'dart:convert';

import 'package:extensiona_if/components/editor.dart';
import 'package:extensiona_if/responsive/responsive.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/validation/validation.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  //Controladores dos campos do formulário de cadastro
  final TextEditingController registerEmailController;
  final TextEditingController registerPasswordController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController confirmPassword;
  final TextEditingController lattesController;
  final GlobalKey<FormState> formKey;
  final Function(String) myState;
  final Function(String) myCity;
  final Function(bool) representative;

  const RegisterForm({
    Key key,
    this.registerEmailController,
    this.registerPasswordController,
    this.nameController,
    this.phoneController,
    this.confirmPassword,
    this.lattesController,
    this.formKey,
    this.myState,
    this.myCity,
    this.representative,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _representative = true;
  String passwordText = '';

  @override
  void initState() {
    _getStateList();
    //_registerInfo();
    super.initState();

    widget.registerPasswordController.addListener(() {
      setState(() {
        passwordText = widget.registerPasswordController.text;
      });
      debugPrint(passwordText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // campo nome
          EditorAuth(
            controlador: widget.nameController,
            rotulo: 'Nome',
            dica: 'Informe o seu nome',
            icon: const Icon(Icons.person_outline),
            qtdCaracteres: 30,
            verSenha: false,
            confirmPasswordField: false,
            maskField: false,
            validateField: true,
            validator: FormValidation.validateField(),
          ),

          // campo email
          EditorAuth(
            controlador: widget.registerEmailController,
            rotulo: 'Email',
            dica: 'Informe o seu email',
            icon: const Icon(Icons.mail_outlined),
            qtdCaracteres: 50,
            verSenha: false,
            confirmPasswordField: false,
            maskField: false,
            validateField: true,
            validator: FormValidation.validateEmail(),
          ),

          // campo telefone
          EditorAuth(
            controlador: widget.phoneController,
            rotulo: 'Telefone',
            dica: 'Informe o seu telefone',
            icon: const Icon(Icons.phone_outlined),
            qtdCaracteres: 20,
            verSenha: false,
            confirmPasswordField: false,
            maskField: true,
            validateField: true,
            validator: FormValidation.validateField(),
          ),

          // campo quero ser representante
          Row(
            children: [
              Checkbox(
                  value: _representative,
                  activeColor: AppTheme.colors.blue,
                  onChanged: (bool value) {
                    setState(() {
                      _representative = value;
                      widget.representative(value);
                    });
                    debugPrint('deseja ser representante: $_representative');
                  }),
              Expanded(
                child: Text('Deseja ser um representante de sua instituição?',
                    style: AppTheme.typo
                        .regular(16, AppTheme.colors.greyText, 1, 1)),
              ),
            ],
          ),

          Utils.addVerticalSpace(20),

          // campo currículo lattes
          EditorAuth(
            controlador: widget.lattesController,
            rotulo: 'Lattes',
            dica: 'Link do seu Currículo Lattes',
            icon: const Icon(Icons.description_outlined),
            qtdCaracteres: 256,
            verSenha: false,
            confirmPasswordField: false,
            maskField: false,
            validateField: _representative,
            validator: FormValidation.validateField(),
          ),

          Row(children: [
            // campo estado
            Expanded(child: buildDropdownState()),

            Utils.addHorizontalSpace(10),

            // campo cidade
            Expanded(child: buildDropdownCity()),
          ]),

          Utils.addVerticalSpace(20),

          Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? Row(
                  children: [
                    // campo senha
                    Expanded(
                      child: EditorAuth(
                        controlador: widget.registerPasswordController,
                        rotulo: 'Senha',
                        dica: 'Informe a sua senha',
                        icon: const Icon(Ionicons.md_key),
                        qtdCaracteres: 10,
                        verSenha: true,
                        confirmPasswordField: false,
                        maskField: false,
                        validateField: true,
                        validator: FormValidation.validateField(),
                      ),
                    ),

                    Utils.addHorizontalSpace(10),

                    // campo confirmar senha
                    Expanded(
                      child: EditorAuth(
                        controlador: widget.confirmPassword,
                        rotulo: 'Confirmar senha',
                        dica: 'Insira novamente a sua senha',
                        icon: const Icon(Ionicons.md_key),
                        qtdCaracteres: 10,
                        verSenha: true,
                        confirmPasswordField: false,
                        maskField: false,
                        validateField: true,
                        validator: FormValidation.validateConfirmPassword(
                            passwordText),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    // campo senha
                    EditorAuth(
                      controlador: widget.registerPasswordController,
                      rotulo: 'Senha',
                      dica: 'Informe a sua senha',
                      icon: const Icon(Ionicons.md_key),
                      qtdCaracteres: 10,
                      verSenha: true,
                      confirmPasswordField: false,
                      maskField: false,
                      validateField: true,
                      validator: FormValidation.validateField(),
                    ),

                    Utils.addHorizontalSpace(10),

                    // campo confirmar senha
                    EditorAuth(
                      controlador: widget.confirmPassword,
                      rotulo: 'Confirmar senha',
                      dica: 'Insira novamente a sua senha',
                      icon: const Icon(Ionicons.md_key),
                      qtdCaracteres: 10,
                      verSenha: true,
                      confirmPasswordField: false,
                      maskField: false,
                      validateField: true,
                      validator:
                          FormValidation.validateConfirmPassword(passwordText),
                    ),
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
                alignment: Alignment.center,
                dropdownColor: AppTheme.colors.grey,
                focusColor: AppTheme.colors.lightGrey,
                iconEnabledColor: AppTheme.colors.greyText,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: _myState,
                icon: const Icon(Icons.expand_more),
                style: AppTheme.typo.bold(16, AppTheme.colors.dark, 1, 0),
                onChanged: (String newValue) {
                  setState(() {
                    _myState = newValue;
                    widget.myState(newValue);
                    _myCity = null;
                    // debugPrint('depois estado: ' + _myState);
                  });

                  _getCitiesList();
                  // debugPrint('Permitir seleção');
                },
                items: statesList?.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem(
                        value: item['sigla'].toString(),
                        child: Text(
                          item['nome'],
                          style: AppTheme.typo
                              .bold(16, AppTheme.colors.dark, 1, 0),
                        ),
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
                alignment: Alignment.center,
                dropdownColor: AppTheme.colors.grey,
                focusColor: AppTheme.colors.lightGrey,
                iconEnabledColor: AppTheme.colors.greyText,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: _myCity,
                icon: const Icon(Icons.expand_more),
                style: AppTheme.typo.semiBold(16, AppTheme.colors.dark, 1, 0),
                onChanged: (String newValue) {
                  setState(() {
                    _myCity = newValue;
                    widget.myCity(newValue);
                    // debugPrint('depois cidade: ' + _myCity);
                  });
                },
                items: citiesList?.map((item) {
                      return DropdownMenuItem(
                        value: item['nome'].toString(),
                        child: Text(
                          item['nome'],
                          style: AppTheme.typo
                              .bold(16, AppTheme.colors.dark, 1, 0),
                        ),
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
      labelStyle: AppTheme.typo.bold(16, AppTheme.colors.dark, 1, 0),
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
