import 'package:flutter/material.dart';
import '../constants/app_constants.dart' as app_constants;
import '../constants/app_constants.dart';
import '../screens/menu_normal_screen.dart';
import '../screens/menu_tree_screen.dart';
import 'responsive.dart';

class MenuPicker extends StatefulWidget {
  const MenuPicker({
    super.key,
    required this.allElements,
    required this.maSecName,
    required this.initialSelected,
    this.multipleSelectionsAllowed = false,
    required this.selectedHandler,
    this.isScrollControlled = false,
    this.heightFactor = 1.0,
    required this.title,
    this.borderRadius = 40.0,
    this.selectedColorOfPicker = Colors.black,
    required this.selectButtonText,
    required this.searchVisible,
    required this.isSecondaryVisible,
    required this.isEnabled,
    this.isTree = false,
    this.isValidated = true,
  });

  final List<dynamic> allElements;
  final List<String> maSecName;
  final List<dynamic> initialSelected; // list of id of selected items
  final bool multipleSelectionsAllowed;
  final Function(dynamic) selectedHandler;
  final bool
      isScrollControlled; //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
  final double heightFactor;
  final String title;
  final double borderRadius;
  final Color selectedColorOfPicker;
  final String selectButtonText;
  final bool searchVisible;
  final bool isSecondaryVisible;
  final bool isEnabled;
  final bool isTree;
  final bool isValidated;

  @override
  State<MenuPicker> createState() => _MenuPickerState();
}

class _MenuPickerState extends State<MenuPicker> {
  late List<dynamic> _selectedContainer;
  late final List<String> _maSecName;

  @override
  void initState() {
    _maSecName = widget.maSecName;
    _runInInitAndUpdate;

    super.initState();
  }

  @override
  void didUpdateWidget(MenuPicker oldWidget) {
    if (oldWidget.initialSelected != widget.initialSelected) {
      _runInInitAndUpdate;
    }
    super.didUpdateWidget(oldWidget);
  }

  void get _runInInitAndUpdate {
    if (widget.initialSelected.isEmpty || widget.allElements.isEmpty) {
      _selectedContainer = [];
    } else {
      _selectedContainer = widget.initialSelected.map((se) {
        return widget.allElements.firstWhere((e) => e['id'] == se);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** _menu_picker build ***************');
    bool selectedContainerIsEmpty = _selectedContainer.isEmpty;
    final selectedContainerText = !selectedContainerIsEmpty
        ? _selectedContainer.map((e) {
            return e[_maSecName[0]];
          }).join(', ')
        : null;

    return _buildPicker(
      drawBorder: selectedContainerIsEmpty ? true : false,
      child: _buildListTile(
        title: selectedContainerText ?? widget.title,
        textIconColor: selectedContainerIsEmpty
            ? Colors.black.withOpacity(0.40)
            : Colors.white,
        tileColor: selectedContainerIsEmpty
            ? Colors.transparent
            : widget.selectedColorOfPicker.withOpacity(0.60),
      ),
    );
  }

  Widget _buildPicker({
    bool drawBorder = true,
    required Widget child,
  }) =>
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: drawBorder
                ? Border.all(
                    width: 1.1,
                    color: !widget.isValidated
                        ? Colors.red.shade400
                        : Colors.black.withOpacity(0.40), // red as border color
                  )
                : null,
          ),
          child: child);

  Widget _buildListTile({
    required String title,
    Color? textIconColor,
    Color? tileColor,
  }) {
    return ListTile(
      onTap: widget.isEnabled ? _onTap : null,
      leading: _selectedContainer.length > 1
          ? CircleAvatar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              maxRadius: 10,
              child: Text('${_selectedContainer.length}'),
            )
          : null,
      title: Text(
        title,
        // textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: textIconColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: textIconColor),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      dense: true,
      selected: true,
      selectedTileColor: tileColor,
    );
  }

  void _onTap() async {
    dynamic retrieveSelected = await _openTheMenu();
    if (retrieveSelected == null) return;

    setState(() => _selectedContainer = widget.multipleSelectionsAllowed
        ? retrieveSelected
        : [retrieveSelected]);

    // send callback
    final List<int> selectedIds =
        _selectedContainer.map((e) => e['id'] as int).toList();
    widget.selectedHandler(
        widget.multipleSelectionsAllowed ? selectedIds : selectedIds[0]);
  }

  Future<dynamic> _openTheMenu() async {
    final double w = Responsive.w(context);
    final bool isLargeTablet = Responsive.isLargeTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isLargeDesktop = Responsive.isLargeDesktop(context);

    Widget menuScreen = widget.isTree
        ? MenuTreeScreen(
            allElements: widget.allElements,
            maSecName: _maSecName,
            multipleSelectionsAllowed: widget.multipleSelectionsAllowed,
            initialSelected: List.of(_selectedContainer),
            title: widget.title,
            selectButtonText: widget.selectButtonText,
            searchVisible: widget.searchVisible,
            isSecondaryVisible: widget.isSecondaryVisible,
          )
        : MenuNormalScreen(
            allElements: widget.allElements,
            maSecName: _maSecName,
            multipleSelectionsAllowed: widget.multipleSelectionsAllowed,
            initialSelected: List.of(_selectedContainer),
            title: widget.title,
            selectButtonText: widget.selectButtonText,
            searchVisible: widget.searchVisible,
            isSecondaryVisible: widget.isSecondaryVisible,
          );

    // MOBILE
    if (w < 1200) {
      return await showModalBottomSheet(
        isScrollControlled: widget.isScrollControlled, //to Maximize BottomSheet
        backgroundColor: KScaffoldBackgroundColor,
        shape: app_constants.kBuildTopRoundedRectangleBorder,
        context: context,
        builder: (context) => FractionallySizedBox(
          heightFactor: widget.heightFactor,
          child: menuScreen,
        ),
      ); //builder: (context) => Container();
    }
    // DESKTOP
    else {
      return await showDialog(
          // barrierColor: kPrimaryLightColor.withOpacity(0.2),
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 1,
              shape: app_constants.kBuildAllRoundedRectangleBorder,
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: isDesktop ? 0.5 : (isLargeDesktop ? 0.4 : 0.7),
                child: menuScreen,
              ),
            );
          });
    }
  }
}
