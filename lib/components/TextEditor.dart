import 'package:flutter/material.dart';

class TextEditor extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool valid;
  final int length;

  TextEditor(this.controller, this.label, this.hint, this.icon, this.length, this.valid);

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 175
      ),
      child: Padding (
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          onChanged: (text){
            print(text);
          },
          maxLines: null,
          maxLength: length,
          controller: controller,
          style: const TextStyle(
              fontSize: 18.0
          ),
          decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon) : null,
              labelText: label,
              helperText: hint,
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
              )
          ),
        ),
      ),
    );

  }
}