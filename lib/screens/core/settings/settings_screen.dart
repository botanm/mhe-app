import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/auth.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/icon_widget.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/setting_group.dart';
import '../../../widgets/settings_tile.dart';
import '../../contact_information_screen.dart';
import '../../myquestions_screen.dart';
import '../auth/register/register_screen.dart';
import 'account_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});
  static const Icon forwardIcon = Icon(Icons.arrow_forward_ios);

  @override
  Widget build(BuildContext context) {
    print('*************** settings_screen build ***************');
    final i = Provider.of<i18n>(context, listen: false);
    final apr = Provider.of<Auth>(context, listen: false);
    // final bpr = Provider.of<Basics>(context, listen: false);

    // final bool isAuth = apr.isAuth;
    final Map<String, dynamic>? me = apr.me;
    const bool isSuperuser = true; //me != null ? me['is_superuser'] : false;
    const bool isStaff = true; // me != null ? me['is_staff'] : false;

    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F2F8),
          centerTitle: true,
          elevation: 0,
          title: Text(i.tr('Settings'),
              style: const TextStyle(color: Colors.black)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            if (me != null) _settingsHeader(context, i, me),
            const SizedBox(height: defaultPadding),
            // _buildGeneralGroup(context, i),
            if (me != null)
              _buildSettingsPrivacyGroup(context, i, apr, 1, isSuperuser,
                  isStaff), // (context, i, apr, me['id'], isSuperuser, isStaff),
            _buildFeedbackSettingsGroup(context, i),
          ],
        ),
      ),
    );
  }

  Widget _settingsHeader(
      BuildContext context, i18n i, Map<String, dynamic> me) {
    double coverHeight = 120;
    double avatarRadius = 32;

    final bottom = avatarRadius;
    final top1 = coverHeight - avatarRadius;
    // final top2 = coverHeight - 2 * avatarRadius;

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: _buildCoverImage(coverHeight, me)),

          // Positioned(
          //   top: 8,
          //   child: _buildListTile(context, i, me),
          // ),
          Positioned(top: top1, child: _buildAvatarImage(avatarRadius, me))
        ]);
  }

  Widget _buildListTile(BuildContext context, i18n i, Map<String, dynamic> me) {
    return GestureDetector(
      onTap: () {
        // final Map<String, dynamic> args = {
        //   'editedUserId': me['id'],
        //   'isChangePassword': false,
        //   'isViewOnly': false
        // };
        // Navigator.popAndPushNamed(context, '/register', arguments: args);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          const Icon(Icons.edit, color: kPrimaryColor),
          const SizedBox(height: 12),
          Text(me[i.maSecUserName[0]],
              style: const TextStyle(
                  color: KScaffoldBackgroundColor,
                  fontWeight: FontWeight.bold)),
          Text(me['email'],
              style: const TextStyle(
                  color: KScaffoldBackgroundColor, fontSize: 13))
        ],
      ),
    );
  }

  Widget _buildCoverImage(double coverHeight, Map<String, dynamic> me) {
    return CoverWidget(
      imagePath: me['AnswererProfile'] == null
          ? null
          : me['AnswererProfile']['cover_image'],
      coverHeight: coverHeight,
      coverBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    );
  }

  Widget _buildAvatarImage(double avatarRadius, Map<String, dynamic> me) =>
      AvatarWidget(
        imagePath: me['photo'],
        size: avatarRadius,
      );

  SettingsGroup _buildGeneralGroup(BuildContext context, i18n i) {
    return SettingsGroup(
      title: i.tr('GENERAL'),
      children: <Widget>[
        SettingsTile(
            leading: const IconWidget(
                icon: Icons.notifications,
                color: Color.fromARGB(255, 193, 143, 37)),
            title: i.tr('Notifications'),
            subtitle: i.tr('Newsletter, App updates'),
            isTrailing: false,
            onTapHandler: () {}
            // Navigator.pushNamed(context, BookmarksScreen.routeName),
            ),
        SettingsTile(
          leading: const IconWidget(
            icon: Icons.question_mark,
            color: Colors.green,
          ),
          title: i.tr('My Questions'),
          subtitle: i.tr('The questions I sent'),
          isTrailing: false,
          onTapHandler: () =>
              Navigator.pushNamed(context, MyQuestionsScreen.routeName),
        ),
        SettingsTile(
            leading: const IconWidget(
              icon: Icons.bookmarks_outlined,
              color: Colors.blue,
            ),
            title: i.tr('Bookmarks'),
            isTrailing: false,
            onTapHandler: () {}
            // Navigator.pushNamed(context, BookmarksScreen.routeName),
            ),
        const SizedBox(height: 25)
      ],
    );
  }

  SettingsGroup _buildSettingsPrivacyGroup(BuildContext context, i18n i,
      Auth apr, int userId, bool isSuperuser, bool isStaff) {
    final double w = Responsive.w(context);
    return SettingsGroup(
      title: i.tr('SETTINGS & PRIVACY'),
      children: <Widget>[
        // if (isSuperuser || isStaff)
        //   SettingsTile(
        //       leading: const IconWidget(
        //         icon: Icons.groups,
        //         color: Colors.brown,
        //       ),
        //       title: i.tr('Accounts'),
        //       subtitle: i.tr('m51'),
        //       isTrailing: true,
        //       onTapHandler: () => null
        //       // Navigator.pushNamed(context, AccountsListScreen.routeName),
        //       ),
        // if (isSuperuser || isStaff)
        //   SettingsTile(
        //       leading: const IconWidget(
        //         icon: Icons.foundation_outlined,
        //         color: Color.fromARGB(255, 120, 11, 130),
        //       ),
        //       title: i.tr('Basics'),
        //       subtitle: i.tr('m51'),
        //       isTrailing: true,
        //       onTapHandler: () => null
        //       // Navigator.pushNamed(context, BasicsScreen.routeName),
        //       ),
        SettingsTile(
            leading: const IconWidget(
              icon: Icons.settings,
              color: Colors.orange,
            ),
            title: i.tr('Account preferences'),
            subtitle: i.tr('Privacy, Security, Language'),
            isTrailing: true,
            onTapHandler: () {
              if (w < 1024) {
                Navigator.pushReplacementNamed(
                    context, AccountPreferencesScreen.routeName);
              } else {
                Navigator.pop(context);
                showDialog(
                    // barrierColor: kPrimaryLightColor.withOpacity(0.2),
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        elevation: 1,
                        shape: kBuildTopRoundedRectangleBorder,
                        child: FractionallySizedBox(
                            heightFactor: 0.5,
                            widthFactor: 0.5,
                            child: AccountPreferencesScreen()),
                      );
                    });
              }
            }),
        SettingsTile(
          leading: const IconWidget(
            icon: Icons.key,
            color: Colors.black26,
          ),
          title: i.tr('Change password'),
          subtitle: i.tr('m1'),
          isTrailing: false,
          onTapHandler: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(RegisterScreen.routeName,
                arguments: {
                  'editedUserId': userId,
                  'isChangePassword': true,
                  'isViewOnly': false
                });
          },
        ),
        SettingsTile(
          leading: const IconWidget(
            icon: Icons.logout,
            color: Colors.redAccent,
          ),
          title: i.tr('Logout'),
          isTrailing: false,
          onTapHandler: () {
            Navigator.of(context).pop();
            apr.logout();
          },
        ),
        const SizedBox(height: 25)
      ],
    );
  }

  SettingsGroup _buildFeedbackSettingsGroup(BuildContext context, i18n i) {
    return SettingsGroup(
      title: i.tr('FEEDBACK'),
      children: <Widget>[
        SettingsTile(
            leading: const IconWidget(
              icon: Icons.bug_report,
              color: Colors.teal,
            ),
            title: i.tr('Report A Bug'),
            isTrailing: false,
            onTapHandler: () {
              Navigator.pushNamed(context, ContactInformationScreen.routeName);
            }),
        // SettingsTile(
        //     leading: const IconWidget(
        //       icon: Icons.thumb_up,
        //       color: Colors.purple,
        //     ),
        //     title: i.tr('Send Feedback'),
        //     isTrailing: false,
        //     onTapHandler: () => null
        //     // Navigator.pushNamed(context, BookmarksScreen.routeName),
        //     ),
      ],
    );
  }
}
