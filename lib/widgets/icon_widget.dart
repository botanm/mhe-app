import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? size;
  const IconWidget(
      {super.key, required this.icon, required this.color, this.size});

  @override
  Widget build(BuildContext context) {
    // print('*************** icon_widget build ***************');
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: KScaffoldBackgroundColor,
        size: size,
      ),
    );
  }
}
