import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/i18n.dart';
import '../widgets/icon_widget.dart';
import '../widgets/setting_group.dart';
import '../widgets/settings_tile.dart';
import 'contact_information_screen.dart';
// import '../../../widgets/setting_group.dart';
// import '../widgets/icon_widget.dart';
// import '../widgets/settings_tile.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help';
  const HelpScreen({super.key});
  static const Icon forwardIcon = Icon(Icons.arrow_forward_ios);

  @override
  Widget build(BuildContext context) {
    print('*************** help_screen build ***************');
    final i = Provider.of<i18n>(context, listen: false);

    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F2F8),
          centerTitle: true,
          elevation: 0,
          title: Text(i.tr('Help center'),
              style: const TextStyle(color: Colors.black)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            // _buildCommonIssuesGroup(context, i),
            const SizedBox(height: 16),
            _buildContactInformationGroup(context, i),
          ],
        ),
      ),
    );
  }

  SettingsGroup _buildCommonIssuesGroup(BuildContext context, i18n i) {
    return SettingsGroup(
      title: i.tr('Popular issues'),
      children: <Widget>[
        const SizedBox(height: 12),
        SettingsTile(
            leading: const IconWidget(
                icon: Icons.key, color: Color.fromARGB(255, 193, 143, 37)),
            title: i.tr('m72'),
            subtitle: null, //i.tr('Newsletter, App updates'),
            isTrailing: false,
            onTapHandler: () {
              // Navigator.pushNamed(context, HelpLoginScreen.routeName);
            }),
        const SizedBox(height: 12),
        SettingsTile(
            leading: const IconWidget(
                icon: Icons.password_outlined,
                color: Color.fromARGB(255, 193, 37, 123)),
            title: i.tr('Forgot password?'),
            subtitle: null, //i.tr('Newsletter, App updates'),
            isTrailing: false,
            onTapHandler: () {
              Navigator.pushNamed(context, ContactInformationScreen.routeName);
            }),
      ],
    );
  }

  SettingsGroup _buildContactInformationGroup(BuildContext context, i18n i) {
    return SettingsGroup(
      title: i.tr('m96'),
      children: <Widget>[
        const SizedBox(height: 12),
        SettingsTile(
            leading: const IconWidget(
                icon: Icons.contact_phone_rounded,
                color: Color.fromARGB(255, 120, 37, 193)),
            title: i.tr('m96'),
            subtitle: null, //i.tr('Newsletter, App updates'),
            isTrailing: false,
            onTapHandler: () {
              Navigator.pushNamed(context, ContactInformationScreen.routeName);
            }),
        const SizedBox(height: 12),
      ],
    );
  }
}
