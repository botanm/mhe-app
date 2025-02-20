import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../utils/services/http_exception.dart';
import '../../utils/utils.dart';
import '../../widgets/number_menu_picker.dart';
import '../../widgets/submit_button.dart';

class SalarySearchForm extends StatefulWidget {
  const SalarySearchForm({
    super.key,
  });

  @override
  _SalarySearchFormState createState() => _SalarySearchFormState();
}

class _SalarySearchFormState extends State<SalarySearchForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);

  bool _isInit = true;
  bool _isLoading = false;

  late final i18n i;
  late final Auth apr;
  late final Basics bpr;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     SalarySearchForm build     ++++++++++++++++++++++++');
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
    List<Widget> elements = _buildSuperuserAndStaffElements;

    return Column(
      children: elements,
    );
  }

  List<Widget> get _buildSuperuserAndStaffElements {
    return [
      _32,
      _12,
      _buildYear,
      _12,
      _buildMonth,
      const Spacer(),
      _buildSubmitButton,
    ];
  }

  Widget get _buildYear {
    int currentYear = DateTime.now().year;
    return NumberMenuPicker(
      firstNo: currentYear - 10, // 2004
      lastNo: currentYear + 1, // 2023
      descending: true,
      initialSelected: bpr.salarySearchData['year'] == null
          ? []
          : [
              bpr.salarySearchData['year']
            ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      text: i.tr("Select Year"),
      onSelectedHandler: (value) => bpr.salarySearchData['year'] = value,
      isEnabled: !_isLoading,
      isValidated: true,
    );
  }

  Widget get _buildMonth {
    int currentMonth = DateTime.now().month;
    print(currentMonth);
    return NumberMenuPicker(
      firstNo: 01,
      lastNo: 13,
      // descending: true,
      initialSelected: bpr.salarySearchData['month'] == null
          ? []
          : [
              bpr.salarySearchData['month']
            ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      text: i.tr("Select Year"),
      onSelectedHandler: (value) => bpr.salarySearchData['month'] = value,
      isEnabled: !_isLoading,
      isValidated: true,
    );
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

    try {
      await bpr.fetchAndSetSalary(null, null);

      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "AccountListScreen"
    } on HttpException {
      var errorMessage = i.tr('m58');
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
      var errorMessage = i.tr('m14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
