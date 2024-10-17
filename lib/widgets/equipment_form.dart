import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../providers/auth.dart';
import '../../../../../providers/basics.dart';
import '../providers/core.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../utils/services/http_exception.dart';
import '../../../../../utils/utils.dart';

import 'icon_widget.dart';
import 'increase_decrease_spinner.dart';
import 'menu_picker.dart';
import 'number_menu_picker.dart';
import 'switch_widget.dart';
import 'tag_input.dart';
import '../../../../../widgets/responsive.dart';
import '../../../../../widgets/submit_button.dart';
import '../../../../../widgets/textformfield_widget.dart';
import 'top_image_section.dart';

class EquipmentForm extends StatefulWidget {
  const EquipmentForm({
    super.key,
    this.editedEquipment,
  });

  final Map<String, dynamic>? editedEquipment;

  @override
  _EquipmentFormState createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);
  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "organization_id": null,
    "general_specialization_id": [],
    "name": "",
    "ckb_name": "",
    "ar_name": "",
    "about": "",
    "ckb_about": "",
    "ar_about": "",
    "detail_link": "",
    "manufacturer": "",
    "model": "",
    "year": null,
    "quantity": 1,
    "tags": [''],
    "note": "",
    "image0": null,
    "image1": null,
    "image2": null,
    "is_available": true
  };

  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedEquipment;

  late final i18n i;
  late final Auth apr;
  late final Basics bpr;
  late final Core cpr;

  late final List<dynamic> _organizations;
  late final List<dynamic> _generals;

  late final List<String> _maSecBasicName;

  List<bool> _isVal = [
    true,
    true,
    true,
    true,
    true,
    true
  ]; //image0,image1,image2, _organizations,_generals,year

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);

      _generals = bpr.categories;
      _organizations = apr.me!['rep_organizations'];

      _maSecBasicName = i.maSecBasicName;

      _editedEquipment = widget.editedEquipment;

      if (_editedEquipment != null) {
        List<dynamic>? tags = _editedEquipment['tags'];

        _formData = {
          "id": _editedEquipment['id'],
          "organization_id": _editedEquipment['organization_id'],
          "general_specialization_id":
              _editedEquipment['general_specialization_id'],
          "name": _editedEquipment['name'],
          "ckb_name": _editedEquipment['ckb_name'],
          "ar_name": _editedEquipment['ar_name'],
          "about": _editedEquipment['about'],
          "ckb_about": _editedEquipment['ckb_about'],
          "ar_about": _editedEquipment['ar_about'],
          "detail_link": _editedEquipment['detail_link'],
          "manufacturer": _editedEquipment['manufacturer'],
          "model": _editedEquipment['model'],
          "year": _editedEquipment['year'],
          "quantity": _editedEquipment['quantity'],
          "tags": tags == null || tags.isEmpty
              ? ['']
              : List<String>.from(_editedEquipment['tags']),
          "note": _editedEquipment['note'],
          "image0": _editedEquipment['image0'],
          "image1": _editedEquipment['image1'],
          "image2": _editedEquipment['image2'],
          "is_available": _editedEquipment['is_available'],
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     equipment_form build     ++++++++++++++++++++++++');
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
    return Column(
      children: _buildStaffCUElements,
    );
  }

  List<Widget> get _buildStaffCUElements {
    return [
      _12,
      _buildTop,
      _32,
      _buildParent,
      _12,
      _buildGenerals,
      _32,
      _buildName,
      _buildCkbName,
      _buildArName,
      _buildManufacturer,
      _buildModel,
      _32,
      _buildYear,
      _24,
      _buildQuantity,
      _12,
      _buildIsAvailableSwitch,
      _24,
      _buildAbout,
      _12,
      _buildCkbAbout,
      _12,
      _buildArAbout,
      _12,
      _buildNote,
      _32,
      _buildDetailLink,
      _12,
      _buildTags,
      _12,
      _buildSubmitButton,
      if (Responsive.isMobile(context)) _12,
    ];
  }

  Widget get _buildTop {
    Map<String, dynamic> imageData = {
      "image0": _formData["image0"],
      "image1": _formData["image1"],
      "image2": _formData["image2"],
      "isVal0": _isVal[0],
      "isVal1": _isVal[1],
      "isVal2": _isVal[2],
    };
    return TopImageSection(
      formData: imageData,
      onTapHandler: (data) {
        _formData[data['imageKey']] = data['image'];
      },
    );
  }

  TextFormFieldWidget get _buildName {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['name'],
      icon: Icons.abc_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('m80'),
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
      onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildCkbName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ckb_name'],
      icon: Icons.abc_outlined, // icon: null is  default
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
      onSavedHandler: (value) => _formData['ckb_name'] = value,
    );
  }

  TextFormFieldWidget get _buildArName {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['ar_name'],
      icon: Icons.abc, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m56'),
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
      onSavedHandler: (value) => _formData['ar_name'] = value,
    );
  }

  TextFormFieldWidget get _buildManufacturer {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['manufacturer'],
      icon: Icons.precision_manufacturing_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('Manufacturer'),
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
      onSavedHandler: (value) => _formData['manufacturer'] = value,
    );
  }

  TextFormFieldWidget get _buildModel {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['model'],
      icon: Icons.merge_type_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('Model'),
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
      onSavedHandler: (value) => _formData['model'] = value,
    );
  }

  Widget get _buildYear {
    int currentYear = DateTime.now().year;
    return NumberMenuPicker(
      firstNo: 2000, // 2004
      lastNo: currentYear + 1, // 2023
      descending: true,
      initialSelected: _formData['year'] == null
          ? []
          : [
              _formData['year']
            ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      text: i.tr("Select Year"),
      onSelectedHandler: (value) => _formData['year'] = value,
      isEnabled: !_isLoading,
      isValidated: _isVal[5],
    );
  }

  IncreaseDecreaseSpinner get _buildQuantity {
    return IncreaseDecreaseSpinner(
      title: i.tr('Quantity'),
      initialValue: _formData['quantity'],
      onChangedHandler: (value) => _formData['quantity'] = value,
      isEnabled: !_isLoading,
    );
  }

  SwitchWidget get _buildIsAvailableSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.check_circle_outline,
        color: kPrimaryMediumColor,
      ),
      title: i.tr('Available'),
      initialValue: _formData['is_available'],
      onToggleHandler: (bool value) {
        _formData['is_available'] = value;
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

  TextFormFieldWidget get _buildCkbAbout {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ckb_about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m39'),
      enabled: !_isLoading,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (value.length < 500) {
          return i.tr('m88');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['ckb_about'] = value,
    );
  }

  TextFormFieldWidget get _buildAbout {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m39A'),
      enabled: !_isLoading,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (value.length < 500) {
          return i.tr('m88');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['about'] = value,
    );
  }

  TextFormFieldWidget get _buildArAbout {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ar_about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m42'),
      enabled: !_isLoading,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (value.length < 500) {
          return i.tr('m88');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['ar_about'] = value,
    );
  }

  TextFormFieldWidget get _buildNote {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['note'],
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
      onSavedHandler: (value) => _formData['note'] = value,
    );
  }

  MenuPicker get _buildParent {
    return MenuPicker(
      allElements: _organizations,
      maSecName: _maSecBasicName,
      initialSelected: _formData['organization_id'] == null
          ? []
          : [_formData['organization_id']],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _formData['organization_id'] = value;
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
      isTree: false,
      isValidated: _isVal[3],
    );
  }

  MenuPicker get _buildGenerals {
    return MenuPicker(
      allElements: _generals,
      maSecName: _maSecBasicName,
      initialSelected: _formData[
          'general_specialization_id'], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _formData['general_specialization_id'] = value;
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
      isValidated: _isVal[4],
    );
  }

  TagInput get _buildTags {
    final List<String> tagsPointer = _formData['tags'];
    return TagInput(
      tagsPointer: tagsPointer,
      tagText: i.tr('Specific Specialization'),
      icon: Icons.tag,
      isEnabled: !_isLoading,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        // else if (value.length < 11 || value.length > 15) {
        //   return 'Ex: 009647504445566';
        // }
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

  TextFormFieldWidget get _buildDetailLink {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['detail_link'] ?? '',
      icon: Icons.link, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Detail link'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        /// https://www.youtube.com/playlist?list=PL55RiY5tL51ryV3MhCbH8bLl7O_RZGUUE
        /// https://www.codegrepper.com/code-examples/javascript/password+regex
        var urlPattern =
            r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
        // var _result = RegExp(_urlPattern, caseSensitive: false).firstMatch(value);
        bool isUrl = RegExp(urlPattern, caseSensitive: false).hasMatch(value);
        // String _emailPattern =
        //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        // bool _isEmail = RegExp(_emailPattern).hasMatch(value);
        // OR USE if (value.isEmpty || !value.contains('@')) {
        if (!value.isEmpty && !isUrl) {
          return i.tr('m44');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['detail_link'] = value,
    );
  }

  SubmitButton get _buildSubmitButton {
    bool isEdit = _formData['id'] != null;
    String text = i.tr(!isEdit ? 'Add' : 'Edit');
    String disabledText = !isEdit ? 'Adding' : 'Editing';
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  Future<void> _onSubmit() async {
    _isVal = [
      _formData['image0'] != null,
      _formData['image1'] != null,
      _formData['image2'] != null,
      _formData['organization_id'] != null,
      _formData['general_specialization_id'].isNotEmpty,
      _formData['year'] != null,
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
      // await cpr.newEquipment(_formData);

      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException catch (error) {
      var errorMessage = i.tr(_formData['id'] == null ? 'm59' : 'm58');
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
      var errorMessage = i.tr(_formData['id'] == null ? 'm46' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
