import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/auth.dart';
import '../providers/basics.dart';
import '../providers/core.dart';
import '../providers/i18n.dart';
import '../utils/services/http_exception.dart';
import '../utils/utils.dart';
import 'icon_widget.dart';
import 'menu_picker.dart';
import 'submit_button.dart';
import 'switch_widget.dart';

class EquipmentSearchForm extends StatefulWidget {
  const EquipmentSearchForm({
    super.key,
  });

  @override
  _EquipmentSearchFormState createState() => _EquipmentSearchFormState();
}

class _EquipmentSearchFormState extends State<EquipmentSearchForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _mySearchFieldController = TextEditingController();

  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);

  late Map<String, dynamic> _searchData;

  bool _isInit = true;
  bool _isLoading = false;

  late final i18n i;
  late final Auth apr;
  late final Basics bpr;
  late final Core cpr;

  late final List<dynamic> _organizations;

  late final List<dynamic> _generals;

  late final List<String> _maSecBasicName;
  bool isExpanded = false;
  late bool _isAuthAndSuperuser;
  late bool _isAuthAndStaff;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);

      _organizations = bpr.cities;
      _generals = bpr.categories;

      _maSecBasicName = i.maSecBasicName;
      _isAuthAndSuperuser = apr.isSuperuser;
      _isAuthAndStaff = apr.isStaff;

      if (cpr.questionSearchData != null) {
        _searchData = Map.from(cpr.questionSearchData!);
      } else {
        initializeSearchData;
      }

      _mySearchFieldController.text = _searchData['search'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _mySearchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     EquipmentSearchForm build     ++++++++++++++++++++++++');
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (ctx, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                .onDrag, // to hide (pop off in the navigator) soft input keyboard with tap on screen
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: _buildFormElements(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // AppBar get _buildAppBar {
  //   return AppBar(
  //     // leading: IconButton(
  //     //   icon: const Icon(Icons.close, color: Colors.black),
  //     //   onPressed: () => Navigator.of(context).pop(),
  //     // ),
  //     iconTheme: const IconThemeData(
  //       color: Colors.black, //change leading icon color
  //     ),
  //     title: Text(i.tr(bpr.userId == _editedUser!['id'] ? 'm29' : 'm30'),
  //         style: const TextStyle(color: Colors.black)),
  //     elevation: 0,
  //     backgroundColor: const Color(0xffF3F2F8),
  //   );
  // }

  Column _buildFormElements() {
    List<Widget> elements;
    if (_isAuthAndSuperuser || _isAuthAndStaff) {
      elements = _buildSuperuserAndStaffElements;
    } else {
      elements = _buildSuperuserAndStaffElements;
    }
    return Column(
      children: elements,
    );
  }

  List<Widget> get _buildSuperuserAndStaffElements {
    return [
      _32,
      _buildResetButton,
      _12,
      _buildSearch,
      _12,
      _buildOrganization,
      if (_searchData['organization_id'] != null) _12,
      if (_searchData['organization_id'] != null)
        _buildOnlySelectedOrganizationsSwitch,
      _12,
      _buildGenerals,
      _32,
      const Spacer(),
      _buildSubmitButton,
    ];
  }

  Widget get _buildSearch {
    return Theme(
      data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              // filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              suffixIconColor: kPrimaryMediumColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: kPrimaryMediumColor),
              ))),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: i.tr("Search of"),
          suffixIcon: InkWell(
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset("assets/icons/Search.svg"),
            ),
          ),
        ),
        enabled: !_isLoading,
        controller: _mySearchFieldController,
        // initialValue: _searchData['search'], you can not use it with "controller: " AND The initialValue property is only used when the TextFormField is first created, and it is not updated when you call setState(). it didn't reset the value with Reset Button
        validator: (value) {
          if (value!.isEmpty) {
            return i.tr('m8');
          }
          return null;
        },
        onSaved: (value) => _searchData['search'] = value,
      ),
    );
    // return TextFormFieldWidget(
    //   isTextRtl: false,
    //   initialValue: _userData['username'],
    //   icon: Icons.person, // icon: null is  default
    //   // suffixIcon: null, // default is null AND for password is configured bu default
    //   label: i.tr('Username'),
    //   enabled: !_isLoading,
    //   // maxLines: 1,
    //   keyboardType: TextInputType.text,
    //   textInputAction: TextInputAction.next,
    //   validatorHandler: (value) {
    //     if (value.isEmpty) {
    //       return i.tr('m8');
    //     }
    //     return null;
    //   },
    //   onSavedHandler: (value) => _userData['username'] = value,
    // );
  }

  SwitchWidget get _buildOnlySelectedOrganizationsSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.checklist_rounded,
        color: Colors.black26,
      ),
      title: i.tr('m82'),
      initialValue: _searchData['onlySelectedOrganization'],
      onToggleHandler: (bool value) {
        _searchData['onlySelectedOrganization'] = value;
      },
      enabled: !_isLoading,
    );
    // filteredFeatures.map(
    //   (e) => CheckboxListTile(
    //     title: Text(e['name']),
    //     // value: pickedFeatures.contains(e['id']) ? true : false,
    //     value: pickedFeatures == e['id'] ? true : false,
    //     onChanged: (val) {
    //       setState(() {
    //         pickedFeatures = e['id'];
    //         // pickedFeatures.contains(e['id'])
    //         //     ? pickedFeatures.remove(e['id'])
    //         //     : pickedFeatures.add(e['id']);
    //       });
    //     },
    //   ),
    // )
    // .toList(),
  }

  MenuPicker get _buildOrganization {
    return MenuPicker(
      allElements: _organizations,
      maSecName: _maSecBasicName,
      initialSelected: _searchData['organization_id'] == null
          ? []
          : [_searchData['organization_id']],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        setState(() {
          _searchData['organization_id'] = value;
        });
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('organization'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isTree: true,
      isValidated: true,
    );
  }

  MenuPicker get _buildGenerals {
    return MenuPicker(
      allElements: _generals,
      maSecName: _maSecBasicName,
      initialSelected: _searchData[
          'general_specialization_id'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _searchData['general_specialization_id'] = value;
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('General Specialization'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isValidated: true,
    );
  }

  Widget get _buildResetButton {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              alignment: Alignment.center,
              side: WidgetStateProperty.all(
                  const BorderSide(width: 1, color: kPrimaryMediumColor)),
              // padding: MaterialStateProperty.all(const EdgeInsets.only(
              //     right: 75, left: 75, top: 12.5, bottom: 12.5)),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)))),
          onPressed: () {
            setState(() {
              initializeSearchData;
              _mySearchFieldController.text = "";
            });

            if (cpr.questionSearchData != null) {
              cpr.onRefreshQuestions();
            }
          },
          child: Text(
            i.tr("Reset Filter"),
            style: const TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void get initializeSearchData {
    _searchData = {
      "id": null,
      "search": "",
      "organization_id": null,
      "general_specialization_id": [],
      "year": null,
      "onlySelectedOrganization": false,
    };
  }

  SubmitButton get _buildSubmitButton {
    String text = i.tr('Search');
    String disabledText = 'Searching';
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  String get getP2 {
    if (_searchData['organization_id'] != null) {
      if (_searchData['onlySelectedOrganization']) {
        return "&organization_id=${_searchData['organization_id']}";
      }
      return "&organization_id__in=[${_searchData['organization_id']}]";
    }
    return "";
  }

  Future<void> _onSubmit() async {
    // if (!_formKey.currentState!.validate()) {
    //   // Invalid!
    //   return;
    // }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    String p1 = _searchData['search'].toString().isEmpty
        ? ""
        : "&search=${_searchData['search']}";
    String p2 = getP2;

    String p3 = List<int>.from(_searchData['general_specialization_id']).isEmpty
        ? ""
        : "&generals__in=${_searchData['general_specialization_id']}";

    try {
      String payload = "?$p1$p2$p3";
      if (payload != "?") {
        await cpr.filterQuestions(payload);
        cpr.questionSearchData = _searchData;
      }

      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException {
      var errorMessage = i.tr(_searchData['id'] == null ? 'm59' : 'm58');
      // String e = error.toString();
      // if (e.contains('username already exists')) {
      //   errorMessage = i.tr('m45');
      // }
      // if (e.contains('EMAIL_EXISTS')) {
      //   errorMessage = 'This email address is already in use.';
      // } else if (e.contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not a valid email address';
      // } else if (e.contains('WEAK_PASSWORD')) {
      //   errorMessage = 'This password is too weak.';
      // } else if (e.contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = 'Could not find a user with that email.';
      // } else if (e.contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid password.';
      // }
      Utils.showErrorDialog(context, errorMessage);
    } catch (error) {
      var errorMessage = i.tr(_searchData['id'] == null ? 'm46' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
