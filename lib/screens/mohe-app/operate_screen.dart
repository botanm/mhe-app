import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class OperateScreen extends StatefulWidget {
  static const routeName = '/operate';
  const OperateScreen({super.key});

  @override
  State<OperateScreen> createState() => _OperateScreenState();
}

class _OperateScreenState extends State<OperateScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final List<dynamic> operates;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    await bpr.fetchAndSetOperate();
    operates = bpr.operates;
    // await bpr.fetchAndSetAttendanceStatuses();
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
          title: const Text("دەست بەکاربوونەوە"),
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
      itemCount: operates.length, // Number of items in the list
      itemBuilder: (ctx, index) {
        String dateOnly = operates[index]['date'].split(' ')[0];

        String dastLakarHalgrtn = operates[index]['docDate'].split(' ')[0];
        String h = '${operates[index]['docNo']} لە $dastLakarHalgrtn';

        String dastBakarBunawa =
            operates[index]['operateDocDate'].split(' ')[0];
        String k = '${operates[index]['operateDocNo']} لە $dastBakarBunawa';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: dateOnly,
              onPressed: () {},
            ),

            _buildTextField('بەرواری دەست لەکارهەڵگرتن', dastLakarHalgrtn,
                Icons.date_range),
            _buildTextField('بە نوسراوی', h, Icons.insert_drive_file),

            _buildTextField(
                'بەرواری دەست بەکاربوونەوە', dateOnly, Icons.date_range),
            _buildTextField('بە نوسراوی', k, Icons.insert_drive_file),

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

  String _convertTo12HourFormat(String time) {
    try {
      // Split the input time into hour and minute parts
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      String minute = parts[1];

      // Determine AM or PM
      String period = hour >= 12 ? 'PM' : 'AM';

      // Convert 24-hour time to 12-hour format
      hour = hour % 12;
      if (hour == 0) hour = 12; // Handle midnight (00:00) and noon (12:00)

      return '${hour.toString()}:$minute $period';
    } catch (e) {
      return 'Invalid time format';
    }
  }
}
