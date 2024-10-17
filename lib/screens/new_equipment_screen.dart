import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/i18n.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/responsive.dart';
import '../providers/core.dart';
import '../widgets/equipment_form.dart';
import 'core/auth/login/components/side_image_widget.dart';
import 'core/auth/register/register_screen.dart';

class NewEquipmentScreen extends StatefulWidget {
  static const routeName = '/newEquipment';
  const NewEquipmentScreen({super.key});

  @override
  State<NewEquipmentScreen> createState() => _NewEquipmentScreenState();
}

class _NewEquipmentScreenState extends State<NewEquipmentScreen> {
  bool _isInit = true;

  late Map<String, dynamic>? args;
  late bool isAuth;
  late bool isStaff;
  Map<String, dynamic>? _editedEquipment;

  late final i18n i;
  late final Core cpr;
  late final Auth apr;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);

      args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        int editedId = args!['editedId'];
        _editedEquipment = cpr.findQuestionById(editedId);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++    new_equipment_screen build     ++++++++++++++++++++++++');
    final EquipmentForm ref = EquipmentForm(
      editedEquipment: _editedEquipment,
    );
    MobileNewScreen smallScreen = MobileNewScreen(
        rf: ref,
        up: const SizedBox.shrink(),
        topImage: const SizedBox(width: 12));

    DesktopNewScreen largeScreen = DesktopNewScreen(
      rf: ref,
      uProfileButton: const SizedBox.shrink(),
      sideImage: const SideImageWidget(
          // title: 'NEW EQUIPMENT',
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
}
