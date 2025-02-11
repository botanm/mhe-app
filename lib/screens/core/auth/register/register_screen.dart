import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_constants.dart';
import '../../../../providers/i18n.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/responsive.dart';
import '../login/components/side_image_widget.dart';
import 'components/register_stepper.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    GestureDetector ref = GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const RegisterStepper());

    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (w < 1000) const SizedBox(height: defaultPadding / 3),
            if (w < 1000) ref,
            if (!(w < 1000))
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ref,
                  ),
                  const SizedBox(width: defaultPadding),
                  const Expanded(
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
