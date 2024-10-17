import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/auth.dart';
import '../../../../../providers/basics.dart';
import '../providers/core.dart';
import '../../../../../providers/i18n.dart';
import '../../../../../utils/services/http_exception.dart';
import '../../../../../utils/utils.dart';

import '../../../../../widgets/submit_button.dart';
import 'icon_widget.dart';
import 'image_input.dart';
import 'increase_decrease_spinner.dart';
import 'location_input.dart';
import 'switch_widget.dart';
import 'textformfield_widget.dart';

class AnswererProfileForm extends StatefulWidget {
  const AnswererProfileForm({
    super.key,
  });

  @override
  _AnswererProfileFormState createState() => _AnswererProfileFormState();
}

class _AnswererProfileFormState extends State<AnswererProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  static const SizedBox _12 = SizedBox(height: 12);
  static const SizedBox _24 = SizedBox(height: 24);
  static const SizedBox _32 = SizedBox(height: 32);

  Map<String, dynamic> _profileData = {
    "id": null,
    "user": null,
    "loc_lat": null,
    "loc_long": null,
    "is_show_loc": true,
    "is_show_phone": true,
    "question_threshold": 0,
    "about": "",
    "ckb_about": "",
    "kmr_about": "",
    "bad_about": "",
    "ar_about": "",
    "avatar": null,
    "cover_image": null,
    "youtube": null,
    "facebook": null,
    "instagram": null,
  };
  final double coverHeight = 280;
  final double avatarRadius = 64;

  bool _isInit = true;
  bool _isLoading = false;

  late final Map<String, dynamic>? _me;

  late final i18n i;
  late final Auth apr;
  late final Basics bpr;
  late final Core cpr;

  // late final List<dynamic> _privileges;
  // late final List<String> _maSecBasicName;

  List<bool> _isVal = [true, true]; //avatar,cover_image

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context, listen: false);

      // _privileges = bpr.privileges;
      // _maSecBasicName = i.maSecBasicName;
      _me = apr.me;

      if (_me != null && _me['AnswererProfile'] != null) {
        final Map<String, dynamic> editedResearcherProfile =
            _me['AnswererProfile'];

        _profileData = {
          "id": editedResearcherProfile['id'],
          "user": editedResearcherProfile['user'],
          "loc_lat": editedResearcherProfile['loc_lat'] == null
              ? null
              : double.parse(editedResearcherProfile['loc_lat']),
          "loc_long": editedResearcherProfile['loc_long'] == null
              ? null
              : double.parse(editedResearcherProfile['loc_long']),
          "is_show_loc": editedResearcherProfile['is_show_loc'],
          "is_show_phone": editedResearcherProfile['is_show_phone'],
          "question_threshold": editedResearcherProfile['question_threshold'],
          "about": editedResearcherProfile['about'],
          "ckb_about": editedResearcherProfile['ckb_about'],
          "kmr_about": editedResearcherProfile['kmr_about'],
          "bad_about": editedResearcherProfile['bad_about'],
          "ar_about": editedResearcherProfile['ar_about'],
          "avatar": editedResearcherProfile['avatar'],
          "cover_image": editedResearcherProfile['cover_image'],
          "notes": editedResearcherProfile['notes'],
          "youtube": editedResearcherProfile['youtube'],
          "facebook": editedResearcherProfile['facebook'],
          "instagram": editedResearcherProfile['instagram'],
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     answerer_profile_form build     ++++++++++++++++++++++++');
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
  //     title: Text(i.tr(bpr.userId == editedResearcherProfile!['id'] ? 'm29' : 'm30'),
  //         style: const TextStyle(color: Colors.black)),
  //     elevation: 0,
  //     backgroundColor: const Color(0xffF3F2F8),
  //   );
  // }

  Column _buildFormElements() {
    return Column(
      children: [
        _buildTop,
        _24,
        _buildThreshold,
        _12,
        _buildBioCkb,
        _12,
        _buildBioKmr,
        _12,
        _buildBioBad,
        _12,
        _buildBioEn,
        _12,
        _buildBioAr,
        _12,
        _buildYoutube,
        _12,
        _buildFacebook,
        _12,
        _buildInstagram,
        _12,
        _buildShowPhoneSwitch,
        _12,
        _buildShowLocSwitch,
        _32,
        _buildLocation,
        _12,
        _buildSubmitButton,
        _12,
      ],
    );
  }

  Widget get _buildTop {
    const double coverHeight = 140;
    const double avatarRadius = 80;

    const bottom = avatarRadius;
    const top = coverHeight - avatarRadius;

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: bottom),
              child: _buildCoverImage(coverHeight)),
          Positioned(top: top, child: _buildAvatarImage(avatarRadius))
        ]);
  }

  Widget _buildCoverImage(double coverHeight) {
    return ImageInput(
      initialImagePathOrObject: _profileData['cover_image'],
      isCover: true,
      coverHeight: coverHeight,
      // coverBorderRadius: const BorderRadius.only(
      //     topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      onTapHandler: (imagePath) => _profileData['cover_image'] = imagePath,
      isEnabled: true,
      isValidated: _isVal[1],
    );
  }

  ImageInput _buildAvatarImage(double avatarRadius) => ImageInput(
        initialImagePathOrObject: _profileData['avatar'],
        onTapHandler: (imagePath) => _profileData['avatar'] = imagePath,
        avatarRadius: avatarRadius,
        isEnabled: true,
        isValidated: _isVal[0],
      );

  IncreaseDecreaseSpinner get _buildThreshold {
    return IncreaseDecreaseSpinner(
      title: i.tr('m43'),
      initialValue: _profileData['question_threshold'],
      onChangedHandler: (value) => _profileData['question_threshold'] = value,
      isEnabled: !_isLoading,
    );
  }

  TextFormFieldWidget get _buildBioCkb {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _profileData['ckb_about'],
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
        } else if (value.length > 3000) {
          return i.tr('m85');
        }
        return null;
      },
      onSavedHandler: (value) => _profileData['ckb_about'] = value,
    );
  }

  TextFormFieldWidget get _buildBioKmr {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _profileData['kmr_about'],
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
        } else if (value.length > 3000) {
          return i.tr('m85');
        }
        return null;
      },
      onSavedHandler: (value) => _profileData['kmr_about'] = value,
    );
  }

  TextFormFieldWidget get _buildBioBad {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _profileData['bad_about'],
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
        } else if (value.length > 3000) {
          return i.tr('m85');
        }
        return null;
      },
      onSavedHandler: (value) => _profileData['bad_about'] = value,
    );
  }

  TextFormFieldWidget get _buildBioEn {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _profileData['about'],
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
        } else if (value.length > 3000) {
          return i.tr('m85');
        }
        return null;
      },
      onSavedHandler: (value) => _profileData['about'] = value,
    );
  }

  TextFormFieldWidget get _buildBioAr {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: _profileData['ar_about'],
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
        } else if (value.length > 3000) {
          return i.tr('m85');
        }
        return null;
      },
      onSavedHandler: (value) => _profileData['ar_about'] = value,
    );
  }

  TextFormFieldWidget get _buildFacebook {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _profileData['facebook'] ?? '',
      icon: Icons.link, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Facebook'),
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
      onSavedHandler: (value) => _profileData['facebook'] = value,
    );
  }

  TextFormFieldWidget get _buildInstagram {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _profileData['instagram'] ?? '',
      icon: Icons.link, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Instagram'),
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
      onSavedHandler: (value) => _profileData['instagram'] = value,
    );
  }

  TextFormFieldWidget get _buildYoutube {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: _profileData['youtube'] ?? '',
      icon: Icons.link, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: i.tr('Youtube'),
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
      onSavedHandler: (value) => _profileData['youtube'] = value,
    );
  }

  SwitchWidget get _buildShowPhoneSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.visibility,
        color: Colors.black26,
      ),
      title: i.tr('Show phone'),
      initialValue: _profileData['is_show_phone'],
      onToggleHandler: (bool value) {
        _profileData['is_show_phone'] = value;
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

  SwitchWidget get _buildShowLocSwitch {
    return SwitchWidget(
      secondary: const IconWidget(
        icon: Icons.visibility,
        color: Colors.black26,
      ),
      title: i.tr('Show location'),
      initialValue: _profileData['is_show_loc'],
      onToggleHandler: (bool value) {
        _profileData['is_show_loc'] = value;
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

  LocationInput get _buildLocation {
    final Map<String, double>? iLD = _profileData['loc_lat'] == null
        ? null
        : {'lat': _profileData['loc_lat'], 'long': _profileData['loc_long']};
    return LocationInput(
      initialLocData: iLD,
      onSetLocationHandler: (ld) {
        _profileData['loc_lat'] = ld['lat'];
        _profileData['loc_long'] = ld['long'];
      },
      // editLocationAllowed: true, // default
      // title: 'Pick location', // default
      isEnabled: !_isLoading,
    );
  }

  SubmitButton get _buildSubmitButton {
    String text = i.tr(_profileData['id'] == null ? 'Register' : 'Edit');
    String disabledText =
        _profileData['id'] == null ? 'Registering' : 'Editing';
    return SubmitButton(
        isSubmitButtonDisabled: _isLoading,
        text: text,
        disabledText: disabledText,
        onPressedHandler: _onSubmit);
  }

  Future<void> _onSubmit() async {
    _isVal = [
      _profileData['avatar'] != null,
      _profileData['cover_image'] != null,
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
      bool isSuccess = await cpr.editResearcherProfile(_profileData);
      if (isSuccess) {
        await apr.fetchAndSetMe();
      }
      Navigator.of(context).pop(); // to pop off in the navigator
    } on HttpException catch (error) {
      var errorMessage = i.tr(_profileData['id'] == null ? 'm59' : 'm58');
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
      var errorMessage = i.tr(_profileData['id'] == null ? 'm46' : 'm14');
      Utils.showErrorDialog(context, errorMessage);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
