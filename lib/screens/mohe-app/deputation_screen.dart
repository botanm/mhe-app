import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class DeputationScreen extends StatefulWidget {
  static const routeName = '/deputation';
  const DeputationScreen({super.key});

  @override
  State<DeputationScreen> createState() => _DeputationScreenState();
}

class _DeputationScreenState extends State<DeputationScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final List<dynamic> deputations;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetDeputation();
    deputations = bpr.deputations;
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
          title: const Text("شاندکردن"),
        ),
        body: FutureBuilder(
          future: _futureInstance,
          builder: (ctx, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return kCircularProgressIndicator;
            } else if (asyncSnapshot.hasError) {
              return Center(
                  child: Text('An error occurred: ${asyncSnapshot.error}'));
            } else {
              return _buildDisplay();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      itemCount: deputations.length,
      itemBuilder: (ctx, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: deputations[index]['deputationTypeName'],
              onPressed: () {},
            ),
            _buildTextField(
              'بابەت',
              deputations[index]['subject'],
              Icons.topic,
            ),
            _buildTextField('جۆر', deputations[index]['deputationTypeName'],
                Icons.category),
            _buildTextField(
                'بەرواری سەرەتا',
                deputations[index]['startDate'].split(' ')[0],
                Icons.date_range),
            _buildTextField('بەرواری کۆتا',
                deputations[index]['endDate'].split(' ')[0], Icons.date_range),
            _buildTextField('ژمارەی نوسراو', deputations[index]['docNo'],
                Icons.insert_drive_file),
            _buildTextField('بەرواری نوسراو',
                deputations[index]['docDate'].split(' ')[0], Icons.date_range),

            if (deputations[index]['description'] != null)
              _buildTextField('ڕوونکردنەوە', deputations[index]['description'],
                  Icons.announcement_outlined),
            const SizedBox(height: 16), // Add spacing between items
          ],
        );
      },
    );
  }

  TextFormFieldWidget _buildTextField(
      String label, dynamic value, IconData icon) {
    return TextFormFieldWidget(
      isTextRtl: true,
      initialValue: value,
      icon: icon,
      label: label,
      enabled: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      maxLines: null,
      validatorHandler: (val) {
        if (val!.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
    );
  }
}
