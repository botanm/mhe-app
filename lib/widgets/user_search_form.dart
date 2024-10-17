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
import 'toggle_buttons_widget.dart';

class UserSearchForm extends StatefulWidget {
  const UserSearchForm({
    super.key,
  });

  @override
  _UserSearchFormState createState() => _UserSearchFormState();
}

class _UserSearchFormState extends State<UserSearchForm> {
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
  late final List<dynamic> _roles;
  late final List<dynamic> _privileges;
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

      _roles = bpr.roles;
      _privileges = bpr.privileges;
      _organizations = bpr.cities;
      _generals = bpr.categories;

      _maSecBasicName = i.maSecBasicName;
      _isAuthAndSuperuser = apr.isSuperuser;
      _isAuthAndStaff = apr.isStaff;

      if (cpr.userSearchData != null) {
        _searchData = Map.from(cpr.userSearchData!);
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
        '++++++++++++++++++++++++     UserSearchForm build     ++++++++++++++++++++++++');
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
      elements = _buildGeneralElements;
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
      _12,
      _buildGenerals,
      _12,
      _buildRoles,
      _12,
      _buildPrivileges,
      _32,
      Expanded(child: _buildMore),
      _buildSubmitButton,
    ];
  }

  List<Widget> get _buildGeneralElements {
    return [
      _32,
      _buildResetButton,
      _12,
      _buildSearch,
      _12,
      _buildOrganization,
      const Spacer(),
      _buildSubmitButton,
    ];
  }

  ExpansionTile get _buildMore {
    return ExpansionTile(
      // tilePadding: EdgeInsets.only(
      //     right: isRtl ? leftPadding : 0, left: !isRtl ? leftPadding : 0),
      // trailing: const SizedBox
      //     .shrink(), // remove trailing icons; to replace it with another icon in next line
      // leading: const Icon(Icons
      //     .add_outlined), // const Icon(Icons.keyboard_arrow_right_outlined),
      collapsedIconColor: kPrimaryColor,
      collapsedTextColor: kPrimaryColor,
      textColor: kPrimaryColor,
      title: Text(i.tr(isExpanded ? "Cancel" : "More")),
      subtitle: isExpanded ? Text(i.tr("m81")) : null,
      onExpansionChanged: (bool expanding) =>
          setState(() => isExpanded = expanding),
      childrenPadding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Column(
          children: [
            _buildSuperStaffActive,
            _32,
            _buildShowPhoneSwitch,
          ],
        )
      ],
    );
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

  ToggleButtonsWidget get _buildSuperStaffActive {
    List<String> options = ['is_superuser', 'is_staff', 'is_active'];
    List<String> trdTexts = [
      i.tr('is_superuser'),
      i.tr('is_staff'),
      i.tr('is_active')
    ];
    List<bool> initialSelected =
        options.map((e) => _searchData[e] as bool).toList();
    return ToggleButtonsWidget(
      texts: trdTexts,
      initialSelected: initialSelected,
      selectedHandler: (index) {
        final selectedIndex = options[index];
        _searchData[selectedIndex] = !_searchData[selectedIndex];
      },
      isEnabled: !_isLoading,
      // selectedColor: const Color(0xFF6200EE), // default
      // borderRadius: 24.0, // default
      // stateContained: true, // default
      // multipleSelectionsAllowed: true, // default
      // canUnToggle: false, // default AND it is work if "multipleSelectionsAllowed: false"
    );
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
        setState(() {
          _searchData['general_specialization_id'] = value;
        });
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

  MenuPicker get _buildRoles {
    return MenuPicker(
      allElements: _roles,
      maSecName: _maSecBasicName,
      initialSelected: _searchData[
          'roles'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        setState(() {
          _searchData['roles'] = value;
        });
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('Roles'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: false,
      isSecondaryVisible: false,
      isEnabled: !_isLoading,
      isValidated: true,
    );
  }

  MenuPicker get _buildPrivileges {
    return MenuPicker(
      allElements: _privileges,
      maSecName: _maSecBasicName,
      initialSelected: _searchData[
          'privileges'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        setState(() {
          _searchData['privileges'] = value;
        });
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('Privileges'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: false,
      isSecondaryVisible: false,
      isEnabled: !_isLoading,
      isValidated: true,
    );
  }

  SwitchWidget get _buildShowPhoneSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.visibility,
        color: Colors.black26,
      ),
      title: i.tr('Show phone'),
      initialValue: _searchData['is_show_phone'],
      onToggleHandler: (bool value) {
        _searchData['is_show_phone'] = value;
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

            if (cpr.userSearchData != null) {
              cpr.onRefreshUsers();
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
      "is_superuser": false,
      "is_staff": false,
      "is_active": false,
      "is_show_phone": true,
      "roles": [],
      "privileges": [],
      "general_specialization_id": [],
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
    String p2 = _searchData['organization_id'] == null
        ? ""
        : "&organization_id=${_searchData['organization_id']}";

    String p3 = List<int>.from(_searchData['general_specialization_id']).isEmpty
        ? ""
        : "&generals__in=${_searchData['general_specialization_id']}";

    String p4 = List<int>.from(_searchData['roles']).isEmpty
        ? ""
        : "&roles__in=${_searchData['roles']}";
    String p5 = List<int>.from(_searchData['privileges']).isEmpty
        ? ""
        : "&privileges__in=${_searchData['privileges']}";

    String p6 = !(_isAuthAndSuperuser || _isAuthAndStaff) || !isExpanded
        ? ""
        : "&is_show_phone=${_searchData['is_show_phone']}&is_superuser=${_searchData['is_superuser']}&is_staff=${_searchData['is_staff']}&is_active=${_searchData['is_active']}";
    try {
      String payload = "?$p1$p2$p3$p4$p5$p6";
      if (payload != "?") {
        await cpr.filterUsers(payload);
        cpr.userSearchData = _searchData;
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
