import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class SwitchWidget extends StatefulWidget {
  final Widget? secondary;
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onToggleHandler;
  final bool enabled;

  const SwitchWidget({
    super.key,
    this.secondary,
    required this.title,
    required this.initialValue,
    required this.onToggleHandler,
    required this.enabled,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool _value;
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
    _value = widget.initialValue;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('*************** switch_widget build ***************');
    return SwitchListTile.adaptive(
      secondary: widget.secondary,
      title: Text((widget.title)),
      value: _value,
      activeColor: kPrimaryColor,
      onChanged: widget.enabled
          ? (value) {
              setState(
                () => _value = value,
              );
              widget.onToggleHandler(value);
            }
          : null,
      dense: true,
    );
  }
}
