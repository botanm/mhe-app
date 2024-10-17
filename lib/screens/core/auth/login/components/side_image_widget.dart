import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants/app_constants.dart';

class SideImageWidget extends StatelessWidget {
  const SideImageWidget({
    this.title,
    required this.svgUrl,
    super.key,
  });
  final String svgUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(svgUrl),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
