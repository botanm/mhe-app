import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';
import '../widgets/search_widget.dart';
import '../widgets/menu_listtile.dart';
import '../widgets/submit_button.dart';

class MenuNormalScreen extends StatefulWidget {
  const MenuNormalScreen({
    required this.allElements,
    required this.maSecName,
    this.multipleSelectionsAllowed = false,
    this.initialSelected = const [],
    required this.title,
    required this.selectButtonText,
    this.searchVisible = false,
    this.isSecondaryVisible = false,
    super.key,
  });

  final List<dynamic> allElements;
  final List<String> maSecName;
  final bool multipleSelectionsAllowed;
  final dynamic initialSelected;
  final String title;
  final String selectButtonText;
  final bool searchVisible;
  final bool isSecondaryVisible;

  @override
  _MenuNormalScreenState createState() => _MenuNormalScreenState();
}

class _MenuNormalScreenState extends State<MenuNormalScreen> {
  late final i18n i;
  String initialSearchText = '';
  List<dynamic> _selectedContainer = [];
  bool isSecondaryActive = false;

  late final List<String> _maSecName;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      _selectedContainer = widget.initialSelected;
      _maSecName = widget.maSecName;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool isContainsSearchText(dynamic e) {
    final name = isSecondaryActive ? e[_maSecName[1]] : e[_maSecName[0]];

    return name.toLowerCase().contains(initialSearchText.toLowerCase());
  }

  List<dynamic> getPrioritizedElements(List<dynamic> elements) {
    /// IF you want to sort according to _isSecondaryActive
    // final int i = _isSecondaryActive ? 1 : 0;
    // a[_maSecName[i]].compareTo(b[_maSecName[i]])

    final notSelectedElements = List.of(elements)
      ..removeWhere((e) => _selectedContainer.contains(e));

    return [
      ...List.of(_selectedContainer)
        ..sort((a, b) => a[_maSecName[0]].compareTo(b[_maSecName[0]])),
      ...notSelectedElements,
    ];
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** menu_screen build ***************');
    final allElements = getPrioritizedElements(widget.allElements);
    final elements = allElements.where(isContainsSearchText).toList();

    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: <Widget>[
          _buildAppBar,
          Expanded(
            child: ListView(
              children: elements.map((e) {
                String name =
                    isSecondaryActive ? e[_maSecName[1]] : e[_maSecName[0]];
                final bool isSelected = _selectedContainer.contains(e);

                return MenuListTile(
                  e: e,
                  name: name,
                  isSelected: isSelected,
                  onSelectedHandler: onSelectedElement,
                );
              }).toList(),
            ),
          ),
          _buildSelectButton(context),
        ],
      ),
    );
  }

  Container get _buildAppBar {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13), topRight: Radius.circular(13))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Utils.buildHandle(context),
          _buildSearchAndIsArabic(),
          const Divider(
            thickness: 1.0,
            height: 0.0,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndIsArabic() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: widget.searchVisible,
          replacement: Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          child: Expanded(
            child: SearchWidget(
              searchWord: initialSearchText,
              onChangedSearchTextHandler: (text) =>
                  setState(() => initialSearchText = text),
              hintText: '${i.tr('Search of')} ${widget.title}',
            ),
          ),
        ),
        Visibility(
          visible: widget.isSecondaryVisible,
          child: IconButton(
            icon: Icon(isSecondaryActive ? Icons.close : Icons.language,
                color: kPrimaryMediumColor),
            onPressed: () =>
                setState(() => isSecondaryActive = !isSecondaryActive),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    // final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        const Divider(
          thickness: 1.0,
          height: 0.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
          child: SubmitButton(
            text: widget.selectButtonText,
            height: 40.0,
            onPressedHandler: submit,
          ),
        ),
      ],
    );
  }

  void onSelectedElement(dynamic element) {
    if (widget.multipleSelectionsAllowed) {
      final isSelected = _selectedContainer.contains(element);
      setState(() => isSelected
          ? _selectedContainer.remove(element)
          : _selectedContainer.add(element));
    } else {
      Navigator.pop(context, element);
    }
  }

  void submit() => Navigator.pop(
      context, widget.multipleSelectionsAllowed ? _selectedContainer : null);
}
