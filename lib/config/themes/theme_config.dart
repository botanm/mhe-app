import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

ThemeData theme = ThemeData(
  primaryColor: kPrimaryColor,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: KScaffoldBackgroundColor,

  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     elevation: 0,
  //     backgroundColor: kPrimaryColor,
  //     shape: const StadiumBorder(),
  //     maximumSize: const Size(double.infinity, 56),
  //     minimumSize: const Size(double.infinity, 56),
  //   ),
  // ),
  inputDecorationTheme: const InputDecorationTheme(
    iconColor: kPrimaryColor,
    prefixIconColor: kPrimaryColor,
    labelStyle: TextStyle(color: kPrimaryMediumColor),
    floatingLabelStyle: TextStyle(color: kPrimaryColor),
    contentPadding: EdgeInsets.symmetric(
        horizontal: defaultPadding, vertical: defaultPadding),
    // border: UnderlineInputBorder(),
    // enabledBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: Colors.grey),
    // ),
    // focusedBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: kPrimaryColor),
    // ),
  ),
);
