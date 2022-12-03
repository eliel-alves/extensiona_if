import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeStateCity extends StatefulWidget {
  final String selectedState;
  final String selectedCity;
  final String docId;

  const ChangeStateCity(
      {Key key, this.selectedCity, this.selectedState, this.docId})
      : super(key: key);

  @override
  State<ChangeStateCity> createState() => _ChangeStateCityState();
}

class _ChangeStateCityState extends State<ChangeStateCity> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _myState = widget.selectedState;
    _myCity = widget.selectedCity;
    _getStateList();
    _getCitiesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estado e Cidade', style: AppTheme.typo.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildDropdownState(),
                Utils.addVerticalSpace(20),
                buildDropdownCity(),
                Utils.addVerticalSpace(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    Utils.addHorizontalSpace(10),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (_myCity == null) {}

                            final doc = await FirebaseFirestore.instance
                                .collection('USUARIOS')
                                .doc(widget.docId)
                                .get();

                            doc.reference.update(
                                {'estado': _myState, 'cidade': _myCity});

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Salvar'))
                  ],
                )
              ],
            ),
          )),
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
