import '../../../../../utils/utils.dart';
import '/screens/core/auth/register/components/social_icon.dart';
import 'package:flutter/material.dart';

import 'social_divider.dart';

class SocialRegister extends StatelessWidget {
  const SocialRegister({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SocialDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocialIcon(
              iconSrc: "assets/icons/facebook.svg",
              press: () {
                Utils.openBrowserUrl(
                    url: "https://www.facebook.com/KRG.MOHE.Official",
                    inApp: true);
              },
            ),
            SocialIcon(
              iconSrc: "assets/icons/twitter.svg",
              press: () {
                Utils.openBrowserUrl(
                    url: "https://www.facebook.com/KRG.MOHE.Official",
                    inApp: true);
              },
            ),
            SocialIcon(
              iconSrc: "assets/icons/google-plus.svg",
              press: () {
                Utils.openBrowserUrl(
                    url: "https://www.facebook.com/KRG.MOHE.Official",
                    inApp: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
