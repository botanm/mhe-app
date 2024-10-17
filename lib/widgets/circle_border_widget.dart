import 'package:flutter/material.dart';

class CircleBorderWidget extends StatelessWidget {
  const CircleBorderWidget(
      {super.key,
      this.strokeWidth = 1.0,
      this.gap = 2.0,
      this.gapColor = Colors.white,
      this.borderColor = Colors.teal,
      required this.child});
  final double strokeWidth;
  final double gap;
  final Color gapColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // print('*************** circle_border_widget build ***************');
    return Container(
      padding: EdgeInsets.all(gap),
      decoration: BoxDecoration(
        color: gapColor,
        shape: BoxShape.circle,
        border: Border.all(width: strokeWidth, color: borderColor),
      ),
      child: child,
    );
  }
}
