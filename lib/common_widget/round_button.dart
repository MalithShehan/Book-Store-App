import 'package:flutter/material.dart';
import 'package:flutter_app/common/color.extention.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
  }); // Fixed constructor syntax

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Tcolor.primary,
      height: 50,
      minWidth: double.maxFinite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Text(
        title, // Fixed title parameter
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class RoundLineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const RoundLineButton({
    super.key,
    required this.title,
    required this.onPressed,
  }); // Fixed constructor syntax

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: getColor(Colors.white, Tcolor.primary),
        foregroundColor: getColor(Tcolor.primary, Colors.white),
        shadowColor: WidgetStateProperty.resolveWith(
          (states) => Tcolor.primartLight,
        ),
        minimumSize: WidgetStateProperty.resolveWith(
          (states) => const Size(double.maxFinite, 50),
        ),
        shape: WidgetStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 1,
              color: states.contains(WidgetState.pressed)
                  ? Tcolor.primary
                  : Colors.transparent,
            ),
          ),
        ),
      ),
      child: Text(
        title, // Fixed title parameter
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    return WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.pressed) ? colorPressed : color,
    );
  }
}
