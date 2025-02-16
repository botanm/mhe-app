import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../providers/auth.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../utils/services/http_exception.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/responsive.dart';
import '../../../../../widgets/submit_button.dart';
import '../../../../../widgets/textformfield_widget.dart';

class RegisterStepper extends StatefulWidget {
  const RegisterStepper({super.key});

  @override
  _RegisterStepperState createState() => _RegisterStepperState();
}

class _RegisterStepperState extends State<RegisterStepper> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, dynamic> _formData = {
    "biometric": "",
    "email": "",
    "password": "",
    "employeeId": ""
  };
  int _currentStep = 0;

  bool _isInit = true;
  bool _isLoading = false;

  late final i18n i;
  late final Auth apr;

  final bool _is2ndStepValidateViolationTriggered = false;
  final bool _isSubmitValidateViolationTriggered = false;

  bool _1stStepVal = true;
  bool _2ndStepVal = true;

  final List<bool> _isStepPassed = [false, false];

  final Map<String, bool> _fieldValidation = {
    "biometric": true,
    "email": true,
    "password": true,
    "employeeId": true
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     register_stepper  build     ++++++++++++++++++++++++');
    bool isMobile = Responsive.isMobile(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Form(
          key: _formKey,
          child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: kPrimaryColor)),
            child: Column(
              children: [
                buildStepper,
                SizedBox(height: isMobile ? 20 : 60),
                _buildOnStepContinueAndCancelButtons,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stepper get buildStepper {
    return Stepper(
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
        switch (step) {
          case 0:
            setState(() => _currentStep = step);
            break;
          case 1:
            if (_isStepPassed[0]) {
              setState(() => _currentStep = step);
            }
            break;
          // case 2:
          //   if (_isStepPassed[0] && _isStepPassed[1]) {
          //     setState(() => _currentStep = step);
          //   }
          //   break;
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
    );
  }

  List<Step> get _getSteps => <Step>[
        _1stStep,
        _2ndStep,
      ];

  Step get _1stStep => Step(
        state: _stepState(0, _1stStepVal),
        isActive: _currentStep >= 0,
        title: Text(i.tr("Verify")),
        content: _1stStepContent,
      );
  Step get _2ndStep => Step(
        state: _stepState(1, _2ndStepVal),
        isActive: _currentStep >= 1,
        title: Text(i.tr("Password")),
        content: _2ndStepContent,
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

  Padding get _1stStepContent => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i.tr("m97"),
              style: const TextStyle(fontSize: 14),
            ),
            _buildBiometric,
            _buildEmail,
          ],
        ),
      );
  Widget get _2ndStepContent => _currentStep != 1
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [_buildPassword, _buildConfirmPassword],
          ),
        );

  List<String> getOnStepContinueTexts() {
    List<String> text = [];
    switch (_currentStep) {
      case 0:
        text.addAll([i.tr("Verify"), i.tr("Verifying")]);
        break;
      case 1:
        text.addAll([i.tr("Register"), i.tr("Register")]);
        break;

      default:
        text.addAll([i.tr("Next"), i.tr("Cancel")]);
    }
    return text;
  }

  List<String> getOnStepCancelTexts() {
    List<String> text = [];
    switch (_currentStep) {
      case 0:
        text.addAll([i.tr("Back"), i.tr("Back")]);
        break;
      case 1:
        text.addAll([i.tr("Back"), i.tr("Back")]);
        break;
      case 2:
        text.addAll([i.tr("Back"), i.tr("Back")]);
        break;

      default:
        text.addAll([i.tr("Back"), i.tr("Back")]);
    }
    return text;
  }

  void continueOnPressedHandler() {
    switch (_currentStep) {
      case 0:
        _onSubmit();
        break;
      case 1:
        _onSubmit();
        break;

      default:
        setState(() => _currentStep++);
    }
  }

  Row get _buildOnStepContinueAndCancelButtons {
    return Row(
      children: [
        if (_currentStep != 0 && !_isLoading)
          Expanded(flex: 2, child: _buildOnStepCancelButton),
        const SizedBox(width: 12),
        Expanded(flex: 3, child: _buildOnStepContinueButton),
      ],
    );
  }

  SubmitButton get _buildOnStepContinueButton {
    List<String> texts = getOnStepContinueTexts();

    return SubmitButton(
      isSubmitButtonDisabled: _isLoading,
      text: texts[0],
      disabledText: texts[1],
      // background: _currentStep == 0 ? null : Colors.grey[300],
      height: 36,
      keepOrigin: true,
      onPressedHandler: continueOnPressedHandler,
    );
  }

  SubmitButton get _buildOnStepCancelButton {
    List<String> text = getOnStepCancelTexts();

    return SubmitButton(
      isSubmitButtonDisabled: _isLoading,
      text: text[0],
      background: _currentStep == 0 ? null : Colors.grey[300],
      foreground: kPrimaryColor,
      disabledText: text[1],
      keepOrigin: true,
      onPressedHandler: _currentStep == 0
          ? () {}
          : () {
              setState(() => _currentStep--);
            },
    );
  }

  TextFormFieldWidget get _buildBiometric {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['biometric'],
      icon: Icons.confirmation_number_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: 'کۆدی بایۆمەتری',
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          _fieldValidation['biometric'] = false;
          return i.tr('m8');
        } else if (value.contains(' ')) {
          _fieldValidation['biometric'] = false;
          return i.tr('m93');
        }
        _fieldValidation['biometric'] = true;
        return null;
      },
      onSavedHandler: (value) => _formData['biometric'] = value,
    );
  }

  TextFormFieldWidget get _buildEmail {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['email'],
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
          _fieldValidation['email'] = false;
          return i.tr('m38');
        }
        _fieldValidation['email'] = true;
        return null;
      },
      onSavedHandler: (value) => _formData['email'] = value,
    );
  }

  TextFormFieldWidget get _buildOTP {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['otp'],
      icon: Icons.confirmation_num, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('Code'),
      enabled: !_isLoading,
      // maxLines: 1,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validatorHandler: (value) {
        if (value.isEmpty) {
          _fieldValidation['otp'] = false;
          return i.tr('m8');
        } else if (value.length != 6) {
          _fieldValidation['otp'] = false;
          return i.tr('m91');
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          _fieldValidation['otp'] = false;
          return i.tr('m92');
        }
        _fieldValidation['otp'] = true;
        return null;
      },
      onSavedHandler: (value) => _formData['otp'] = value,
    );
  }

  TextFormFieldWidget get _buildPassword {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _formData['password'],
      icon: Icons.lock, // icon: null is default
      // suffixIcon: null, // default is null AND for password is configured bu default
      label: i.tr('Password'),
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
          _fieldValidation['password'] = false;
          return i.tr('m32');
        }
        _fieldValidation['password'] = true;
        return null;
      },
      onChangedHandler: (value) => _formData['password'] =
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
      label: i.tr('m34'),
      enabled: !_isLoading,
      // maxLines: 1, // default
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          _fieldValidation['password'] = false;
          return i.tr('m8');
        } else if (value != _formData['password']) {
          _fieldValidation['password'] = false;
          return i.tr('m35');
        }
        _fieldValidation['password'] = true;
        return null;
      },
      is_password: true,
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      setState(() {
        updateStepVal;
      });
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      updateStepVal;
      _isLoading = true;
    });

    try {
      await httpRequest();
      setState(() {
        updateStepVal;
      });
      final isLastStep = _currentStep == _getSteps.length - 1;
      if (_currentStep == 0 && !_1stStepVal) {
        setState(() {
          _isLoading = false;
        });
        return;
      } else if (isLastStep) {
        // Navigator.of(context).pop();
      } else {
        setState(() => _currentStep++);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Failed';
      String e = error.toString();
      if (e.contains('too common')) {
        _formData['password'] = "";
        errorMessage = 'm94';
      }
      //else if (e.contains('Request was throttled')) {
      //   errorMessage = 'm11';
      // } else if (e.contains('content already exists')) {
      //   errorMessage = 'm12';
      // } else if (e.contains('no answerer available')) {
      //   Navigator.popUntil(context, ModalRoute.withName('/'));
      //   errorMessage = 'm2';
      // } else if (e.contains('not answerer')) {
      //   errorMessage = 'm13';
      // }
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
      var errorMessage = 'Failed';
      Utils.showErrorDialog(context, i.tr(errorMessage));
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> httpRequest() async {
    switch (_currentStep) {
      case 0:
        try {
          final employeeId = await apr.registerFirstStepGetEmployeeId({
            "BiometricCode": _formData["biometric"],
            "email": _formData["email"]
          });

          if (employeeId != null) {
            _formData['employeeId'] = employeeId;
            _fieldValidation['employeeId'] = true;
            _isStepPassed[0] = true;
          } else {
            _fieldValidation['employeeId'] = false;
          }
        } catch (error) {
          _fieldValidation['employeeId'] = false;
          Utils.showErrorDialog(context, error.toString());
        }
        break;
      case 1:
        try {
          final msg = await apr.registerSecondStepSetPassword({
            "employeeId": _formData["employeeId"],
            "password": _formData["password"]
          });
          if (msg != null) {
            _isStepPassed[1] = true;
            _fieldValidation['password'] = true;
            Utils.showSuccessDialog(context, msg);
          } else {
            _fieldValidation['password'] = false;
          }
        } catch (error) {
          _fieldValidation['password'] = false;
          Utils.showErrorDialog(context, error.toString());
        }
        break;
      case 2:
        await apr.resetPassword({
          "email": _formData["email"],
          "username": _formData["username"],
          "otp": _formData["otp"],
          "password": _formData["password"]
        });
        _isStepPassed[2] = true;
        break;

      default:
        setState(() => _currentStep++);
    }
  }

  void get updateStepVal {
    _1stStepVal = _fieldValidation['biometric']! &&
        _fieldValidation['email']! &&
        _fieldValidation['employeeId']!;
    _2ndStepVal = _fieldValidation['password']!;
  }
}
