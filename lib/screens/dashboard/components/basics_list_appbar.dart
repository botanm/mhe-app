import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/search_widget.dart';

class BasicsListAppBar extends StatefulWidget {
  const BasicsListAppBar({
    super.key,
    required this.onAddHandler,
    this.isSearchActive = false,
    this.onToggleSearchHandler,
    this.searchBox,
    this.isSecondaryActive = false,
    this.onToggleSecondaryHandler,
    required this.title,
  });
  final void Function() onAddHandler;
  final bool isSearchActive;
  final void Function()? onToggleSearchHandler;
  final SearchWidget? searchBox;
  final bool isSecondaryActive;
  final void Function()? onToggleSecondaryHandler;
  final String title;

  @override
  State<BasicsListAppBar> createState() => _BasicsListAppBarState();
}

class _BasicsListAppBarState extends State<BasicsListAppBar> {
  bool isArabicActive = false;

  @override
  Widget build(BuildContext context) {
    // print('*************** basics_list_appbar build ***************');
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.add, size: 30, color: kPrimaryColor),
        onPressed: widget.onAddHandler,
      ),
      title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      actions: [
        Visibility(
          visible: widget.searchBox != null,
          child: IconButton(
            icon: Icon(widget.isSearchActive ? Icons.search_off : Icons.search,
                color: kPrimaryColor),
            onPressed: widget.onToggleSearchHandler,
          ),
        ),
        Visibility(
          visible: widget.onToggleSecondaryHandler != null,
          child: IconButton(
            icon: Icon(widget.isSecondaryActive ? Icons.close : Icons.language,
                color: kPrimaryColor),
            onPressed: widget.onToggleSecondaryHandler,
          ),
        ),
      ],
      bottom: widget.searchBox != null && widget.isSearchActive
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: SizedBox(
                height: 50,
                child: widget.searchBox!,
              ),
            )
          : null,
    );
  }
}
