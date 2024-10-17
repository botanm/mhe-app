import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/basics.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/services/http_exception.dart';

import '../../../../widgets/submit_button.dart';
import '../../../../widgets/textformfield_widget.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/icon_widget.dart';
import '../../../widgets/increase_decrease_spinner.dart';
import '../../../widgets/switch_widget.dart';
import 'basics_rud_appbar.dart';

class NewRoleScreen extends StatefulWidget {
  static const routeName = '/newrole';
  const NewRoleScreen({this.args, super.key});
  final Map<String, dynamic>? args;

  @override
  _NewRoleScreenState createState() => _NewRoleScreenState();
}

class _NewRoleScreenState extends State<NewRoleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "name": "",
    "ckb_name": "",
    "kmr_name": "",
    "bad_name": "",
    "ar_name": "",
    "is_public": false,
    "order": 0,
  };
  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedElement;
  bool isViewOnly = false;
  late String title;

  late final i18n i;
  late final Basics bpr;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

      title = i.tr('m52') + i.tr('role');
      Map<String, dynamic>? args = widget.args;
      args ??=
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _editedElement = bpr.findBasicById('role', args['editedId'] as int);
        isViewOnly = args['isViewOnly'];
        title = isViewOnly
            ? i.tr('m53') + i.tr('role')
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
          "is_public": _editedElement['is_public'],
          "order": _editedElement['order'],
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '++++++++++++++++++++++++     new_role_screen build     ++++++++++++++++++++++++');
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
        _buildOrder,
        _buildName,
        _buildCkbName,
        _buildKmrName,
        _buildBadName,
        _buildArName,
        _buildIsPublicSwitch,
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
      onSavedHandler: (value) => _formData['kmr_name'] = value,
    );
  }

  TextFormFieldWidget get _buildBadName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _formData['bad_name'],
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

  SwitchWidget get _buildIsPublicSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.public_off,
        color: kPrimaryMediumColor,
      ),
      title: i.tr('is public'),
      initialValue: _formData['is_public'],
      onToggleHandler: (bool value) {
        _formData['is_public'] = value;
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

  IncreaseDecreaseSpinner get _buildOrder {
    return IncreaseDecreaseSpinner(
      title: i.tr('order'),
      initialValue: _formData['order'],
      onChangedHandler: (value) => _formData['order'] = value,
      isEnabled: !_isLoading,
    );
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
      await bpr.newBasic('role', _formData);
      Navigator.pop(
          context); // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException catch (error) {
      var errorMessage = i.tr(_formData['id'] == null ? 'm57' : 'm58');
      String e = error.toString();
      // if (e.contains('username already exists')) {
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
