import 'package:flutter/material.dart';

@immutable
class AppTypo {
  // Texto do Botão
  final button = const TextStyle(
      fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w500);

  // Texto para Títulos
  final title = const TextStyle(
      fontFamily: "Objectivity", fontSize: 18, fontWeight: FontWeight.w500);

  // Texto Padrão
  final defaultText = const TextStyle(
      fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w400);

  const AppTypo();
}
