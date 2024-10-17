import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';

class SMBSActionSheetWidget extends StatelessWidget {
  final List<Widget> items;

  const SMBSActionSheetWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final i = Provider.of<i18n>(context, listen: false);
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utils.handle(context),
          Flexible(child: ListView(shrinkWrap: true, children: items)),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required List<Widget> items,
  }) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      shape: kBuildTopRoundedRectangleBorder,
      context: context,
      builder: (ctx) => SMBSActionSheetWidget(
        items: items,
      ),
    );
  }
}
