import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    // print('*************** bullet_point build ***************');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          String.fromCharCode(0x2022), // Text("\u2022 ") is a dot
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            // fontSize: ThemeSelector.selectBodyText(context).fontSize // Didn't work for me (copy past)
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        Flexible(
          child: Text(
            text,
            // style: ThemeSelector.selectBodyText(context),
          ),
        )
      ],
    );
  }
}
