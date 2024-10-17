import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../providers/auth.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../utils/services/http_exception.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/already_have_an_account_acheck.dart';
import '../../../../../widgets/submit_button.dart';
import '../../../../help_screen.dart';
import '../../register/register_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isObscure = true;
  late final i18n i;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  bool _isLoading = false;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('*************** login_form build ***************');

    Theme theme = Theme(
        data: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          suffixIconColor: kPrimaryMediumColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        )),
        child: _buildFormElements());
    return Form(
      key: _formKey,
      child: Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: theme),
    );
  }

  Column _buildFormElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildUsername(),
        _buildPassword(),
        _buildForgotPassword(),
        const SizedBox(height: defaultPadding * 2),
        _buildSubmitButton(),
        const SizedBox(height: defaultPadding),
        _buildFooter(),
      ],
    );
  }

  Padding _buildUsername() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: TextFormField(
        // textAlign:
        //     i.isRtl ? TextAlign.start : TextAlign.end, // hintText textDirection
        textDirection: TextDirection
            .ltr, // !i.isRtl ? TextDirection.rtl : TextDirection.ltr,
        initialValue: _authData['username'],
        decoration: InputDecoration(
          hintText: i.tr('Username'),
          prefixIcon: const Icon(Icons.person),
          // label: Text(i.tr('Username')),
          // suffixIcon: Icon(Icons.person),
        ),

        // obscureText: true,
        enabled: !_isLoading,
        // maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        cursorColor: kPrimaryColor,
        validator: (value) {
          if (value!.isEmpty) {
            return i.tr('m8');
          }
          return null;
        },
        onSaved: (value) => _authData['username'] = value!,
      ),
    );
  }

  Padding _buildPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: TextFormField(
        // textAlign:
        //     i.isRtl ? TextAlign.start : TextAlign.end, // hintText textDirection
        textDirection: TextDirection
            .ltr, // !i.isRtl ? TextDirection.rtl : TextDirection.ltr,
        initialValue: _authData['password'],
        decoration: InputDecoration(
          hintText: i.tr('Password'),
          prefixIcon: const Icon(Icons.lock),
          // label: Text(i.tr('Username')),
          suffixIcon: IconButton(
              onPressed: () => setState(() => _isObscure = !_isObscure),
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility)),
        ),

        obscureText: _isObscure,
        enabled: !_isLoading,
        // maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        cursorColor: kPrimaryColor,
        validator: (value) {
          if (value!.isEmpty) {
            return i.tr('m8');
          } else if (value.length < 8) {
            return i.tr('m63');
          }
          return null;
        },

        onSaved: (value) => _authData['password'] = value!,
      ),
    );
  }

  TextButton _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgotPassword');
      },
      child: Text(
        i.tr('Forgot password?'),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SubmitButton _buildSubmitButton() {
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: i.tr('m64'),
        disabledText: i.tr('m65'),
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
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(_authData);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } on HttpException catch (error) {
      var errorMessage = i.tr('m66');
      String e = error.toString();
      if (e.contains('No active account found with the given credentials')) {
        errorMessage = i.tr('m67');
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
      final errorMessage = i.tr('m68');
      Utils.showErrorDialog(context, errorMessage);
    }

    /// Third Note:
    /// if you don't check "mounted" AND use "await" in "Auth" provider the following error show up
    /// setState() called after dispose(),This error might indicate a memory leak
    //if (!mounted) return;
    //setState(() => _isLoading = false);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Column _buildFooter() {
    List<bool> isSelected = [];
    List<String> texts = [i.tr('m69')]; // [i.tr('m69'), i.tr('m70')];
    // if you create NewWidget to "ToggleButtons"
    // @override
    // void initState() {
    //   widget.texts.forEach((e) => isSelected.add(false));
    //   super.initState();
    // }
    for (String e in texts) {
      isSelected.add(false);
    }
    return Column(
      children: [
        AlreadyHaveAnAccountCheck(
          press: () =>
              Navigator.popAndPushNamed(context, RegisterScreen.routeName),
        ),
        ToggleButtons(
          // https://www.youtube.com/watch?v=v2QGS4UqaqA
          isSelected: isSelected,
          color: Colors.black.withOpacity(0.6),
          renderBorder: false,
          // borderRadius: BorderRadius.circular(8.0),
          // splashColor: Colors.orange,
          onPressed: (i) {
            if (!_isLoading) {
              switch (i) {
                case 0:
                  Navigator.pushNamed(context, HelpScreen.routeName);
                  break;
                // case 1:
                //   Navigator.pushNamed(context, RegisterScreen.routeName);
                //   break;

                //   default:
              }
            }
          },

          children: texts
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(e),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
