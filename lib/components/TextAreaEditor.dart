import 'package:flutter/material.dart';

class TextAreaEditor extends StatelessWidget {
  final TextEditingController controlador;
  final String label;
  final String hint;
  final IconData icon;

  TextAreaEditor(this.controlador, this.label, this.hint, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        maxLines: 5,
        style: const TextStyle(
            fontSize: 18.0
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}