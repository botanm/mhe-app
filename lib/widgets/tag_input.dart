import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/i18n.dart';
import 'textformfield_widget.dart';

class TagInput extends StatefulWidget {
  const TagInput({
    super.key,
    required this.tagsPointer,
    required this.tagText,
    this.icon,
    required this.isEnabled,
    required this.validatorHandler,
  });
  final List<String> tagsPointer;
  final String tagText;
  final IconData? icon;
  final bool isEnabled;
  final String? Function(dynamic) validatorHandler;

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  late final i18n i;
  late List<String> _tags;
  @override
  void initState() {
    i = Provider.of<i18n>(context, listen: false);
    _tags = widget.tagsPointer;

    super.initState();
  }

  @override
  void didUpdateWidget(TagInput oldWidget) {
    _tags = widget.tagsPointer;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** phone_input build ***************');
    return Column(
      /// It causes the whole Column to rebuild itself from scratch but only when the length on your phones changes.
      /// WITHOUT the key, UI would not be updated correctly when removing an element
      key: Key(_tags.length.toString()),
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int j = 0; j < _tags.length; j++)
          TextFormFieldWidget(
            isTextRtl: false,
            initialValue: _tags[j],
            icon: widget.icon, // icon: null is  default
            // suffixIcon: null, // default is null AND for password is configured by default
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _tags.removeAt(j));
                },
                icon: const Icon(Icons.delete_forever_outlined)),
            label: '${widget.tagText} ${j + 1}',
            enabled: widget.isEnabled,
            // maxLines: 1,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validatorHandler: widget.validatorHandler,

            onChangedHandler: (value) => _tags[j] =
                value, // "onChangedHandler" not "onSavedHandler", to "add button" work
          ),
        IconButton(
          onPressed: () {
            if (_tags.isEmpty || _tags.last.isNotEmpty && widget.isEnabled) {
              setState(() => _tags.add(''));
            }
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}
