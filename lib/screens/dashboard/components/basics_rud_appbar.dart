import 'package:flutter/material.dart';

class BasicsRUDAppBar extends StatelessWidget {
  const BasicsRUDAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    // print('*************** basics_rud_appbar build ***************');
    return AppBar(
      // leading: IconButton(
      //   icon: const Icon(Icons.close, color: Colors.black),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      iconTheme: const IconThemeData(
        color: Colors.black, //change leading icon color
      ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      elevation: 0,
      backgroundColor: const Color(0xffF3F2F8),
    );
  }
}
