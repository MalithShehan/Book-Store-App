import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({super.key}); // Fixed constructor syntax

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      textColor: Colors.white,
      color: Tcolor.primary,
      height: 50,
      minWidth: double.maxFinite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: const Text(
        "Sign Up", // <-- added comma here
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}
