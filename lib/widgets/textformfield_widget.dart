import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.isTextRtl,
    required this.initialValue,
    this.icon,
    this.suffixIcon,
    required this.label,
    required this.enabled,
    this.maxLines,
    required this.keyboardType,
    required this.textInputAction,
    this.onChangedHandler,
    this.onSavedHandler,
    this.autovalidateMode,
    required this.validatorHandler,
    this.is_password = false,
  });

  final bool isTextRtl;
  final String initialValue;
  final IconData? icon;
  final IconButton? suffixIcon;
  final String label;
  final bool enabled;
  final int? maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(dynamic value)? onChangedHandler;
  final ValueChanged<dynamic>? onSavedHandler;
  final AutovalidateMode? autovalidateMode;
  final String? Function(dynamic value) validatorHandler;
  final bool is_password;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _isVisible = true;
  late final i18n i;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: widget.isTextRtl == i.isRtl ? TextAlign.start : TextAlign.end,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        icon: widget.icon != null
            ? Icon(widget.icon)
            : const SizedBox(
                height: 24.0, width: 24.0), // default flutter icon size is 24.0
        label: Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Plex Sans Regular',
          ),
        ),
        suffixIcon: _suffixIcon,
        border: widget.maxLines != null && widget.maxLines! > 2
            ? const OutlineInputBorder()
            : const UnderlineInputBorder(),
        // border: const UnderlineInputBorder(),
        enabledBorder: widget.maxLines != null && widget.maxLines! > 2
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryMediumColor),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
        focusedBorder: widget.maxLines != null && widget.maxLines! > 2
            ? const OutlineInputBorder()
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
      ),
      enabled: widget.enabled,
      maxLines: widget.is_password ? 1 : widget.maxLines,
      obscureText: widget.is_password ? _isVisible : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validatorHandler,
      onChanged: widget.onChangedHandler,
      onSaved: widget.onSavedHandler,
    );
  }

  IconButton? get _suffixIcon {
    return widget.is_password
        ? IconButton(
            onPressed: _toggleVisibility,
            icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility))
        : widget.suffixIcon;
  }

  void _toggleVisibility() {
    setState(() => _isVisible = !_isVisible);
  }
}
