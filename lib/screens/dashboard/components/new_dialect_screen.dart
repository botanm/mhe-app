import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/basics.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/services/http_exception.dart';

import '../../../../widgets/submit_button.dart';
import '../../../../widgets/textformfield_widget.dart';
import '../../../providers/core.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/icon_widget.dart';
import '../../../widgets/increase_decrease_spinner.dart';
import '../../../widgets/switch_widget.dart';
import 'basics_rud_appbar.dart';

class NewDialectScreen extends StatefulWidget {
  static const routeName = '/newdialect';
  const NewDialectScreen({this.args, super.key});
  final Map<String, dynamic>? args;

  @override
  _NewDialectScreenState createState() => _NewDialectScreenState();
}

class _NewDialectScreenState extends State<NewDialectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "name": "",
    "ckb_name": "",
    "kmr_name": "",
    "bad_name": "",
    "ar_name": "",
    "language_code": "",
    "about": "",
    "ckb_about": "",
    "kmr_about": "",
    "bad_about": "",
    "ar_about": "",
    "is_rtl": true,
    "is_active": true,
    "order": 0,
  };
  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedElement;
  bool isViewOnly = false;
  late String title;

  late final i18n i;
  late final Basics bpr;
  late final Core cpr;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(
        context,
      );
      cpr = Provider.of<Core>(context, listen: false);

      title = i.tr('m52') + i.tr('dialect');
      Map<String, dynamic>? args = widget.args;
      args ??=
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _editedElement = bpr.findBasicById('dialect', args['editedId'] as int);
        isViewOnly = args['isViewOnly'];
        title = isViewOnly
            ? i.tr('m53') + i.tr('dialect')
            : args['editedId'] != null
                ? i.tr('Edit')
                : title;
        _isLoading = isViewOnly;

        _formData = {
          "id": _editedElement!['id'],
          "name": _editedElement['name'],
          "ckb_name": _editedElement['ckb_name'],
          "kmr_name": _editedElement['kmr_name'],
          "bad_name": _editedElement['bad_name'],
          "ar_name": _editedElement['ar_name'],
          "language_code": _editedElement['language_code'],
          "about": _editedElement['about'],
          "ckb_about": _editedElement['ckb_about'],
          "kmr_about": _editedElement['kmr_about'],
          "bad_about": _editedElement['bad_about'],
          "ar_about": _editedElement['ar_about'],
          "is_rtl": _editedElement['is_rtl'],
          "is_active": _editedElement['is_active'],
          "order": _editedElement['order'],
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     new_dialect_screen build     ++++++++++++++++++++++++');
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: _buildAppBar,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),

          /// read the documentation was written in "login_screen" file about First Note:, Second Note: and Third Note:

          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (ctx, constraints) => SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag, // to hide (pop off in the navigator) soft input keyboard with tap on screen
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: _buildFormElements,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize get _buildAppBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56), // default appBar height: 56,
      child: BasicsRUDAppBar(title: title),
    );
  }

  Column get _buildFormElements {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildOrder,
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        _buildName,
        _buildCkbName,
        _buildKmrName,
        _buildBadName,
        _buildArName,
        const SizedBox(height: 10),
        _buildLanguageCode,
        const SizedBox(height: 10),
        _buildAbout,
        const SizedBox(height: 10),
        _buildCkbAbout,
        const SizedBox(height: 10),
        _buildKmrAbout,
        const SizedBox(height: 10),
        _buildBadAbout,
        const SizedBox(height: 10),
        _buildArAbout,
        const SizedBox(height: 10),
        const SizedBox(height: 12),
        _buildIsRtlSwitch,
        const SizedBox(height: 32),
        _buildIsActiveSwitch,
        const SizedBox(height: 32),
        const Spacer(),
        if (!isViewOnly) _buildSubmitButton,
      ],
    );
  }

  TextFormFieldWidget get _buildName {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['name'],
      icon: Icons.flag_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Name'),
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
      onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildCkbName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ckb_name'],
      icon: Icons.flag_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m54'),

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

  TextFormFieldWidget get _buildKmrName {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['kmr_name'],
      icon: Icons.flag_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m37'),

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
      onSavedHandler: (value) => _formData['kmr_name'] = value,
    );
  }

  TextFormFieldWidget get _buildBadName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['bad_name'],
      icon: Icons.flag_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m55'),

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
      onSavedHandler: (value) => _formData['bad_name'] = value,
    );
  }

  TextFormFieldWidget get _buildArName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ar_name'],
      icon: Icons.flag_outlined, // icon: null is  default
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

  TextFormFieldWidget get _buildLanguageCode {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['language_code'],
      icon: Icons.qr_code, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m61'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        } else if (!['en', 'ar', 'ckb', 'bad', 'kmr', 'sdh', 'lki']
            .contains(value)) {
          return 'en, ar, ckb, bad, kmr, sdh, lki';
        }
        return null;
      },
      onSavedHandler: (value) => _formData['language_code'] = value,
    );
  }

  TextFormFieldWidget get _buildAbout {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('About'),
      enabled: !_isLoading,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['about'] = value,
    );
  }

  TextFormFieldWidget get _buildCkbAbout {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['ckb_about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m39'),
      enabled: !_isLoading,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['ckb_about'] = value,
    );
  }

  TextFormFieldWidget get _buildKmrAbout {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['kmr_about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m40'),
      enabled: !_isLoading,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['kmr_about'] = value,
    );
  }

  TextFormFieldWidget get _buildBadAbout {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['bad_about'],
      icon: Icons.description, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('m41'),
      enabled: !_isLoading,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['bad_about'] = value,
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
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      onSavedHandler: (value) => _formData['ar_about'] = value,
    );
  }

  IncreaseDecreaseSpinner get _buildOrder {
    return IncreaseDecreaseSpinner(
      title: i.tr('order'),
      initialValue: _formData['order'],
      onChangedHandler: (value) => _formData['order'] = value,
      isEnabled: !_isLoading,
    );
  }

  SwitchWidget get _buildIsRtlSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.turn_left,
        color: Colors.black26,
      ),
      title: 'is_rtl',
      initialValue: _formData['is_rtl'],
      onToggleHandler: (bool value) {
        _formData['is_rtl'] = value;
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

  SwitchWidget get _buildIsActiveSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.power_off_rounded,
        color: Colors.black26,
      ),
      title: i.tr('is_active'),
      initialValue: _formData['is_active'],
      onToggleHandler: (bool value) {
        _formData['is_active'] = value;
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

  SubmitButton get _buildSubmitButton {
    String text = i.tr(_formData['id'] == null ? 'Add' : 'Edit');
    String disabledText = i.tr(_formData['id'] == null ? 'Adding' : 'Editing');
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await bpr.newBasic('dialect', _formData);
      Navigator.pop(context);
      // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException catch (error) {
      var errorMessage = i.tr(_formData['id'] == null ? 'm57' : 'm58');
      String e = error.toString();
      // if (e.cont_formData
      //   errorMessage = 'Username already exists';
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
      var errorMessage = i.tr(_formData['id'] == null ? 'm60' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
