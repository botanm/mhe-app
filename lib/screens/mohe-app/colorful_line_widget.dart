import 'package:flutter/material.dart';

class ColorfulLine extends StatelessWidget {
  final double height;
  final double width;
  final List<Color> colors;

  const ColorfulLine({
    super.key,
    this.height = 4,
    this.width = double.infinity,
    this.colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
