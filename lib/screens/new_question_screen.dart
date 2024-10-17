import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../../utils/services/http_exception.dart';

import '../../../../widgets/textformfield_widget.dart';

import '../constants/app_constants.dart';
import '../providers/basics.dart';
import '../providers/i18n.dart';
import '../providers/core.dart';

import '../widgets/background.dart';
import '../widgets/bullet_list.dart';
import '../widgets/menu_picker.dart';
import '../widgets/responsive.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_buttons_widget.dart';
import 'core/auth/login/components/side_image_widget.dart';
import 'dashboard/components/basics_rud_appbar.dart';

// class NewQuestionScreen extends StatefulWidget {
//   static const routeName = '/newquestion';
//   const NewQuestionScreen({Key? key}) : super(key: key);

//   @override
//   State<NewQuestionScreen> createState() => _NewQuestionScreenState();
// }

// class _NewQuestionScreenState extends State<NewQuestionScreen> {
//   bool _isInit = true;

//   late final i18n i;

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       i = Provider.of<i18n>(context, listen: false);
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(
//     //     '++++++++++++++++++++++++     new_question_screen build     ++++++++++++++++++++++++');
//     double w = Responsive.w(context);
//     final NewQuestionStepper ref = NewQuestionStepper();
//     return Background(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (w < 1000) const SizedBox(height: defaultPadding / 3),
//             if (w < 1000) ref,
//             if (!(w < 1000))
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: ref,
//                   ),
//                   const SizedBox(width: defaultPadding),
//                   const Expanded(
//                     flex: 3,
//                     child: SideImageWidget(
//                         // title: 'FORGOT PASSWORD',
//                         svgUrl: 'assets/icons/logo-ministry.svg'),
//                   ),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

class NewQuestionScreen extends StatefulWidget {
  static const routeName = '/newquestion';
  const NewQuestionScreen({super.key});

  @override
  _NewQuestionScreenState createState() => _NewQuestionScreenState();
}

class _NewQuestionScreenState extends State<NewQuestionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "id": null,
    "content": "",
    "dialect": null,
    "selected_answerer": null,
    "categories": []
  };
  int _currentStep = 0;

  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _editedElement;
  late String _title;

  late final i18n i;
  late final Core cpr;
  late final Basics bpr;

  late final List<dynamic> _categories;
  late final List<dynamic> _dialects;

  bool isAnyAA = false;
  bool _isEdit = false;
  bool _isEditAnsweredQuestion = false;
  bool isSystemSelectAnswerer = true;
  final String _prompt = 'm2';

  late final List<String> _maSecBasicName;
  bool _is2ndStepValidateViolationTriggered = false;
  bool _isSubmitValidateViolationTriggered = false;

  final bool _1stStepVal = true;
  bool _2ndStepVal = true;
  bool _3rdStepVal = true;
  bool _4thStepVal = true;

  List<bool> _isVal = [
    true,
    true,
    true
  ]; //_categories,_dialects, selected_answerer

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

      _categories = bpr.categories;
      _dialects = bpr.dialects;

      _maSecBasicName = i.maSecBasicName;

      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _isEdit = true;
        isAnyAA = true;

        _isEditAnsweredQuestion = args['isEditAnsweredQuestion'];

        int id = args['id'];
        _editedElement = args['isEditAnsweredQuestion']
            ? cpr.findAnsweredQuestionById(id)
            : cpr.findQuestionById(id);
        _title = 'Edit';

        _formData = {
          "id": _editedElement!['id'],
          "content": _editedElement['content'],
          "dialect": _editedElement['dialect'],
          "selected_answerer": _editedElement['selected_answerer'],
          "categories": _editedElement['categories'] ?? []
        };
      }
      _title = _isEdit ? 'Edit Question' : 'Send Question';
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '++++++++++++++++++++++++     new_question_screen build     ++++++++++++++++++++++++');
    double w = Responsive.w(context);
    var buildNewQuestionStepper = _buildNewQuestionStepper(context);
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: _buildAppBar,
        persistentFooterButtons: [_buildOnStepContinueAndCancelButtons],
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (w < 1000) const SizedBox(height: defaultPadding / 3),
                if (w < 1000) buildNewQuestionStepper,
                if (!(w < 1000))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildNewQuestionStepper,
                      ),
                      const SizedBox(width: defaultPadding),
                      const Expanded(
                        flex: 3,
                        child: SideImageWidget(
                            // title: 'FORGOT PASSWORD',
                            svgUrl: 'assets/icons/logo-ministry.svg'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildNewQuestionStepper(BuildContext context) {
    return Form(
      key: _formKey,
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black)),
        child: Stepper(
          // type: StepperType.horizontal,

          /// Stepper Inside parent Scroll such as ListView as Parents
          /// https://stackoverflow.com/questions/49519522/flutter-stepper-is-not-scrolling-when-added-inside-listview
          steps: _getSteps,
          currentStep: _currentStep,
          // onStepContinue: () {
          //   final _isLastStep = _currentStep == _getSteps.length - 1;
          //   if (_isLastStep) {
          //     _onSubmit();
          //   } else {
          //     setState(() => _currentStep++);
          //   }
          // },
          onStepTapped: (step) {
            if (_currentStep != 0 &&
                step > 1 &&
                !_isLoading &&
                ((!_isEdit && !isAnyAA) ||
                    _formData['dialect'] == null ||
                    _formData['content'] == "")) {
              setState(() {
                _isVal[3] = _formData['dialect'] != null;
                _2ndStepVal = false;
                _is2ndStepValidateViolationTriggered = true;
              });
            } else if (_currentStep != 0 && !_isLoading) {
              setState(() => _currentStep = step);
            }
          },
          // onStepCancel: _currentStep == 0
          //     ? null
          //     : () {
          //         setState(() => _currentStep--);
          //       },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container();
          },
          // controlsBuilder: (BuildContext context, ControlsDetails details) {
          //   final _isLastStep = _currentStep == _getSteps.length - 1;
          //   return Container(
          //       margin: const EdgeInsets.only(top: 50),
          //       child: Row(children: [
          //         if (_currentStep != 0)
          //           Expanded(
          //               child: ElevatedButton(
          //                   child: Text('Back'),
          //                   onPressed: details.onStepCancel)),
          //         const SizedBox(width: 12),
          //         Expanded(
          //             child: ElevatedButton(
          //                 child: Text(_isLastStep
          //                     ? 'Send'
          //                     : _currentStep == 0
          //                         ? 'Agree'
          //                         : 'Next'),
          //                 onPressed: details.onStepContinue)),
          //       ]));
          // },
        ),
      ),
    );
  }

  PreferredSize get _buildAppBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56), // default appBar height: 56,
      child: BasicsRUDAppBar(title: i.tr(_title)),
    );
  }

  List<Step> get _getSteps => <Step>[
        _1stStep,
        _2ndStep,
        _3rdStep,
        if (_isEdit) _4thStep,
      ];

  Step get _1stStep => Step(
        state: _stepState(0, _1stStepVal),
        isActive: _currentStep >= 0,
        title: Text(i.tr('Tips')),
        content: _1stStepContent,
      );

  Step get _2ndStep => Step(
        state: _stepState(1, _2ndStepVal),
        isActive: _currentStep >= 1,
        title: Text(i.tr('Question')),
        content: _2ndStepContent,
      );
  Step get _3rdStep => Step(
        state: _stepState(2, _3rdStepVal),
        isActive: _currentStep >= 2,
        title: Text(i.tr('Answerer')),
        content: _3rdStepContent,
      );
  Step get _4thStep => Step(
        state: _stepState(3, _4thStepVal),
        isActive: _currentStep >= 3,
        title: Text(i.tr('Classification')),
        content: _currentStep == 3 ? _4thStepContent : Container(),
      );

  StepState _stepState(int stepIndex, bool val) {
    if (!val) {
      return StepState.error;
    } else if (_currentStep > stepIndex) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  BulletList get _1stStepContent {
    final title = i.tr('m3');
    final List<String> tips = [
      i.tr('m4'),
      i.tr('m5'),
      i.tr('m6'),
      i.tr('m7'),
    ];
    return BulletList(title: title, strings: tips);
  }

  Padding get _2ndStepContent => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: [
            if (_currentStep == 1) _buildDialect,
            const SizedBox(height: 12),
            if (isAnyAA || _isEdit) _buildQuestion,
            if (!_isEdit &&
                (_formData['dialect'] != null && !isAnyAA && !_isLoading))
              Text(
                i.tr(_prompt),
                style: const TextStyle(color: Colors.red, fontSize: 14),
              )
          ],
        ),
      );

  Column get _3rdStepContent {
    final title = i.tr('m16');
    final List<String> tips = [
      i.tr('m17'),
      i.tr('m18'),
      i.tr('m19'),
    ];
    return Column(
      children: [
        BulletList(title: title, strings: tips),
        const SizedBox(height: 12),
        if (_currentStep == 2) _buildSelectAnswererWidget,
      ],
    );
  }

  MenuPicker get _4thStepContent => MenuPicker(
        allElements: _categories,
        maSecName: _maSecBasicName,
        initialSelected: _formData['categories'],
        // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array BUT IF it was list _userData['city']
        multipleSelectionsAllowed:
            true, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
        selectedHandler: (value) {
          _formData['categories'] = value;
          _isValRenew;
          bool new4thStepVal = _isVal[0];
          if (_isSubmitValidateViolationTriggered &&
              _4thStepVal != new4thStepVal) {
            setState(() {
              _4thStepVal = new4thStepVal;
            });
          }
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
        isValidated: _isVal[0],
      );

  TextFormFieldWidget get _buildQuestion {
    return TextFormFieldWidget(
      isTextRtl: _dialects
          .firstWhere((e) => e['id'] == _formData['dialect'])['is_rtl'],
      initialValue: _formData['content'],
      icon: Icons.question_mark, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Question content'),
      enabled: !_isLoading,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.none,
      // autovalidateMode: _isSubmitValidateViolationTriggered
      //     ? AutovalidateMode.onUserInteraction
      //     : null, // default null
      autovalidateMode: _is2ndStepValidateViolationTriggered
          ? AutovalidateMode.always
          : null, // default null
      validatorHandler: (value) {
        if (value.isEmpty) {
          _2ndStepVal = false;
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['content'] = value,
      onChangedHandler: (value) {
        _formData['content'] = value;
        bool new2ndStepVal = _formData['dialect'] != null && value.isNotEmpty;
        // if (_isSubmitValidateViolationTriggered &&
        if (_is2ndStepValidateViolationTriggered &&
            _2ndStepVal != new2ndStepVal) {
          setState(() => _2ndStepVal = new2ndStepVal);
        }
      },
    );
  }

  MenuPicker get _buildDialect {
    return MenuPicker(
      allElements: _dialects,
      maSecName: _maSecBasicName,
      initialSelected: _formData['dialect'] == null
          ? []
          : [
              _formData['dialect']
            ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: _isEdit
          ? (value) {
              _formData['dialect'] = value;
            }
          : (value) async {
              setState(() => _isLoading = true);
              _formData['dialect'] = value;

              try {
                isAnyAA = await bpr.isAnyAnswererAvailable([value]);
                setState(() {
                  _isLoading = false;
                  _2ndStepVal = isAnyAA;
                  if (_is2ndStepValidateViolationTriggered) {
                    _2ndStepVal = isAnyAA &&
                        _formData['content'] != "" &&
                        _formData['dialect'] != null;
                  }
                });
              } catch (e) {
                // print("Error FF: $e");
                setState(() => _isLoading = false);
                String errorMessage = i.tr('m9');
                Utils.showErrorDialog(context, errorMessage);
              }
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
      isValidated: _isVal[1],
    );
  }

  SelectAnswererWidget get _buildSelectAnswererWidget {
    List<String> texts = [
      // 'I\'d like a recommendation',
      // 'I know what answerer I want'
      i.tr('System suggestion'),
      i.tr('I\'ll choose it')
    ];

    return SelectAnswererWidget(
      texts: texts,
      isSystemSelectAnswerer: isSystemSelectAnswerer,
      initialSelectedAnswerer: _formData['selected_answerer'],
      onChangedHandler: (iSSA, sA) {
        isSystemSelectAnswerer = iSSA;
        _formData['selected_answerer'] = sA;

        bool newisvalSa = sA != null || iSSA;
        if (_isSubmitValidateViolationTriggered && _isVal[2] != newisvalSa) {
          setState(() {
            _isVal[2] = _3rdStepVal = newisvalSa;
          });
        }
      },
      selectedDialect: _formData['dialect'],
      isValidated: _isVal[2],
      isLoading: _isLoading,
      isEdit: _formData['id'] != null,
    );
  }

  Row get _buildOnStepContinueAndCancelButtons {
    return Row(
      children: [
        if (_currentStep != 0 && !_isLoading)
          Expanded(child: _buildOnStepCancelButton),
        const SizedBox(width: 12),
        Expanded(child: _buildOnStepContinueButton),
      ],
    );
  }

  SubmitButton get _buildOnStepContinueButton {
    final isLastStep = _currentStep == _getSteps.length - 1;
    String disabledText = i.tr(_isEdit ? 'Editing' : 'Sending');
    String text;
    if (isLastStep) {
      text = i.tr(_isEdit ? 'Edit' : 'Send');
    } else {
      text = i.tr(_currentStep == 0 ? 'Agree' : 'Next');
    }

    return SubmitButton(
      isSubmitButtonDisabled: _isLoading,
      text: text,
      disabledText: disabledText,
      background: isAnyAA || _currentStep == 0 ? null : Colors.grey[300],
      height: 36,
      keepOrigin: true,
      onPressedHandler:
          _currentStep != 0 && (_formData['dialect'] != null && !isAnyAA)
              ? null
              : () {
                  if (isLastStep) {
                    _onSubmit();
                  } else if (_currentStep == 1 &&
                      (!isAnyAA ||
                          _formData['dialect'] == null ||
                          _formData['content'] == "")) {
                    setState(() {
                      _isVal[1] = _formData['dialect'] != null;
                      _2ndStepVal = false;
                      _is2ndStepValidateViolationTriggered = true;
                    });
                  } else {
                    setState(() => _currentStep++);
                  }
                },
    );
  }

  SubmitButton get _buildOnStepCancelButton {
    String text = i.tr('Back');
    String disabledText = i.tr('Back');

    return SubmitButton(
      isSubmitButtonDisabled: _isLoading,
      text: text,
      disabledText: disabledText,
      keepOrigin: true,
      onPressedHandler: _currentStep == 0
          ? () {}
          : () {
              setState(() => _currentStep--);
            },
    );
  }

  void get _isValRenew {
    _isVal = [
      _formData['categories'].isNotEmpty,
      _formData['dialect'] != null,
      _formData['selected_answerer'] != null || isSystemSelectAnswerer
    ];
  }

  Future<void> _onSubmit() async {
    _isValRenew;
    final bool isCatSelected = _isVal[0];
    // final bool _isDialectSelected = _isVal[3] == true;

    if (!_formKey.currentState!.validate() ||
        // !_isDialectSelected ||
        !_isVal[2] ||
        (!isCatSelected && _isEdit)) {
      // Invalid!
      if (!_isSubmitValidateViolationTriggered) {
        // if (!_isDialectSelected || _formData['content'] == "") {
        //   _2ndStepVal = false;
        // }
        if (!_isVal[2]) {
          _3rdStepVal = false;
        }
        if (!isCatSelected) {
          _4thStepVal = false;
        }
        setState(() => _isSubmitValidateViolationTriggered = true);
      }
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    if (isSystemSelectAnswerer && !_isEdit) {
      _formData['selected_answerer'] = null;
    }

    try {
      await cpr.newQuestion(_formData, _isEditAnsweredQuestion);
      Navigator.of(context)
          .pop(); // to pop off in the navigator, AND show "MyQuestionsScreen"
    } on HttpException catch (error) {
      var errorMessage = _isEdit ? 'm58' : 'Sending failed';
      String e = error.toString();
      if (e.contains('exceed threshold')) {
        _formData['selected_answerer'] = null;
        errorMessage = 'm10';
      } else if (e.contains('Request was throttled')) {
        errorMessage = 'm11';
      } else if (e.contains('content already exists')) {
        errorMessage = 'm12';
      } else if (e.contains('no answerer available')) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        errorMessage = 'm2';
      } else if (e.contains('not answerer')) {
        errorMessage = 'm13';
      }
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
      Utils.showErrorDialog(context, i.tr(errorMessage));
    } catch (error) {
      var errorMessage = _isEdit ? 'm14' : 'm15';
      Utils.showErrorDialog(context, i.tr(errorMessage));
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

class SelectAnswererWidget extends StatefulWidget {
  const SelectAnswererWidget({
    super.key,
    required this.texts,
    required this.isSystemSelectAnswerer,
    required this.initialSelectedAnswerer,
    required this.onChangedHandler,
    required this.selectedDialect,
    required this.isValidated,
    this.isLoading = false,
    required this.isEdit,
  });

  final List<String> texts;
  final bool isSystemSelectAnswerer;
  final int? initialSelectedAnswerer;
  final Function(bool, int?) onChangedHandler;
  final int selectedDialect;
  final bool isValidated;
  final bool isLoading;
  final bool isEdit;

  @override
  State<SelectAnswererWidget> createState() => _SelectAnswererWidgetState();
}

class _SelectAnswererWidgetState extends State<SelectAnswererWidget> {
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  List<dynamic> _answerers = [];
  late final List<String> _maSecUserName;

  late bool _ISSA;
  late int? _SA;

  bool _isLoading = false;
  final String _prompt = 'm2';

  @override
  void initState() {
    super.initState();
    i = Provider.of<i18n>(context, listen: false);

    bpr = Provider.of<Basics>(context, listen: false);
    cpr = Provider.of<Core>(context, listen: false);

    _ISSA = widget.isEdit ? false : widget.isSystemSelectAnswerer;
    _SA = widget.initialSelectedAnswerer;
    _maSecUserName = i.maSecUserName;

    // if (!_ISSA) {
    _fetchAvailableUsers;
    // }
  }

  @override
  void didUpdateWidget(SelectAnswererWidget oldWidget) {
    if (oldWidget.initialSelectedAnswerer != widget.initialSelectedAnswerer &&
        widget.initialSelectedAnswerer == null) {
      // the upper condition is set, because of the following code that is written in _onSubmit() of NewQuestionScreen
      // to get new set of available users that exclude the user with exceed threshold
      // if (e.contains('exceed threshold')) {
      //   _formData['selected_answerer'] = null;
      // }
      _SA = widget.initialSelectedAnswerer;
      _fetchAvailableUsers;
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> get _fetchAvailableUsers async {
    // print("_fetchAvailableUsers");

    if (widget.isEdit) {
      final answererRoleIId =
          (bpr.roles.firstWhere((r) => r['name'] == 'Answerer'))['id'];

      _answerers = cpr.users.where((e) {
        return e['roles'].contains(answererRoleIId) &&
            e['dialects'].contains(widget.selectedDialect);
      }).toList();

      bool iPSAE = _answerers.any((e) => e['id'] == _SA); // IsPreviousSAExist
      if (!iPSAE) {
        Map<String, dynamic> answererData = cpr.findUserById(_SA!);
        // _answerers.add(_answererData);
        _answerers.insert(0, answererData); // at the start of the list
      }
    } else {
      setState(() => _isLoading = true);
      _answerers = await bpr.fetchAvailableUsers([widget.selectedDialect]);

      // when you change dialect, this condition  check if old selected answerer exist in new _answerers or not
      bool IPSAE = _answerers.any((e) =>
          e['id'] == _SA); // is previous _SA Exist in new _answerers list
      if (!IPSAE) {
        _SA = null;
        widget.onChangedHandler(_ISSA, _SA);
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** SelectAnswererWidget build ***************');
    return Column(
      children: [
        if (!widget.isEdit) _buildToggle,
        const SizedBox(height: 12),
        if (_answerers.isEmpty && !_isLoading)
          Text(
            i.tr(_prompt),
            style: const TextStyle(color: Colors.red, fontSize: 14),
          )
        else if (!_ISSA && !_isLoading)
          _buildAnswerer,
        if (_isLoading)
          const SizedBox(
            height: 30.0,
            width: 30.0,
            child: kCircularProgressIndicator,
          ),
      ],
    );
  }

  ToggleButtonsWidget get _buildToggle {
    return ToggleButtonsWidget(
      texts: widget.texts,
      initialSelected: [_ISSA, !_ISSA],
      selectedHandler: (index) {
        bool newISSA = index == 0; // isSystemSelectAnswerer
        if (_ISSA != newISSA) {
          setState(() {
            _ISSA = newISSA;
            widget.onChangedHandler(_ISSA, _SA);
          });
          // if (_answerers.isNotEmpty && !widget.isEdit) {
          //   _fetchAvailableUsers;
          // }
        }
      },
      isEnabled: !widget.isLoading,
      // selectedColor: const Color(0xFF6200EE), // default
      // borderRadius: 24.0, // default
      // stateContained: true, // default
      multipleSelectionsAllowed: false, // default
      // canUnToggle: false, // default AND it is work if "multipleSelectionsAllowed: false"
    );
  }

  MenuPicker get _buildAnswerer {
    return MenuPicker(
      allElements: _answerers,
      maSecName: _maSecUserName,
      initialSelected: _SA == null ? [] : [_SA],
      // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (value) {
        int newSA = value;
        if (_SA != newSA) {
          _SA = newSA;
          widget.onChangedHandler(_ISSA, _SA);
        }
      },
      isScrollControlled:
          true, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 0.85,
      title: i.tr('Answerer'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: true,
      isSecondaryVisible: true,
      isEnabled: !widget.isLoading,
      isValidated: widget.isValidated,
    );
  }
}
