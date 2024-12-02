import 'package:flutter/material.dart';

import '../../../../constants/app_constants.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/responsive.dart';
import '../register/components/social_register.dart';
import 'components/login_form.dart';
import 'components/side_image_widget.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('###############    LoginScreen build   ##############');
    return Background(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Responsive(
            mobile: (BuildContext context) => const MobileLoginScreen(),
            largeMobile: (BuildContext context) => const MobileLoginScreen(),
            tablet: (BuildContext context) => const MobileLoginScreen(),
            largeTablet: (BuildContext context) => const DesktopLoginScreen(),
            desktop: (BuildContext context) => const DesktopLoginScreen(),
            largeDesktop: (BuildContext context) => const DesktopLoginScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SideImageWidget(
            // title: 'LOGIN',
            svgUrl: 'assets/icons/logo-ministry.svg'),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double w = Responsive.w(context);
    return Row(
      children: [
        const Expanded(
          child: SideImageWidget(
              // title: 'LOGIN',
              svgUrl: 'assets/icons/logo-ministry.svg'),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: w < 1200 ? w / 2 : w / 3,
                      child: const LoginForm()),
                ],
              ),
              const SizedBox(height: defaultPadding / 2),
              const SocialRegister()
            ],
          ),
        ),
      ],
    );
  }
}
