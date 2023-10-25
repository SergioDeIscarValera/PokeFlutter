import 'package:flutter/material.dart';

class TextFieldModern extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hint;
  final Icon? icon;
  final bool obscureText;

  const TextFieldModern({
    super.key,
    required this.controller,
    required this.validator,
    this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            label: Text(label ?? ""),
            prefixIcon: icon,
            hintText: hint),
        obscureText: obscureText,
      ),
    );
  }
}
