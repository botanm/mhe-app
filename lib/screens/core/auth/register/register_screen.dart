import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_constants.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/core.dart';
import '../../../../providers/i18n.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/gradient_button.dart';
import '../../../../widgets/responsive.dart';
import '../../../answerer_profile_screen.dart';
import '../login/components/side_image_widget.dart';
import 'components/register_form.dart';
import 'components/social_register.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isInit = true;

  late Map<String, dynamic>? args;
  late bool isAuth;
  late bool isStaff;
  Map<String, dynamic>? _editedUser;

  bool _isChangePassword = false;
  bool _isViewOnly = false;

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
      isStaff = apr.isStaff;
      args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        int editedUserId = args!['editedUserId'];
        final bool isMe = editedUserId == int.parse(apr.userId!);

        _editedUser = isMe ? apr.me : cpr.findUserById(editedUserId);
        _isChangePassword = args!['isChangePassword'];
        _isViewOnly = args!['isViewOnly'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     register_screen build     ++++++++++++++++++++++++');
    final RegisterForm registerForm = RegisterForm(
        isAuth: isAuth,
        isStaff: isStaff,
        editedUser: _editedUser,
        isChangePassword: _isChangePassword,
        isViewOnly: _isViewOnly);
    final Widget apb = getAnswererProfileButton();
    SideImageWidget sideImageWidget = const SideImageWidget(
        // title: 'Register',
        svgUrl: 'assets/icons/logo-ministry.svg');
    MobileNewScreen mobileNewScreen = MobileNewScreen(
      rf: registerForm,
      up: apb,
      topImage: sideImageWidget,
    );

    DesktopNewScreen desktopNewScreen = DesktopNewScreen(
      rf: registerForm,
      uProfileButton: apb,
      sideImage: sideImageWidget,
    );

    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: (BuildContext context) => mobileNewScreen,
          largeMobile: (BuildContext context) => mobileNewScreen,
          tablet: (BuildContext context) => mobileNewScreen,
          largeTablet: (BuildContext context) => desktopNewScreen,
          desktop: (BuildContext context) => desktopNewScreen,
          largeDesktop: (BuildContext context) => desktopNewScreen,
        ),
      ),
    );
  }

  Widget getAnswererProfileButton() {
    Widget up = const SizedBox(height: 10);
    if (_editedUser != null &&
        _editedUser!['AnswererProfile'] != null &&
        _editedUser!['id'] == int.parse(apr.userId!)) {
      up = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(
                        context, AnswererProfileScreen.routeName);
                  },
                  text: i.tr("answerer profile")),
            ],
          ),
          up
        ],
      );
    }
    return up;
  }
}

class MobileNewScreen extends StatelessWidget {
  const MobileNewScreen({
    required this.rf,
    required this.up,
    required this.topImage,
    super.key,
  });
  final Widget rf;
  final Widget up;
  final Widget topImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        topImage,
        up,
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: rf,
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class DesktopNewScreen extends StatelessWidget {
  const DesktopNewScreen({
    required this.rf,
    required this.uProfileButton,
    required this.sideImage,
    super.key,
  });
  final Widget rf;
  final Widget uProfileButton;
  final Widget sideImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: sideImage,
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              uProfileButton,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 550, child: rf),
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
