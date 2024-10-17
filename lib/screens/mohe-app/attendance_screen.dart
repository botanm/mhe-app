import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/attendance';
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final List<dynamic> attendances;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    String statusId = "";
    DateTime current = DateTime.now();
    DateTime startDate = DateTime(current.year, current.month, 01);
    DateTime startDate0 =
        DateTime(current.year, current.month, current.day - 30);
    DateTime endDate = DateTime(current.year, startDate.month, current.day);

    await bpr.fetchAndSetAttendance(startDate0, endDate, statusId);
    attendances = bpr.attendance;
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
          title: const Text("ئامادەبوون"),
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
      itemCount: attendances.length, // Number of items in the list
      itemBuilder: (ctx, index) {
        String dateOnly = attendances[index]['date'].split(' ')[0];
        List<String> dateParts = dateOnly.split('/');
        String day = dateParts[0];
        String month = dateParts[1];

        String dayAndmonth = '$day/$month';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: dayAndmonth,
              onPressed: () {},
            ),
            _buildTextField('بار', attendances[index]['status'],
                Icons.info_outline_rounded),
            _buildTextField('بەروار', dateOnly, Icons.date_range),
            if (attendances[index]['leaveRequest'] != null)
              _buildTextField('ماوەی مۆڵەت', attendances[index]['leaveRequest'],
                  Icons.business_center_outlined),
            if (attendances[index]['checkIn'].toString().trim() != '00:00')
              _buildTextField(
                  'کاتی هاتن',
                  _convertTo12HourFormat(
                      attendances[index]['checkIn'].toString().trim()),
                  Icons.login_outlined),
            if (attendances[index]['checkIn'].toString().trim() != '00:00')
              _buildTextField(
                  'کاتی چوونەدەرەوە',
                  _convertTo12HourFormat(
                      attendances[index]['checkOut'].toString().trim()),
                  Icons.logout),
            if (attendances[index]['workingHours'].toString().trim() != '00:00')
              _buildTextField(
                  'ماوەی دەوامکردن',
                  attendances[index]['workingHours'].toString().trim(),
                  Icons.access_time_outlined),
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
