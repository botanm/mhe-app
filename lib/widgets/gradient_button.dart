import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GradientButton(
      {required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = kPrimaryColor;
    const secondaryColor = Colors.blue;
    const thirdColor = Color.fromARGB(255, 237, 140, 172);
    const accentColor = Color(0xffffffff);

    const double borderRadius = 15;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(
                colors: [primaryColor, secondaryColor, thirdColor])),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 75),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
          onPressed: onPressed,
          child: Text(text,
              style: const TextStyle(color: accentColor, fontSize: 16)),
        ),
      ),
    );
  }
}
