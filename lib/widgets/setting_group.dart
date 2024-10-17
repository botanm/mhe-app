import 'package:flutter/cupertino.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingsGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    // print('*************** setting_group build ***************');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildTitle(), ...children],
    );
  }

  Widget buildTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title),
      );
}
