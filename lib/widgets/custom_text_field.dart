import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key, this.hintText, this.onChanged, this.obscureText = false});
  final String? hintText;
  final Function(String)? onChanged;
  bool? obscureText = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (data == null || data.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }
}
