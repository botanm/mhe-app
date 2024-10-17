import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../providers/auth.dart';
import '../../../../../providers/basics.dart';
import '../../../../../providers/core.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../utils/services/http_exception.dart';
import '../../../../../utils/utils.dart';

import '../../../../../widgets/icon_widget.dart';
import '../../../../../widgets/menu_picker.dart';
import '../../../../../widgets/tag_input.dart';
import '../../../../../widgets/responsive.dart';
import '../../../../../widgets/submit_button.dart';
import '../../../../../widgets/switch_widget.dart';
import '../../../../../widgets/textformfield_widget.dart';
import '../../../../../widgets/toggle_buttons_widget.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm(
      {super.key,
      required this.isAuth,
      required this.isStaff,
      this.editedUser,
      required this.isChangePassword,
      required this.isViewOnly});
  final bool isAuth;
  final bool isStaff;
  final Map<String, dynamic>? editedUser;
  final bool isChangePassword;
  final bool isViewOnly;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);
  // ignore: prefer_final_fields
  Map<String, dynamic> _userData = {
    "id": null,
    "username": "",
    "password": "",
    "first_name": "",
    "last_name": "",
    "email": "",
    "is_superuser": false,
    "is_staff": false,
    "is_active": true,
    "phone": [''],
    "note": "",
    "dialects": [],
    "city": null,
    "roles": [],
    "privileges": [],
    "trashed_at": null,
    "trashed_by": null,
  };
  final double coverHeight = 280;
  final double avatarRadius = 64;

  bool _isInit = true;
  bool _isLoading = false;

  late bool _isAuth;
  late bool _isStaff;
  late final Map<String, dynamic>? _editedUser;

  bool _isChangePassword = false;
  bool _isViewOnly = false;
  String? _verifyPassword;

  late final i18n i;
  late final Auth apr;
  late final Basics bpr;
  late final Core cpr;

  late final List<dynamic> _dialects;
  late final List<dynamic> _cities;
  late final List<dynamic> _roles;
  late final List<dynamic> _privileges;

  late final List<String> _maSecBasicName;
  bool _isMe = false;
  bool _isEdit = false;
  bool _isResetPassword = false;

  List<bool> _isVal = [
    true,
    true,
    true,
    true
  ]; //_cities,_roles,_privileges,_dialects

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);

      _roles = bpr.roles;
      _privileges = bpr.privileges;
      _dialects = bpr.dialects;
      _cities = bpr.cities;

      _maSecBasicName = i.maSecBasicName;

      _isAuth = widget.isAuth;
      _isStaff = widget.isStaff;
      _editedUser = widget.editedUser;
      _isChangePassword = widget.isChangePassword;
      _isViewOnly = widget.isViewOnly;

      if (_editedUser != null) {
        _isLoading = _isViewOnly;
        List<dynamic>? phone = _editedUser['phone'];
        _userData = {
          "id": _editedUser['id'],
          "username": _editedUser['username'],
          "first_name": _editedUser['first_name'],
          "last_name": _editedUser['last_name'],
          "email": _editedUser['email'],
          "is_superuser": _editedUser['is_superuser'],
          "is_staff": _editedUser['is_staff'],
          "is_active": _editedUser['is_active'],
          "phone": phone == null || phone.isEmpty
              ? ['']
              : List<String>.from(_editedUser['phone']),
          "is_show_phone": _editedUser['is_show_phone'],
          "note": _editedUser['note'],
          "dialects": _editedUser['dialects'],
          "city": _editedUser['city'],
          "roles": _editedUser['roles'],
          "privileges": _editedUser['privileges'],
          "trashed_at": _editedUser['trashed_at'],
          "trashed_by": _editedUser['trashed_by'],
        };
        final Map<String, dynamic>? me = apr.me;
        _isMe = _userData['id'] == me!['id'];
        _isResetPassword = _isChangePassword && _isStaff && !_isMe;
        _isEdit = true;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     register_form build     ++++++++++++++++++++++++');
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Form(
        key: _formKey,
        child: _buildFormElements(),
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
    if (_isEdit && _isAuth && _isMe && !_isChangePassword) {
      elements = _buildSelfEditElements;
    } else if (_isEdit && _isAuth && _isStaff && !_isMe && !_isChangePassword) {
      elements = _buildStaffEditElements;
    } else if (_isChangePassword) {
      elements = _buildChangePasswordElements;
    } else {
      elements = _buildCreatelements;
    }

    return Column(
      children: elements,
    );
  }

  List<Widget> get _buildSelfEditElements {
    return [
      _buildCkbName,
      _buildkmrName,
      _buildEmail,
      _12,
      _buildRoles,
      _12,
      _buildPrivileges,
      _12,
      _buildDialect,
      _12,
      _buildCity,
      _buildPhone,
      _32,
      _buildSubmitButton,
      if (Responsive.isMobile(context)) _12,
    ];
  }

  List<Widget> get _buildStaffEditElements {
    return [
      _buildSuperStaffActive,
      _32,
      _buildDialect,
      _12,
      _buildCity,
      _12,
      _buildRoles,
      _12,
      _buildPrivileges,
      _32,
      _buildNote,
      _12,
      _buildTrashedAtSwitch,
      _32,
      if (!_isViewOnly) _buildSubmitButton,
      if (Responsive.isMobile(context)) _12,
    ];
  }

  List<Widget> get _buildChangePasswordElements {
    return [
      _32,
      if (!_isResetPassword) _buildVerifyPassword,
      _buildPassword,
      _buildConfirmPassword,
      _32,
      _buildSubmitButton,
      if (Responsive.isMobile(context)) _12,
    ];
  }

  List<Widget> get _buildCreatelements {
    return [
      _32,
      _buildUsername,
      _buildPassword,
      _buildConfirmPassword,
      _buildCkbName,
      _buildkmrName,
      _buildEmail,
      _12,
      _buildDialect,
      _12,
      _buildCity,
      _12,
      _buildRoles,
      _12,
      _buildPrivileges,
      _32,
      _buildNote,
      _32,
      _buildPhone,
      _32,
      if (!_isViewOnly) _buildSubmitButton,
      if (Responsive.isMobile(context)) _12,
    ];
  }

  TextFormFieldWidget get _buildUsername {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _userData['username'],
      icon: Icons.person, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('Username'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _userData['username'] = value,
    );
  }

  TextFormFieldWidget get _buildVerifyPassword {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _verifyPassword,
      icon: Icons.key, // icon: null is default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('m31'),
      enabled: !_isLoading,
      // maxLines: 1, // default
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        /// read comments in email validation
        String passwordPattern =
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
        bool isPass = RegExp(passwordPattern).hasMatch(value);
        if (value.isEmpty || !isPass) {
          return i.tr('m32');
        }
        return null;
      },
      onSavedHandler: (value) => _verifyPassword = value,
      is_password: true,
    );
  }

  TextFormFieldWidget get _buildPassword {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _userData['password'],
      icon: Icons.lock, // icon: null is default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr(_isChangePassword ? 'New password' : 'Password'),
      enabled: !_isLoading,
      // maxLines: 1, // default
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        /// read comments in email validation
        String passwordPattern =
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
        bool isPass = RegExp(passwordPattern).hasMatch(value);
        if (value.isEmpty || !isPass) {
          return i.tr('m32');
        }
        return null;
      },
      onChangedHandler: (value) => _userData['password'] =
          value, // we have assigned "onChanged" so that Confirm Password work
      is_password: true,
    );
  }

  TextFormFieldWidget get _buildConfirmPassword {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: '',
      icon: Icons.lock, // icon: null is default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr(_isChangePassword ? 'm33' : 'm34'),
      enabled: !_isLoading,
      // maxLines: 1, // default
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (value != _userData['password']) {
          return i.tr('m35');
        }
        return null;
      },
      is_password: true,
    );
  }

  TextFormFieldWidget get _buildCkbName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _userData['first_name'],
      icon: Icons.person_pin, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m79'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _userData['first_name'] = value,
    );
  }

  TextFormFieldWidget get _buildkmrName {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _userData['last_name'],
      icon: Icons.person_pin, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m80'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _userData['last_name'] = value,
    );
  }

  TextFormFieldWidget get _buildEmail {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _userData['email'],
      icon: Icons.email, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Email'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        /// https://www.youtube.com/playlist?list=PL55RiY5tL51ryV3MhCbH8bLl7O_RZGUUE
        /// https://www.codegrepper.com/code-examples/javascript/password+regex
        // var _urlPattern =
        //     r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
        // var _result = RegExp(_urlPattern, caseSensitive: false).firstMatch(value);
        // bool _isUrl = RegExp(_urlPattern, caseSensitive: false).hasMatch(value);
        String emailPattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        bool isEmail = RegExp(emailPattern).hasMatch(value);
        // if (value.isEmpty || !value.contains('@')) {
        if (value.isEmpty || !isEmail) {
          return i.tr('m38');
        }
        return null;
      },
      onSavedHandler: (value) => _userData['email'] = value,
    );
  }

  TextFormFieldWidget get _buildNote {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _userData['note'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Notes'),
      enabled: !_isLoading,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        // if (value.isEmpty) {
        //   return i.tr('m8');
        // }
        return null;
      },
      onSavedHandler: (value) => _userData['note'] = value,
    );
  }

  ToggleButtonsWidget get _buildSuperStaffActive {
    List<String> options = ['is_superuser', 'is_staff', 'is_active'];
    List<String> trdTexts = [
      i.tr('is_superuser'),
      i.tr('is_staff'),
      i.tr('is_active')
    ];
    List<bool> initialSelected =
        options.map((e) => _userData[e] as bool).toList();
    return ToggleButtonsWidget(
      texts: trdTexts,
      initialSelected: initialSelected,
      selectedHandler: (index) {
        final selectedIndex = options[index];
        _userData[selectedIndex] = !_userData[selectedIndex];
      },
      isEnabled: !_isLoading,
      // selectedColor: const Color(0xFF6200EE), // default
      // borderRadius: 24.0, // default
      // stateContained: true, // default
      // multipleSelectionsAllowed: true, // default
      // canUnToggle: false, // default AND it is work if "multipleSelectionsAllowed: false"
    );
  }

  MenuPicker get _buildDialect {
    return MenuPicker(
      allElements: _dialects,
      maSecName: _maSecBasicName,
      initialSelected: _userData[
          'dialects'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _userData['dialects'] = value;
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('dialect'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isValidated: _isVal[3],
    );
  }

  MenuPicker get _buildCity {
    return MenuPicker(
      allElements: _cities,
      maSecName: _maSecBasicName,
      initialSelected: _userData['city'] == null ? [] : [_userData['city']],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _userData['city'] = value;
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('city'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isTree: true,
      isValidated: _isVal[0],
    );
  }

  MenuPicker get _buildRoles {
    List<dynamic> roleIds = _userData['roles'];
    if (_isEdit) {
      final List<Map<String, dynamic>?> onlyPublicRoles = roleIds
          .map((id) {
            final Map<String, dynamic> role = bpr.findBasicById('role', id);
            if (role.isNotEmpty) {
              return role;
            }
            return null;
          })
          .where((role) => role != null)
          .toList();
      // Extract only the 'id' from each role and assign to roleIds
      roleIds = onlyPublicRoles.map((role) => role!['id']).toList();
    }

    return MenuPicker(
      allElements: _roles,
      maSecName: _maSecBasicName,
      initialSelected: roleIds,
      // _userData['roles'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _userData['roles'] = value;
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
      isValidated: _isVal[1],
    );
  }

  MenuPicker get _buildPrivileges {
    return MenuPicker(
      allElements: _privileges,
      maSecName: _maSecBasicName,
      initialSelected: _userData[
          'privileges'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _userData['privileges'] = value;
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
      isValidated: _isVal[2],
    );
  }

  TagInput get _buildPhone {
    final List<String> tagsPointer = _userData['phone'];
    return TagInput(
      tagsPointer: tagsPointer,
      tagText: i.tr('Phone'),
      icon: Icons.call_outlined,
      isEnabled: !_isLoading,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (value.length < 11 || value.length > 15) {
          return 'Ex: 009647504445566';
        }
        return null;

        /// read comments in email validation
        /// https://www.youtube.com/watch?v=cPQnm1-IuUk
        // String _phonePattern =
        //     r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
        // bool _isPhone = RegExp(_phonePattern).hasMatch(value);
        // else if (!_isPhone)
      },
    );
  }

  SwitchWidget get _buildTrashedAtSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.delete,
        color: Colors.black26,
      ),
      title: i.tr('Soft Delete'),
      initialValue: _userData['trashed_at'] == null ? false : true,
      onToggleHandler: (bool value) {
        _userData['trashed_at'] = value
            ? DateTime.now()
            : "2010-01-01T01:01:46.110265Z"; // in the backend ==> if PT is not None and NT.year == 2010:
      },
      enabled: !_isLoading,
    );
  }

  SubmitButton get _buildSubmitButton {
    bool isEdit = _userData['id'] != null;
    String text = i.tr(!isEdit ? 'Register' : 'Edit');
    String disabledText = !isEdit ? 'Registering' : 'Editing';
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  Future<void> _onSubmit() async {
    _isVal = [
      _userData['city'] != null,
      _userData['roles'].isNotEmpty,
      _userData['privileges'].isNotEmpty,
      _userData['dialects'].isNotEmpty,
    ];

    if (!_formKey.currentState!.validate() || _isVal.contains(false)) {
      // Invalid!
      if (_isVal.contains(false)) {
        setState(() => _isVal);
      }
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isChangePassword && !_isResetPassword) {
        await Provider.of<Auth>(context, listen: false).login({
          'username': cpr.loggedInUsername,
          'password': _verifyPassword,
        });
      }

      late String? PT;
      late String? NT;
      if (_isEdit) {
        PT = cpr.findUserById(_userData['id'])['trashed_at'];
      }
      if (!_isEdit || PT == _userData['trashed_at']) {
        _userData.remove('trashed_at');
      }
      await cpr.register(_userData, _isChangePassword);

      if (_isEdit) {
        NT = cpr.findUserById(_userData['id'])['trashed_at'];
      }

      if (_isEdit && (_userData['id'] == int.parse(apr.userId!))) {
        await apr.fetchAndSetMe();
      }
      // if (_isEdit && PT == null && NT != null) {
      //   // the user has been soft deleted
      //   cpr.removeTrashedUserInCenterReps(_userData['id']);
      //   // bpr.removeTrashedUserInOrganizations(_userData['id']);
      // } else if (_isEdit && PT != null && NT == null) {
      //   // the user has been soft restored
      //   cpr.addRestoredUserToCenterReps(_userData['id']);
      // }
      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "AccountListScreen"
      if (_isChangePassword && !_isResetPassword) {
        await apr.logout();
        Navigator.pushNamed(context, '/login');
      }
    } on HttpException catch (error) {
      var errorMessage = i.tr(_userData['id'] == null ? 'm59' : 'm58');
      String e = error.toString();
      if (e.contains('username already exists')) {
        errorMessage = i.tr('m45');
      }
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
      var errorMessage = i.tr(_userData['id'] == null ? 'm46' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
