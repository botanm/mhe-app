import 'package:flutter/material.dart';

import 'bullet_point.dart';

class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.title, required this.strings});
  final String title;
  final List<String> strings;

  @override
  Widget build(BuildContext context) {
    // print('*************** bullet_list build ***************');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: strings.map((t) => BulletPoint(text: t)).toList(),
          ),
        ),
      ],
    );
  }
}
