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
