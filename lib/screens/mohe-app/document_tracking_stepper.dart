import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';

class DocumentTrackingStepper extends StatefulWidget {
  const DocumentTrackingStepper({
    Key? key,
  }) : super(key: key);

  @override
  _DocumentTrackingStepperState createState() =>
      _DocumentTrackingStepperState();
}

class _DocumentTrackingStepperState extends State<DocumentTrackingStepper> {
  List<dynamic> _trackingData = [];
  int _currentStep = 0;
  late final Basics bpr;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      bpr = Provider.of<Basics>(context);
    }
    _updateTrackingData();
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateTrackingData() {
    // setState(() {
    _trackingData = bpr.searchedDocTrackingData;
    _currentStep = _trackingData.isNotEmpty ? _trackingData.length - 1 : 0;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '++++++++++++++++++++++++     DocumentTrackingStepper build     ++++++++++++++++++++++++');
    if (_trackingData.isEmpty) {
      return const Column(
        children: [
          Text(
            "تکایە زانیاری داخل بکە بۆ بەدواداچوون",
            style: TextStyle(
              fontFamily: 'Plex Sans Regular',
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    }

    final bool lastStepIncomplete = !_isLastStepComplete();
    final Color primaryColor =
        lastStepIncomplete ? kPrimaryColor : Colors.green;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            secondary: Colors.orange,
          ),
        ),
        child: Column(
          children: [
            Stepper(
              physics: const ClampingScrollPhysics(),
              key: ValueKey(
                  _trackingData.length), // Force new widget when list changes
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              steps: _trackingData.asMap().entries.map((entry) {
                // Reverse trackingData here
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                return _buildStep(item, index, primaryColor);
              }).toList(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return const SizedBox.shrink();
              },
            ),
            _buildFooter(_trackingData.first),
          ],
        ),
      ),
    );
  }

  Step _buildStep(Map<String, dynamic> item, int index, Color primaryColor) {
    bool isLastStep = index == _trackingData.length - 1;
    bool isComplete = item['status'] == "تەواوبووەکان";
    StepState stepState =
        (isLastStep && !isComplete) ? StepState.indexed : StepState.complete;

    String periodText = _buildPeriod(item);

    return Step(
      title: Text(
        item['fromOrganization'],
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontFamily: 'Plex Sans Regular'),
      ),
      subtitle: Text(
        periodText,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: 'Plex Sans Regular',
        ),
        textDirection: TextDirection.rtl,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [],
          ),
          Text(
            "لە: ${item['fromDate'].substring(0, 16)} ",
            style: const TextStyle(
              color: Colors.black54,
              fontFamily: 'Plex Sans Regular',
            ),
            textDirection: TextDirection.rtl,
          ),
          Text(
            "نێردرا بۆ: ${item['toOrganization']}",
            style: const TextStyle(
              color: Colors.black54,
              fontFamily: 'Plex Sans Regular',
            ),
          ),
        ],
      ),
      isActive: !(isLastStep && !isComplete),
      state: stepState,
    );
  }

  String _buildPeriod(Map<String, dynamic> item) {
    final intl.DateFormat dateFormat = intl.DateFormat("dd/MM/yyyy HH:mm:ss");
    final DateTime fromDate = dateFormat.parse(item['fromDate']);
    final DateTime toDate = dateFormat.parse(item['toDate']);
    final Duration difference = toDate.difference(fromDate);
    final int d = difference.inDays; // Number of days
    final int h =
        difference.inHours % 24; // Number of hours (remainder after days)
    final int m =
        difference.inMinutes % 60; // Number of minutes (remainder after hours)
    final String dayText = d == 0 ? "" : "$d ڕۆژ";
    final String hourText = h == 0 ? "" : "$h کاژێر";
    final String andText = (d != 0 && h != 0) ? " و " : "";
    final String periodText = (d != 0 && h != 0)
        ? "ماوەی $dayText $andText $hourText"
        : "تەنها $m دەقیقە";
    return periodText;
  }

  Card _buildFooter(Map<String, dynamic> item) {
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
                'پوختە',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontFamily: 'Plex Sans Bold',
                ),
              ),
              const SizedBox(height: 12),
              _buildDataRow('ژمارەی نوسراو :', item['refNo']),
              const SizedBox(height: 8),
              _buildDataRow('ژمارەی وەرگیراو :', item['docNo']),
              const SizedBox(height: 8),
              _buildDataRow('بابەت :', item['subject']),
              const SizedBox(height: 8),
              _buildDataRow('شوێن:', item['locationName']),
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
            fontFamily: 'Plex Sans Bold',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.w400, // Normal weight for the values
              fontFamily: 'Plex Sans Regular',
              color: Colors.blueAccent, // Color to distinguish the value
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String cssClass) {
    switch (cssClass) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  bool _isLastStepComplete() {
    return _trackingData.last['status'] == "تەواوبووەکان";
  }
}
