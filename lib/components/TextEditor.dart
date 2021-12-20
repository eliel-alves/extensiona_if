import 'package:flutter/material.dart';

class TextEditor extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int lines;
  final bool valid;
  final int length;

  TextEditor(this.controller, this.label, this.hint, this.icon, this.lines, this.length, this.valid);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(
            fontSize: 18.0
        ),
        maxLines: lines,
        maxLength: length,
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
          helperText: hint,
          errorText: valid ? 'Campo obrigatório' : null
        ),
      ),
    );
  }
}