import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'menu_picker.dart';

class NumberMenuPicker extends StatelessWidget {
  @override
  const NumberMenuPicker({
    super.key,
    required this.firstNo,
    required this.lastNo,
    this.descending = false,
    required this.initialSelected,
    this.multipleSelectionsAllowed = false,
    required this.text,
    required this.onSelectedHandler,
    required this.isEnabled,
    required this.isValidated,
  });

  final int firstNo;
  final int lastNo;
  final bool descending;
  final List<dynamic> initialSelected;
  final bool multipleSelectionsAllowed;
  final String text;
  final Function(dynamic value) onSelectedHandler;
  final bool isEnabled;
  final bool isValidated;

  @override
  Widget build(BuildContext context) {
    List<dynamic> container = List.generate(lastNo - firstNo, (index) {
      final int i = firstNo + index;
      return {"id": i, "name": i.toString()};
    });

    if (descending) {
      // Sort the list of maps in descending order by the value of the `id` key.
      container.sort((m1, m2) => m2['id'].compareTo(m1['id']));
    }

    return MenuPicker(
      allElements: container,
      maSecName: const ['name', 'name'],
      initialSelected: initialSelected,
      multipleSelectionsAllowed: multipleSelectionsAllowed,
      selectedHandler: (value) {
        onSelectedHandler(value);
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: text,
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: text,
      searchVisible: true,
      isSecondaryVisible: false,
      isEnabled: isEnabled,
      isValidated: isValidated,
    );
  }
}
