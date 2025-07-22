import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class RoundTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keybordType;
  final bool obscureText;
  const RoundTextfield({super.key, required this.controller, required this.hintText, this.obscureText = false, this.keybordType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tcolor.textBox,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keybordType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
