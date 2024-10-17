import 'package:flutter/material.dart';
import 'package:mohe_app_1_x_x/constants/app_constants.dart';

class TextFormFieldLikeWidget extends StatelessWidget {
  const TextFormFieldLikeWidget({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.suffixIcon,
    this.isTextRtl = false,
    this.maxLines = 1,
  });

  final String label;
  final String value;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isTextRtl;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 17.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: kPrimaryColor, fontSize: 12),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    textAlign: isTextRtl ? TextAlign.end : TextAlign.start,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 6.0),
                  // Divider Line
                  const Divider(
                    color: Color(0xFFC0C0C0),
                    thickness: 0.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
