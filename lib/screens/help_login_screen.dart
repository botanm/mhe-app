import 'package:flutter/material.dart';

class HelpLoginScreen extends StatelessWidget {
  static const routeName = '/helpLogin';
  const HelpLoginScreen({super.key});
  static const Icon forwardIcon = Icon(Icons.arrow_forward_ios);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Hi'),
        centerTitle: true,
        elevation: 20.2,
      ),
      body: ElevatedButton(
        onPressed: () {},
        child: const Text('Hi'),
      ),
    );
  }
}
