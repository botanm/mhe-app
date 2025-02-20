import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../widgets/textformfield_widget.dart';

class ScientificTitleScreen extends StatefulWidget {
  static const routeName = '/scientifictitle';
  const ScientificTitleScreen({super.key});

  @override
  State<ScientificTitleScreen> createState() => _ScientificTitleScreenState();
}

class _ScientificTitleScreenState extends State<ScientificTitleScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Map<String, dynamic> info;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetScientificTitle();
    info = bpr.scientificTitles.first;

    return;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);

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
          title: const Text("نازناوی زانستی"),
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
            _buildTitleName,
            _buildEffectiveDate,
            _buildDocNo,
            _buildDocDate,
          ],
        ),
      ),
    );
  }

  TextFormFieldWidget get _buildTitleName {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: info['scientificTitleTypeName'],
      icon: Icons.business_center_outlined, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'ناونیشانی زانستی',
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

  TextFormFieldWidget get _buildEffectiveDate {
    String dateOnly = info['effectiveDate'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
      icon: Icons.date_range, // icon: null is  default
      // suffixIcon: null, // default is null AND for password is configured by default
      label: 'بەرواری شایستە',
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

  TextFormFieldWidget get _buildDocNo {
    String dateOnly = info['docNo'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
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

  TextFormFieldWidget get _buildDocDate {
    String dateOnly = info['docDate'].split(' ')[0];
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: dateOnly,
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
