import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget(
      {required this.menuList,
      this.color = Colors.white,
      this.icon = const Icon(
        Icons.more_vert,
        color: kPrimaryColor,
      ),
      super.key});

  // final List<PopupMenuEntry> menuList;
  final List<dynamic> menuList;
  final Color color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // offset: Offset(0.0, 32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      color: color,
      icon: icon,
      itemBuilder: (BuildContext context) =>
          menuList.map((e) => _buildPopupMenuItem(context, e)).toList(),
    );
  }

  PopupMenuItem _buildPopupMenuItem(context, dynamic item) {
    final i18n i = Provider.of<i18n>(context, listen: false);
    return PopupMenuItem(
      child: Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: item),
    );
  }
}
