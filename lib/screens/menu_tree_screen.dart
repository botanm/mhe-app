import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';
import '../widgets/search_widget.dart';
import '../widgets/menu_listtile.dart';
import '../widgets/submit_button.dart';

class MenuTreeScreen extends StatefulWidget {
  const MenuTreeScreen({
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
  _MenuTreeScreenState createState() => _MenuTreeScreenState();
}

class _MenuTreeScreenState extends State<MenuTreeScreen> {
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

  List<Map<String, dynamic>> _buildTree(
      List<dynamic> rootParents, List<dynamic> elements) {
    return rootParents.map((e) {
      return {
        "id": e['id'],
        "name": e['name'],
        "ckb_name": e['ckb_name'],
        "ar_name": e['ar_name'],
        "order": e['order'],
        "children": _buildTree(
            elements.where((ce) => ce['parent_id'] == e['id']).toList(),
            elements)
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** menu_tree_screen build ***************');
    final allElements =
        widget.allElements; // getPrioritizedElements(widget.allElements);
    final elements = allElements.where(isContainsSearchText).toList();
    List<dynamic> rootParents =
        elements.where((e) => e['parent_id'] == null).toList();
    List<dynamic> theTree = _buildTree(rootParents, elements);
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: <Widget>[
          _buildAppBar,
          Expanded(
            child: ListView(
              children: theTree.map(buildTile).toList(),
            ),
          ),
          _buildSelectButton(context),
        ],
      ),
    );
  }

  Widget buildTile(dynamic e, {double leftPadding = defaultPadding}) {
    List<Map<String, dynamic>> hisChildren =
        e['children'] as List<Map<String, dynamic>>;
    String name = isSecondaryActive ? e[_maSecName[1]] : e[_maSecName[0]];
    final bool isRtl = i.isRtl;
    if (hisChildren.isEmpty) {
      final bool isSelected =
          _selectedContainer.any((item) => item['id'] == e['id']);
      // _selectedContainer.contains(e); // the commented line did not work for me

      return MenuListTile(
        e: e,
        contentPadding: EdgeInsets.only(
            right: isRtl ? leftPadding + 7 : 0,
            left: !isRtl ? leftPadding + 7 : 0),
        name: name,
        isSelected: isSelected,
        onSelectedHandler: onSelectedElement,
      );
    } else {
      hisChildren = getPrioritizedChildren(hisChildren);
      return GestureDetector(
        onLongPress: () {
          onSelectedElement(e);
        },
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(
              right: isRtl ? leftPadding : 0, left: !isRtl ? leftPadding : 0),
          trailing: const SizedBox
              .shrink(), // remove trailing icons; to replace it with another icon in next line
          leading: const Icon(Icons
              .add_outlined), // const Icon(Icons.keyboard_arrow_right_outlined),
          collapsedIconColor: kPrimaryColor,
          collapsedTextColor: kPrimaryColor,
          textColor: kPrimaryColor,
          title: Text(name),
          children: hisChildren
              .map((c) => buildTile(c, leftPadding: 16 + leftPadding))
              .toList(),
        ),
      );
    }
  }

  List<Map<String, dynamic>> getPrioritizedChildren(
      List<Map<String, dynamic>> hisChildren) {
    final sterileElements = List.of(hisChildren)
      ..removeWhere((e) {
        List c = e['children'];
        return c.isNotEmpty;
      });

    final notSterileElements = List.of(hisChildren)
      ..removeWhere((e) {
        List c = e['children'];
        return c.isEmpty;
      });

    hisChildren = [
      ...notSterileElements
        ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0)),
      ...sterileElements
        ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0)),
      // ...List.of(hisChildren)
      // ..sort((a, b) => a['children'].length.compareTo(b['children'].length)
      //     //& a['order'].compareTo(b['order'])
      //     ),
    ];
    return hisChildren;
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
