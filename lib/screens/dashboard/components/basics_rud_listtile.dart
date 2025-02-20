import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/action_sheet_widget.dart';
import '../../../widgets/menu_item_widget.dart';
import '../../../widgets/pop_up_menu_button_widget.dart';
import '../../../widgets/responsive.dart';

class BasicsRUDListTile extends StatefulWidget {
  const BasicsRUDListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isSuperuserOrMe = true,
    this.showViewBtn = true,
    required this.onViewHandler,
    required this.onEditHandler,
    this.onResetHandler,
    required this.deletePayload,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSuperuserOrMe;
  final bool showViewBtn;
  final void Function() onViewHandler;
  final void Function() onEditHandler;
  final void Function()? onResetHandler;
  final Map<String, String> deletePayload;

  @override
  State<BasicsRUDListTile> createState() => _BasicsRUDListTileState();
}

class _BasicsRUDListTileState extends State<BasicsRUDListTile> {
  late final i18n i;

  bool _isInit = true;
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
    // print('*************** basics_rud_listtile build ***************');

    final List<Widget> items = [
      if (widget.showViewBtn)
        MenuItemWidget(
          icon: Icons.fullscreen,
          title: i.tr('View'),
          subtitle: i.tr('m47'),
          onTap: widget.onViewHandler,
        ),
      MenuItemWidget(
        icon: Icons.edit,
        title: i.tr('Edit'),
        subtitle: i.tr('m22'),
        onTap: widget.onEditHandler,
      ),
      if (widget.onResetHandler != null)
        MenuItemWidget(
          icon: Icons.key_outlined,
          title: i.tr('m30'),
          subtitle: i.tr('m48'),
          onTap: widget.onResetHandler!,
        ),
      MenuItemWidget(
        icon: Icons.delete_outline,
        title: i.tr('Delete'),
        subtitle: i.tr('m49'),
        onTap: () => (),
      ),
    ];

    final bool isSmallScreen = Responsive.w(context) < 1200;
    return ListTile(
      leading: widget.leading,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: widget.trailing == null && !isSmallScreen
          ? PopupMenuButtonWidget(menuList: items)
          : widget.trailing,
      onTap: (isSmallScreen) && widget.isSuperuserOrMe
          ? () => SMBSActionSheetWidget.show(
                context: context,
                items: items,
              )
          : null,
      dense: true,
    );
  }
}
