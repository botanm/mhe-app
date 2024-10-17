import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatefulWidget {
  const ToggleButtonsWidget({
    super.key,
    required this.texts,
    required this.initialSelected,
    required this.selectedHandler,
    required this.isEnabled,
    this.selectedColor = const Color(0xFF6200EE),
    this.borderRadius = 24.0,
    this.stateContained = true,
    this.multipleSelectionsAllowed = true,
    this.canUnToggle = false,
  });

  final List<String> texts;
  final List<bool> initialSelected;
  final Function(int) selectedHandler;
  final bool isEnabled;
  final Color selectedColor;
  final double borderRadius;
  final bool stateContained;
  final bool multipleSelectionsAllowed;
  final bool canUnToggle;

  @override
  _ToggleButtonsWidgetState createState() => _ToggleButtonsWidgetState();
}

class _ToggleButtonsWidgetState extends State<ToggleButtonsWidget> {
  late List<bool> _isSelected;
  @override
  void initState() {
    _isSelected = widget.initialSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ToggleButtonsWidget oldWidget) {
    _isSelected = widget.initialSelected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** toggle_button_widget build ***************');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleButtons(
        color: Colors.black.withOpacity(0.60),
        selectedColor: widget.selectedColor,
        selectedBorderColor: widget.selectedColor,
        fillColor: widget.selectedColor.withOpacity(0.08),
        splashColor: widget.selectedColor.withOpacity(0.12),
        hoverColor: widget.selectedColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        isSelected: _isSelected,
        highlightColor: Colors.transparent,
        borderColor: Colors.black.withOpacity(0.40),
        onPressed: !widget.isEnabled
            ? (index) {}
            : (index) {
                // send callback
                widget.selectedHandler(index);
                // if you wish to have state:
                if (widget.stateContained) {
                  if (!widget.multipleSelectionsAllowed) {
                    final selectedIndex = _isSelected[index];
                    _isSelected = _isSelected.map((e) => e = false).toList();
                    if (widget.canUnToggle) {
                      _isSelected[index] = selectedIndex;
                    }
                  }
                  setState(() {
                    _isSelected[index] = !_isSelected[index];
                  });
                }
              },
        children: widget.texts
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
