import 'package:flutter/material.dart';

import 'icon_widget.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconWidget(icon: icon, color: Colors.black26),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
