import 'package:extensiona_if/theme/colors.dart';
import 'package:extensiona_if/theme/typo.dart';
import 'package:flutter/material.dart';

@immutable
class AppTheme {
  static const colors = AppColors();
  static const typo = AppTypo();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: "Inter",
      colorScheme: ThemeData().colorScheme.copyWith(
        primary: colors.blue,
        error: colors.red
      ),
      errorColor: colors.red,
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: colors.greyText,
      ),
    );
  }
}