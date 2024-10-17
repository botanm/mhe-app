import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class IncreaseDecreaseSpinner extends StatefulWidget {
  const IncreaseDecreaseSpinner(
      {required this.title,
      required this.onChangedHandler,
      this.initialValue = 2,
      required this.isEnabled,
      super.key})
      : assert(initialValue >= 0);

  final String title;
  final int initialValue;
  final Function(int) onChangedHandler;
  final bool isEnabled;

  @override
  State<IncreaseDecreaseSpinner> createState() =>
      _IncreaseDecreaseSpinnerState();
}

class _IncreaseDecreaseSpinnerState extends State<IncreaseDecreaseSpinner> {
  late int _count;
  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** increase_decrease_spinner build ***************');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.small(
              heroTag:
                  'increaseBtn', // you must assign it with different value, if you have more than one "FloatingActionButton" in the same screen
              onPressed: () {
                if (widget.isEnabled) {
                  setState(() {
                    _count += 1;
                  });
                  widget.onChangedHandler(_count);
                }
              },
              backgroundColor: kPrimaryColor,
              child: const Icon(
                Icons.add,
                color: KScaffoldBackgroundColor,
              ),
            ),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryLightColor,
                  child: Text(_count.toString(),
                      style: const TextStyle(
                          color: kPrimaryColor, fontSize: 24.0)),
                ),
                const SizedBox(height: 40),
              ],
            ),
            FloatingActionButton.small(
              heroTag: 'decreaseBtn',
              onPressed: () {
                if (_count > 0 && widget.isEnabled) {
                  setState(() {
                    _count -= 1;
                  });
                  widget.onChangedHandler(_count);
                }
              },
              backgroundColor: kPrimaryColor,
              child: const Icon(
                Icons.remove,
                color: KScaffoldBackgroundColor,
              ),
            ),
          ],
        ),
        Text(widget.title),
      ],
    );
  }
}
