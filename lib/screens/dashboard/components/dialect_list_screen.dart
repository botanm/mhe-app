import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/basics.dart';
import '../../../providers/i18n.dart';
import '../../../utils/utils.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/search_widget.dart';
import 'basics_list_appbar.dart';
import 'basics_rud_listtile.dart';
import 'new_dialect_screen.dart';

class DialectListScreen extends StatefulWidget {
  static const routeName = '/dialectlist';
  const DialectListScreen({
    super.key,
  });

  @override
  State<DialectListScreen> createState() => _DialectListScreenState();
}

class _DialectListScreenState extends State<DialectListScreen> {
  late final i18n i;
  late final Basics bpr;

  String initialSearchText = '';
  bool _isSearchActive = false;
  bool _isSecondaryActive = false;
  late final List<String> _maSecBasicName;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context);

      _maSecBasicName = i.maSecBasicName;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool isContainsSearchText(dynamic e) {
    final name =
        _isSecondaryActive ? e[_maSecBasicName[1]] : e[_maSecBasicName[0]];
    return name.toLowerCase().contains(initialSearchText.toLowerCase());
  }

  List<dynamic> getPrioritizedElements(List<dynamic> elements) {
    /// IF you want to sort according to _isSecondaryActive
    // final int i = _isSecondaryActive ? 1 : 0;
    // a[_maSecBasicName[i]].compareTo(b[_maSecBasicName[i]])
    return [
      ...List.of(elements)
        ..sort(
            (a, b) => a[_maSecBasicName[0]].compareTo(b[_maSecBasicName[0]])),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('*************** dialect_list_screen build ***************');
    final List<dynamic> allElement = getPrioritizedElements(bpr.dialects);
    final elements = allElement.where(isContainsSearchText).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isSearchActive
            ? 106.0
            : 56), // default appBar height: 56, and SearchWidget container height: 40, plus 10 to padding
        child: _buildAppBar(context),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
            .onDrag, // to hide (to pop off in the navigator) soft input keyboard with tap on screen
        itemCount: elements.length,
        itemBuilder: (context, index) => BasicsRUDListTile(
          // leading: null, default
          title: _buildTitle(elements[index]),
          subtitle: _buildSubtitle(elements[index]),
          // trailing: null, default
          onViewHandler: () {
            final Map<String, dynamic> args = {
              'editedId': elements[index]['id'],
              'isViewOnly': true
            };
            Utils.showNewScreen(context, args, NewDialectScreen.routeName,
                NewDialectScreen(args: args));
          },
          onEditHandler: () {
            final Map<String, dynamic> args = {
              'editedId': elements[index]['id'],
              'isViewOnly': false
            };
            Utils.showNewScreen(context, args, NewDialectScreen.routeName,
                NewDialectScreen(args: args));
          },
          deletePayload: {
            "message": i.tr('m25'),
            "name": 'dialect',
            "id": elements[index]['id'].toString(),
          },
        ),
        separatorBuilder: (context, index) => const Divider(
          thickness: 1.0,
          height: 0.0,
        ),
      ),
    );
  }

  BasicsListAppBar _buildAppBar(BuildContext context) {
    final bool isSmallSizeScreen = Responsive.w(context) < 1200;
    return BasicsListAppBar(
      onAddHandler: () {
        if (isSmallSizeScreen) {
          Navigator.pushNamed(context, NewDialectScreen.routeName);
        } else {
          showDialog(
              // barrierColor: kPrimaryLightColor.withOpacity(0.2),
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  elevation: 1,
                  shape: kBuildTopRoundedRectangleBorder,
                  child: FractionallySizedBox(
                      heightFactor: 0.9,
                      widthFactor: Responsive.isDesktop(context) ? 0.5 : 0.9,
                      child: const NewDialectScreen()),
                );
              });
        }
      },
      isSearchActive: _isSearchActive,
      onToggleSearchHandler: () =>
          setState(() => _isSearchActive = !_isSearchActive),
      searchBox: SearchWidget(
        searchWord: initialSearchText,
        onChangedSearchTextHandler: (text) =>
            setState(() => initialSearchText = text),
        hintText: i.tr('Search of') + i.tr('dialect'),
        autofocus: true,
      ),
      isSecondaryActive: _isSecondaryActive,
      onToggleSecondaryHandler: () =>
          setState(() => _isSecondaryActive = !_isSecondaryActive),
      title: i.tr('dialects list'),
    );
  }

  Text _buildTitle(Map<String, dynamic> e) {
    return Text(
      _isSecondaryActive ? e[_maSecBasicName[1]] : e[_maSecBasicName[0]],
    );
  }

  Widget? _buildSubtitle(Map<String, dynamic> e) {
    return Text(e['name']);
  }
}
