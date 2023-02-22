import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget logoContainer(double width, double height, EdgeInsets padding) {
  return Container(
    height: height,
    width: width,
    padding: padding,
    decoration: BoxDecoration(color: AppTheme.colors.dark),
    child: SvgPicture.asset(
      'lib/assets/svg/extensiona-logo-light.svg',
    ),
  );
}
