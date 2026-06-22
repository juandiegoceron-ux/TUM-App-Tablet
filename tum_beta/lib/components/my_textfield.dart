import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? style;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.hintStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: style ?? const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enabledBorderColor ?? Colors.white),
            borderRadius: BorderRadius.circular(30), // Rounded corners like Figma
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor ?? Colors.grey.shade400),
            borderRadius: BorderRadius.circular(30),
          ),
          fillColor: fillColor ?? Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}