import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/basics.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/services/http_exception.dart';

import '../../../../widgets/submit_button.dart';
import '../../../../widgets/textformfield_widget.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/increase_decrease_spinner.dart';
import '../../../widgets/menu_picker.dart';
import 'basics_rud_appbar.dart';

class NewCategoryScreen extends StatefulWidget {
  static const routeName = '/newcategory';
  const NewCategoryScreen({this.args, super.key});
  final Map<String, dynamic>? args;

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "parent_id": null,
    "name": "",
    "ckb_name": "",
    "kmr_name": "",
    "bad_name": "",
    "ar_name": "",
    "order": 0,
  };
  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedElement;
  bool isViewOnly = false;
  late String title;

  late final i18n i;
  late final Basics bpr;

  late final List<dynamic> _categories;
  late final List<String> _maSecBasicName;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

      _categories = bpr.categories;
      _maSecBasicName = i.maSecBasicName;

      title = i.tr('m52') + i.tr('category');
      Map<String, dynamic>? args = widget.args;
      args ??=
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _editedElement = bpr.findBasicById('category', args['editedId'] as int);
        isViewOnly = args['isViewOnly'];
        title = isViewOnly
            ? i.tr('m53') + i.tr('city type')
            : args['editedId'] != null
                ? i.tr('Edit')
                : title;
        _isLoading = isViewOnly;

        _formData = {
          "id": _editedElement!['id'],
          "parent_id": _editedElement['parent_id'],
          "name": _editedElement['name'],
          "ckb_name": _editedElement['ckb_name'],
          "kmr_name": _editedElement['kmr_name'],
          "bad_name": _editedElement['bad_name'],
          "ar_name": _editedElement['ar_name'],
          "order": _editedElement['order'],
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('+++++++++++    new_category_screen build    +++++++++');
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
        _buildParent,
        const SizedBox(height: 10),
        _buildName,
        _buildCkbName,
        _buildKmrName,
        _buildBadName,
        _buildArName,
        const SizedBox(height: 32),
        const Spacer(),
        if (!isViewOnly) _buildSubmitButton,
      ],
    );
  }

  MenuPicker get _buildParent {
    return MenuPicker(
      allElements: _categories,
      maSecName: _maSecBasicName,
      initialSelected:
          _formData['parent_id'] == null ? [] : [_formData['parent_id']],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        _formData['parent_id'] = value;
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('category'),
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
      await bpr.newBasic('category', _formData);
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
