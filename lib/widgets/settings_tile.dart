import 'package:flutter/material.dart';

import 'icon_widget.dart';

class SettingsTile extends StatelessWidget {
  final IconWidget leading;
  final String title;
  final String? subtitle;
  final bool isTrailing;
  final void Function()? onTapHandler;
  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.isTrailing,
    required this.onTapHandler,
  });

  @override
  Widget build(BuildContext context) {
    // print('*************** settings_tile build ***************');
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: isTrailing
          ? const Icon(
              Icons.arrow_forward_ios,
            )
          : null,
      onTap: onTapHandler,
      dense: true,
    );
  }
}
