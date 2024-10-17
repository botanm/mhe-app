import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../widgets/responsive.dart';

class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n i = Provider.of<i18n>(context, listen: false);
    double h = Responsive.h(context);
    double w = Responsive.w(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: h * 0.02),
      width: w * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              i.tr("m95"),
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}
