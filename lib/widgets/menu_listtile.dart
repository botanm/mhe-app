import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  const MenuListTile({
    required this.e,
    this.contentPadding,
    required this.name,
    required this.isSelected,
    required this.onSelectedHandler,
    super.key,
  });

  final dynamic e;
  final EdgeInsets? contentPadding;
  final String name;
  final bool isSelected;
  final ValueChanged<dynamic> onSelectedHandler;

  @override
  Widget build(BuildContext context) {
    // print('*************** menu_listtile build ***************');
    const selectedColor = Colors.black;
    final style = isSelected
        ? const TextStyle(
            fontSize: 18,
            color: selectedColor,
            fontWeight: FontWeight.bold,
          )
        : const TextStyle(fontSize: 18);

    return ListTile(
      contentPadding: contentPadding,
      onTap: () => onSelectedHandler(e),
      leading: null, // FlagWidget(code: e.code),
      title: Text(name, style: style),
      trailing: isSelected
          ? const Icon(Icons.check, color: selectedColor, size: 26)
          : null,
    );
  }
}
