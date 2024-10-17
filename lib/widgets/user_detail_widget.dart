import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/basics.dart';
import '../providers/core.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';
import 'top_widget.dart';

class UserDetailWidget extends StatefulWidget {
  const UserDetailWidget({required this.id, super.key});
  final int id;

  @override
  State<UserDetailWidget> createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final Map<String, dynamic> info;

  late Future<void> _futureInstance;

  Future<void> _getUserData() async {
    info = cpr.findUserById(widget.id);

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context);

      _futureInstance = _getUserData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureInstance,
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return kCircularProgressIndicator;
          } else {
            if (asyncSnapshot.hasError) {
              // ...
              // Do error handling stuff
              return Center(child: Text('${asyncSnapshot.error}'));
              //return Center(child: Text('An error occurred!'));
            } else {
              return _buildDispaly();
            }
          }
        });
  }

  Column _buildDispaly() {
    final String? coverInitialImagePath = info['AnswererProfile'] == null
        ? null
        : info['AnswererProfile']['cover_image'];
    final String? avatarInitialImagePath = info['AnswererProfile'] == null
        ? null
        : info['AnswererProfile']['avatar'];
    return Column(
      children: [
        TopWidget(
          cInitialImagePath: coverInitialImagePath,
          aInitialImagePath: avatarInitialImagePath,
        ),
        _buildContent,
      ],
    );
  }

  Widget get _buildContent {
    final String rolesName = info['roles']
        .map((id) {
          final Map<String, dynamic> role = bpr.findBasicById('role', id);
          if (role.isNotEmpty) {
            return role[i.maSecBasicName[0]];
          } else {
            return null;
          }
        })
        .where((name) => name != null && name.isNotEmpty)
        .join(', ');
    final String phones = info['phone'].join(', ');
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Text(info[i.maSecUserName[0]],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(rolesName,
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        const SizedBox(height: 8),
        Text(info['email'],
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        Text(phones,
            style: const TextStyle(fontSize: 13, color: Colors.black38)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(FontAwesomeIcons.linkedin, () {
              Utils.openBrowserUrl(
                  url: info['AnswererProfile']['linkedin'], inApp: true);
            }),
            const SizedBox(width: 12),
            _buildSocialIcon(FontAwesomeIcons.googleScholar, () {
              Utils.openBrowserUrl(
                  url: info['AnswererProfile']['google_scholar'], inApp: true);
            }),
            const SizedBox(width: 12),
            _buildSocialIcon(FontAwesomeIcons.googlePlusG, () {
              Utils.openBrowserUrl(
                  url: info['AnswererProfile']['research_gate'], inApp: true);
            }),
          ],
        ),
        const SizedBox(height: 16),
        const FractionallySizedBox(widthFactor: 0.8, child: Divider()),
        const SizedBox(height: 16),
        buildAbout,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, void Function() onTap) => CircleAvatar(
        radius: 25,
        backgroundColor: kPrimaryLightColor,
        child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Center(child: Icon(icon, size: 32)),
            )),
      );

  Widget get buildAbout {
    final List<dynamic> tags = info['AnswererProfile']['tags'] ?? [];
    List<dynamic> allTagTexts = [];
    final List<dynamic> generalSpecializationIds =
        info["ResearcherProfile"]["general_specialization_id"];

    if (generalSpecializationIds.isNotEmpty) {
      List<String> generalSpecializationText = Utils.getTextById(
          generalSpecializationIds, bpr.categories, i.maSecBasicName[0]);
      allTagTexts = tags + generalSpecializationText;
    }
    List<int> allParents = info['organization_id'] == null
        ? []
        : Utils.getAllParents([], info['organization_id'], bpr.cities);

    final allParentsText =
        Utils.joinTexts(allParents, bpr.cities, i.maSecBasicName[0], ' >>');

    final String? aboutText = info['AnswererProfile'][i.maSecAbout[0]];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(i.tr('About'),
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(allParentsText,
              style: const TextStyle(fontSize: 13, color: Colors.black38)),
          Text(allTagTexts.join(',  '),
              style: const TextStyle(fontSize: 13, color: Colors.black38)),
          const SizedBox(height: 16),
          if (aboutText != null)
            Text(aboutText, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
