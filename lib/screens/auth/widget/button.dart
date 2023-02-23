import 'package:extensiona_if/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const AuthButton({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: AppTheme.colors.blue,
            backgroundColor: AppTheme.colors.blue,
            padding: const EdgeInsets.all(23),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(title,
            style: AppTheme.typo.bold(16, AppTheme.colors.light, 1, 0)),
      ),
    );
  }
}
