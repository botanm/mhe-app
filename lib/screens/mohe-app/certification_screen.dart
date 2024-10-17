import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../widgets/textformfield_widget.dart';

class CertificationsScreen extends StatefulWidget {
  static const routeName = '/certifications';
  const CertificationsScreen({super.key});

  @override
  State<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends State<CertificationsScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final Map<String, dynamic> info;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetCertifications();
    info = bpr.certifications[0];

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
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
          title: const Text("بڕوانامە"),
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
            _build1,
            _build2,
            _build3,
            _build4,
            _build5,
            _build6,
            _build7,
            _build8,
            _build9,
            _build10,
          ],
        ),
      ),
    );
  }

  TextFormFieldWidget get _build1 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['certificationTypeName'],
      icon: Icons.school, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'جۆری بڕوانامە',
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

  TextFormFieldWidget get _build2 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['educationName'],
      icon: Icons.menu_book, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'زانکۆ',
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

  TextFormFieldWidget get _build3 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['speciality'],
      icon: Icons.location_city, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەش',
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

  TextFormFieldWidget get _build4 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['countryName'],
      icon: Icons.public, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ووڵات',
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

  TextFormFieldWidget get _build5 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['city'],
      icon: Icons.apartment, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'شار',
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

  TextFormFieldWidget get _build6 {
    String dateOnly = info['completedDate'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
      icon: Icons.date_range, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەرواری بەدەست ‌هێنان',
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

  TextFormFieldWidget get _build7 {
    String dateOnly = info['effectiveDate'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
      icon: Icons.date_range, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەرواری شایستەبوون',
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

  TextFormFieldWidget get _build8 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['grade'],
      icon: Icons.emoji_events, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'نمرە',
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

  TextFormFieldWidget get _build9 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['docNo'],
      icon: Icons.insert_drive_file, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ژمارەی نوسراو',
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

  TextFormFieldWidget get _build10 {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['docDate'],
      icon: Icons.date_range, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەرواری نوسراو',
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
