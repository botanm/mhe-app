import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/auth.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../widgets/textformfield_widget.dart';

class MeScreen extends StatefulWidget {
  static const routeName = '/me';
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Auth apr;
  late final Core cpr;
  late final Map<String, dynamic> info;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    info = apr.me!;

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      apr = Provider.of<Auth>(context);
      cpr = Provider.of<Core>(context);

      _futureInstance = _getData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("زانیاری کەسی"),
        ),
        body: FutureBuilder(
            future: _futureInstance,
            builder: (ctx, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return kCircularProgressIndicator;
              } else {
                if (asyncSnapshot.hasError) {
                  // ...
                  // Do error handling stuff
                  return Center(child: Text('${asyncSnapshot.error}'));
                  //return Center(child: Text('An error occurred!'));
                } else {
                  return _buildDispaly();
                }
              }
            }),
      ),
    );
  }

  SingleChildScrollView _buildDispaly() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Column(
          children: [
            _buildBiometricCode,
            _buildFingerprintCode,
            _buildProfileCode,
            _buildNameKu,
            _buildNameEn,
            _buildEmail,
            _buildPhone,
            _buildOrganization,
            _buildHireNo,
            _buildHireDate,
            _buildScientificTitle,
            _buildJobTitle,
            // _build9,
            // _build10,
          ],
        ),
      ),
    );
  }

  TextFormFieldWidget get _buildBiometricCode {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['biometricCode'],
      icon: Icons.confirmation_number_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'کۆدی بایۆمەتری',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildFingerprintCode {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['code'],
      icon: Icons.fingerprint, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'کۆد',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildNameKu {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['fullNameKu'],
      icon: Icons.person_outline, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ناو بە کوردی',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildNameEn {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: info['fullNameEn'],
      icon: Icons.person_outline, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ناو بە ئینگلیزی',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildEmail {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: info['email'],
      icon: Icons.email_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ئیمەیڵ',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildPhone {
    return TextFormFieldWidget(
      isTextRtl: false,
      initialValue: info['cellPhoneNo'],
      icon: Icons.phone_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'مۆبایل',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildProfileCode {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['profileCode'],
      icon: Icons.badge_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ژمارەی دۆسیە',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildOrganization {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['organization'],
      icon: Icons.apartment_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'شوێنی کارکردن',
      enabled: false,
      maxLines: 5,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildHireNo {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['hireNo'],
      icon: Icons.file_copy_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ژمارە نوسراوی دامەزراندن',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildHireDate {
    String dateOnly = info['hireDate'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
      icon: Icons.date_range, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەرواری دامەزراندن',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildScientificTitle {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['scientificTitleTypeName'] ?? '',
      icon: Icons.business_center_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'نازناوی زانستی',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }

  TextFormFieldWidget get _buildJobTitle {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['lastJobTitle'] ?? '',
      icon: Icons.trending_up, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ناونیشان',
      enabled: false,
      // maxLines: 1,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validatorHandler: (value) {
        if (value.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
      // onSavedHandler: (value) => _formData['name'] = value,
    );
  }
}
