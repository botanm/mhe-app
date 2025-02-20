import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class ThanksLetterScreen extends StatefulWidget {
  static const routeName = '/thanksletter';
  const ThanksLetterScreen({super.key});

  @override
  State<ThanksLetterScreen> createState() => _ThanksLetterScreenState();
}

class _ThanksLetterScreenState extends State<ThanksLetterScreen> {
  late final i18n i;
  late final Basics bpr;
  late Future<void> _futureInstance;
  late List<dynamic> info;

  @override
  void initState() {
    super.initState();
    _futureInstance = _getData();
  }

  Future<void> _getData() async {
    bpr = Provider.of<Basics>(context, listen: false);
    await bpr.fetchAndSetThanksLetter();
    info = bpr.thanksLetters;
  }

  @override
  Widget build(BuildContext context) {
    i = Provider.of<i18n>(context, listen: false);

    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ڕێز و سوپاس"),
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
      itemCount: info.length, // Number of items in the list
      itemBuilder: (ctx, index) {
        String dateOnly = info[index]['docDate'].split(' ')[0];
        List<String> dateParts = dateOnly.split('/');
        String month = dateParts[1];
        String year = dateParts[2];
        String monthAndYear = '$month/$year';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: "ڕێز و سوپاس  $monthAndYear",
              onPressed: () {},
            ),
            _buildTextField(
                'ژمارەی نوسراو', info[index]['docNo'], Icons.insert_drive_file),
            _buildTextField('بەرواری نوسراو', dateOnly, Icons.date_range),
            if (info[index]['description'] != null)
              _buildTextField('ڕوونکردنەوە', info[index]['description'],
                  Icons.business_center_outlined),
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
      validatorHandler: (val) {
        if (val!.isEmpty) {
          return i.tr('m8');
        }
        return null;
      },
    );
  }
}
