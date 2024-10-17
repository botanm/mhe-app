import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../screens/core/auth/register/components/social_register.dart';
import '../utils/utils.dart';
import 'responsive.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSmallSizeScreen = Responsive.w(context) < 400;
    bool isDesktop = Responsive.isDesktop(context);
    bool isLargeDesktop = Responsive.isLargeDesktop(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [kPrimaryLightColor, KScaffoldBackgroundColor])),
        child: Column(
          children: [
            if (isSmallSizeScreen) buildLogo(),
            if (isSmallSizeScreen) const SizedBox(width: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isSmallSizeScreen) buildLogo(),
                if (!isSmallSizeScreen)
                  const SizedBox(width: defaultPadding * 4),
                _appInfo(),
                if (isDesktop || isLargeDesktop)
                  const Expanded(child: SocialRegister()),
              ],
            ),
            if (!isDesktop && !isLargeDesktop) const SocialRegister(),
          ],
        ),
      ),
    );
  }

  Column _appInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        newMethod(Icons.email_outlined, "info.research@mhe-krg.org"),
        // newMethod(Icons.phone, "0964-750-4567890"),
        newMethod(Icons.map_outlined, "Erbil, Iraq"),
        newMethod(Icons.copyright_outlined,
            "${DateTime.now().year} MOHE. All rights reserved."),
      ],
    );
  }

  InkWell buildLogo() {
    return InkWell(
      splashColor: kPrimaryColor,
      highlightColor: kPrimaryLightColor,
      onTap: () {
        Utils.openBrowserUrl(
            url: "https://gov.krd/mohe/activities/", inApp: true);
      },
      child: Row(
        children: [
          const Text(
            'from',
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: 'Itim',
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 1, bottom: 1, right: 4, left: 4),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: const Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'OHE',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget newMethod(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: defaultPadding / 2),
          Text(
            text,
            style: const TextStyle(fontFamily: 'Itim'),
          ),
        ],
      ),
    );
  }
}
