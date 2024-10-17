import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/i18n.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/gradient_button.dart';
import '../../../../widgets/responsive.dart';
import '../providers/core.dart';
import '../widgets/answerer_profile_form.dart';
import 'core/auth/login/components/side_image_widget.dart';
import 'core/auth/register/register_screen.dart';

class AnswererProfileScreen extends StatefulWidget {
  static const routeName = '/answerer-profile';
  const AnswererProfileScreen({super.key});

  @override
  State<AnswererProfileScreen> createState() => _AnswererProfileScreenState();
}

class _AnswererProfileScreenState extends State<AnswererProfileScreen> {
  bool _isInit = true;

  late bool isAuth;
  late bool isStaff;
  Map<String, dynamic>? _editedUser;

  late final i18n i;
  late final Core cpr;
  late final Auth apr;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);

      isAuth = apr.isAuth;
      isStaff =
          !isAuth ? false : cpr.findUserById(int.parse(cpr.userId))['is_staff'];

      _editedUser = apr.me;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     researcher_profile_screen build     ++++++++++++++++++++++++');
    const AnswererProfileForm rpf = AnswererProfileForm();

    final Widget up = getUserProfileButton();
    MobileNewScreen smallScreen =
        MobileNewScreen(rf: rpf, up: up, topImage: const SizedBox.shrink());
    DesktopNewScreen largeScreen = DesktopNewScreen(
      rf: rpf,
      uProfileButton: up,
      sideImage: const SideImageWidget(
          // title: 'Researcher Profile',
          svgUrl: 'assets/icons/logo-ministry.svg'),
    );

    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: (BuildContext context) => smallScreen,
          largeMobile: (BuildContext context) => smallScreen,
          tablet: (BuildContext context) => smallScreen,
          largeTablet: (BuildContext context) => smallScreen,
          desktop: (BuildContext context) => largeScreen,
          largeDesktop: (BuildContext context) => largeScreen,
        ),
      ),
    );
  }

  Widget getUserProfileButton() {
    Widget up = const SizedBox(height: 10);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
                onPressed: () {
                  final Map<String, dynamic> arguments = {
                    'editedUserId': _editedUser!['id'] as int,
                    'isChangePassword': false,
                    'isViewOnly': false
                  };

                  Navigator.popAndPushNamed(context, '/register',
                      arguments: arguments);
                },
                text: i.tr("user profile")),
          ],
        ),
        up
      ],
    );
  }
}
