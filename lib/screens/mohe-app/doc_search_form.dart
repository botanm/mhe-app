import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../utils/services/http_exception.dart';
import '../../utils/utils.dart';
import '../../widgets/menu_picker.dart';
import '../../widgets/submit_button.dart';
import '../../widgets/textformfield_widget.dart';

class DocSearchForm extends StatefulWidget {
  const DocSearchForm({Key? key, required this.onSelect}) : super(key: key);

  /// Callback for when a code is detected
  final void Function(Map<String, dynamic>) onSelect;

  @override
  _DocSearchFormState createState() => _DocSearchFormState();
}

class _DocSearchFormState extends State<DocSearchForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);

  late Map<String, dynamic> _searchData;

  bool _isInit = true;
  bool _isLoading = false;

  late final i18n i;
  late final Basics bpr;

  late final List<dynamic> _organizations;

  final Map<String, bool> _fieldValidation = {
    "refNo": true,
    "refDate": true,
    "branchId": true
  };

  void get updateFieldValidation {
    _fieldValidation['refNo'] = _searchData['refNo'] != "";
    _fieldValidation['refDate'] = _searchData['refDate'] != "";
    _fieldValidation['branchId'] = _searchData['branchId'] != "";
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

      _organizations = bpr.branches;
      initializeSearchData;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void get initializeSearchData {
    Map<String, dynamic> bprDocSearchData = bpr.docSearchData;
    _searchData = {
      "refNo": bprDocSearchData["refNo"],
      "refDate": bprDocSearchData["refDate"],
      "branchId": bprDocSearchData["branchId"]
    };
  }

  void get resetSearchData {
    _searchData = {"refNo": "", "refDate": "", "branchId": ""};
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     DocSearchForm build     ++++++++++++++++++++++++');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Directionality(
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
    List<Widget> elements = _buildGeneralElements;

    return Column(
      children: elements,
    );
  }

  List<Widget> get _buildGeneralElements {
    return [
      _32,
      _buildResetButton,
      _12,
      _buildOrganization,
      _12,
      _buildDatePicker,
      _12,
      _buildRefNo,
      const Spacer(),
      _buildSubmitButton,
    ];
  }

  MenuPicker get _buildOrganization {
    return MenuPicker(
      allElements: _organizations,
      maSecName: const ['name', 'name'],
      initialSelected:
          _searchData['branchId'] == "" ? [] : [_searchData['branchId']],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        setState(() {
          _searchData['branchId'] = value;
        });
      },
      isScrollControlled:
          true, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 0.9,
      title: i.tr('organization'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !_isLoading,
      isTree: true,
      isValidated: _fieldValidation['branchId'] as bool,
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
              resetSearchData;
            });
          },
          child: Text(
            i.tr("Reset Filter"),
            style: const TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget get _buildDatePicker {
    bool drawBorder = _searchData['refDate'] == "" ? true : false;
    Color textIconColor = _searchData['refDate'] == ""
        ? Colors.black.withOpacity(0.40)
        : Colors.white;
    Color tileColor = _searchData['refDate'] == ""
        ? Colors.transparent
        : kPrimaryColor.withOpacity(0.60);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: drawBorder
              ? Border.all(
                  width: 1.1,
                  color: !_fieldValidation['refDate']!
                      ? Colors.red.shade400
                      : Colors.black.withOpacity(0.40), // red as border color
                )
              : null),
      child: _builsDateListTile(textIconColor, tileColor),
    );
  }

  ListTile _builsDateListTile(Color textIconColor, Color tileColor) {
    return ListTile(
      onTap: !_isLoading ? _onTapOnDate : null,
      title: Text(
        _searchData['refDate'] != "" ? _searchData['refDate'] : 'بەروار',

        // textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: textIconColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: textIconColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      dense: true,
      selected: true,
      selectedTileColor: tileColor,
    );
  }

  _onTapOnDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        Color color = kPrimaryColor;
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color, // Header background color
            dialogBackgroundColor:
                Colors.white, // Background color of the date picker dialog
            colorScheme: ColorScheme.light(
              primary: color, // Selected date color
              onPrimary: Colors.white, // Text color of the selected date
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: color, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        // Manually format the selected date as yyyy-MM-dd and store in _searchData['refDate']
        _searchData['refDate'] =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  TextFormFieldWidget get _buildRefNo {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _searchData['refNo'],
      icon: Icons.confirmation_num, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: 'ژمارەی نوسراو',
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validatorHandler: (value) {
        if (value.isEmpty) {
          _fieldValidation['refNo'] = false;
          return i.tr('m8');
        }
        // else if (value.length != 6) {
        //   _fieldValidation['refNo'] = false;
        //   return i.tr('m91');
        // }
        else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          _fieldValidation['otp'] = false;
          return i.tr('m92');
        }
        _fieldValidation['refNo'] = true;
        return null;
      },
      onSavedHandler: (value) => _searchData['refNo'] = value,
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
    updateFieldValidation;
    if (!_formKey.currentState!.validate() ||
        _fieldValidation.containsValue(false)) {
      // Invalid!
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      updateFieldValidation;
      _isLoading = true;
    });

    try {
      // String payload = "?$p1$p2$p3$p4$p5$p6";
      // if (payload != "?") {
      //   await cpr.filterUsers(payload);
      //   cpr.userSearchData = _searchData;
      // }
      widget.onSelect(_searchData);
      Navigator.of(context).pop(); // to pop off in the navigator
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
      var errorMessage =
          error.toString(); // i.tr(_searchData['id'] == null ? 'm46' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
