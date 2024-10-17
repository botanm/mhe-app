import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/basics.dart';
import '../../../providers/i18n.dart';
import '../../../providers/core.dart';
import '../../../utils/utils.dart';
import '../../../widgets/setting_group.dart';
import '../../../widgets/menu_picker.dart';

class AccountPreferencesScreen extends StatelessWidget {
  static const routeName = '/account_preferences';
  const AccountPreferencesScreen({super.key});
  static const Icon forwardIcon = Icon(Icons.arrow_forward_ios);

  @override
  Widget build(BuildContext context) {
    // print('*************** settings_screen build ***************');
    final i = Provider.of<i18n>(context, listen: false);
    final bpr = Provider.of<Basics>(context, listen: false);
    final qpr = Provider.of<Core>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    // final List<dynamic> _dialects = bpr.dialects;
    // final List<String> _maSecBasicName = i.maSecBasicName;

    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F2F8),
          centerTitle: true,
          elevation: 0,
          title: Text(i.tr('Account preferences'),
              style: const TextStyle(color: Colors.black)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            _buildLanguageGroup(context, i),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  SettingsGroup _buildLanguageGroup(BuildContext context, i18n i) {
    return SettingsGroup(
      title: i.tr('Language'),
      children: <Widget>[
        const SizedBox(height: 12),
        _buildSelectAppLanguage(context, i),
      ],
    );
  }

  MenuPicker _buildSelectAppLanguage(BuildContext ctx, i18n i) {
    final int currentActiveLanguageID =
        Utils.getDialectIDByLanguageCode(i.locale);

    return MenuPicker(
      allElements: i18n.locales,
      maSecName: i.maSecBasicName,
      initialSelected: [
        currentActiveLanguageID
      ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (id) {
        Navigator.of(ctx).pop();
        i.changeLocale(Utils.getLanguageCodeByDialectID(id));
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('Language'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: Colors.black,
      selectButtonText: i.tr('Continue'),
      searchVisible: false,
      isSecondaryVisible: true,
      isEnabled: true,
      isValidated: true,
    );
  }
}
