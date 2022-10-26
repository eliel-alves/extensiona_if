import 'package:flutter/material.dart';

Widget addVerticalSpace(double value) {
  return SizedBox(
    height: value,
  );
}

Widget addHorizontalSpace(double value) {
  return SizedBox(
    width: value,
  );
}

Widget addSpace() {
  return const Spacer();
}

String toCapitalization(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}