import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const RoundButton({super.key, required this.title, required this.onPressed}); // Fixed constructor syntax

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Tcolor.primary,
      height: 50,
      minWidth: double.maxFinite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child:  Text(
        title,  // Fixed title parameter  
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}
