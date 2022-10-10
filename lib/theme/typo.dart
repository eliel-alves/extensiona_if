import 'package:flutter/material.dart';

@immutable
class AppTypo {

  // Texto Home
  final homeText = const TextStyle(
    color: Colors.black87,
    fontFamily: "Inter",
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    height: 1
  );

  // Texto do Botão
  final button = const TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0);

  // Texto para Títulos
  final title = const TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700);

  // Texto para Título na AppBar
  final appBar = const TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w500);

  // Texto Padrão
  final defaultText = const TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0);

  // Texto para formulários
  final formText = const TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0);

  // Texto Padrão Negrito
  final defaultBoldText = const TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0);



  const AppTypo();
}
