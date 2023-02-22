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
      height: 1);

  // Texto do Botão
  final button = const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  // Texto para Títulos
  final title = const TextStyle(
      fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700);

  // Texto para Título na AppBar
  final appBar = const TextStyle(
      fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w500);

  // Texto Padrão
  final defaultText = const TextStyle(
      color: Colors.black87,
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0);

  // Texto para formulários
  final formText = const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0);

  // Texto Padrão Negrito
  final defaultBoldText = const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  // Texto preto
  TextStyle black(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto extra-negrito
  TextStyle extraBold(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto em negrito
  TextStyle bold(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto em semi-negrito
  TextStyle semiBold(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto intermediário
  TextStyle medium(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto normal
  TextStyle regular(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto claro
  TextStyle light(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto extra-claro
  TextStyle extraLight(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  // Texto fino
  TextStyle thin(
          double size, Color color, double height, double letterSpacing) =>
      TextStyle(
          color: color,
          fontFamily: "Inter",
          fontSize: size,
          fontWeight: FontWeight.w100,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          height: height);

  const AppTypo();
}
