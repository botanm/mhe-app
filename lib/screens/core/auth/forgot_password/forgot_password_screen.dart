import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_constants.dart';
import '../../../../providers/i18n.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/responsive.dart';
import '../login/components/side_image_widget.dart';
import 'components/forgot_password_stepper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotPassword';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isInit = true;

  late final i18n i;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++    forgot_password_screen build     ++++++++++++++++++++++++');
    double w = Responsive.w(context);
    const ForgotPasswordStepper ref = ForgotPasswordStepper();
    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (w < 1000) const SizedBox(height: defaultPadding / 3),
            if (w < 1000) ref,
            if (!(w < 1000))
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ref,
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 3,
                    child: SideImageWidget(
                        // title: 'FORGOT PASSWORD',
                        svgUrl: 'assets/icons/logo-ministry.svg'),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
