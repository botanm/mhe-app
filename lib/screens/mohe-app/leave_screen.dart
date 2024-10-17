import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/core.dart';
import '../../providers/i18n.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/textformfield_widget.dart';

class LeaveScreen extends StatefulWidget {
  static const routeName = '/leave';
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  late final List<dynamic> leaves;
  late final Map<String, dynamic> leaveStatistic;

  late Future<void> _futureInstance;

  Future<void> _getData() async {
    String leaveTypeId = "";
    DateTime current = DateTime.now();
    DateTime startDate = DateTime(current.year, current.month, 01);
    DateTime startDate0 =
        DateTime(current.year, current.month, current.day - 30);
    DateTime endDate = DateTime(current.year, startDate.month, current.day);

    await bpr.fetchAndSetLeave(startDate0, endDate, leaveTypeId);
    leaves = bpr.leaves;
    // await bpr.fetchAndSetAttendanceStatuses();
    await bpr.fetchAndSetLeaveStatistic();
    leaveStatistic = bpr.leaveStatistic;
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
          title: const Text("مۆڵەت و باڵانس"),
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
      itemCount: leaves.length + 1, // Add 1 to the count for the ListTile
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return _buildHeader();
        }

        // Adjust the index for the list items
        int adjustedIndex = index - 1;

        String startDate = leaves[adjustedIndex]['startDate'].split(' ')[0];
        String endDate = leaves[adjustedIndex]['endDate'].split(' ')[0];
        List<String> dateParts = startDate.split('/');
        String day = dateParts[0];
        String month = dateParts[1];

        String dayAndmonth = '$day/$month';
        double daysRequested = leaves[adjustedIndex]['daysRequested'];
        String requestAmount = daysRequested == daysRequested.toInt()
            ? daysRequested.toInt().toString()
            : daysRequested.toString();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientButton(
              text: dayAndmonth,
              onPressed: () {},
            ),
            _buildTextField('جۆری مۆڵەت',
                leaves[adjustedIndex]['leaveTypeName'], Icons.merge_type),
            _buildTextField('دەست لەکارهەڵگرتن', startDate, Icons.date_range),
            _buildTextField('دەست بەکاربوون', endDate, Icons.date_range),
            _buildTextField(
                'ماوەی مۆڵەت',
                '$requestAmount ${leaves[adjustedIndex]['leaveTimeTypeName']}',
                Icons.schedule),
            _buildTextField('هۆکار', leaves[adjustedIndex]['reason'],
                Icons.announcement_outlined),
            const SizedBox(height: 16), // Add spacing between items
          ],
        );
      },
    );
  }

  Card _buildHeader() {
    return Card(
      // elevation: 4, // Gives a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.all(16), // Adds some space around the card
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
                colors: [KScaffoldBackgroundColor, kPrimaryLightColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.all(16), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'پوختەی باڵانس',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Bold title
                ),
              ),
              const SizedBox(height: 12), // Space between title and data
              _buildDataRow(
                  'کۆی باڵانس:', leaveStatistic['leaveIn'].toInt().toString()),
              const SizedBox(height: 8), // Space between rows
              _buildDataRow('کۆی وەرگیراو:',
                  leaveStatistic['leaveOut'].toInt().toString()),
              const SizedBox(height: 8), // Space between rows
              _buildDataRow(
                  'ماوە:', leaveStatistic['total'].toInt().toString()),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build each row in the card
  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Semi-bold for the labels
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Normal weight for the values
            color: Colors.blueAccent, // Color to distinguish the value
          ),
        ),
      ],
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
