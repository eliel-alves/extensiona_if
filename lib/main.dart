import 'package:flutter/material.dart';
import 'package:extensiona_if/screens/lista.dart';

void main() {
  runApp(ExtensionaIFApp());
}

class ExtensionaIFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ExtensionaIF',
        theme: ThemeData(fontFamily: 'Inter'),
        home: ListaDemanda()
    );
  }

}