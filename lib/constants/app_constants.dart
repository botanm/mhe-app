import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

const kPrimaryColor = Colors.blue; //Color(0xFF6F35A5);
const kPrimaryMediumColor = Color(
    0xFF90caf9); //Colors.lightBlue; // Color.fromARGB(255, 156, 118, 190);
const kPrimaryLightColor = Color(0xFFe3f2fd); // Color(0xFFF1E6FF);
const KScaffoldBackgroundColor = Color(0xffF3F2F8);

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

const double defaultPadding = 16.0;
// const LatLng kErbilLatLng = LatLng(36.19113315078098, 44.00934521108866);

const kCircularProgressIndicator = Center(
    child: CircularProgressIndicator.adaptive(
  backgroundColor: kPrimaryLightColor,
  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
  strokeWidth: 2.0,
));

const kBuildAllRoundedRectangleBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13)));

const kBuildTopRoundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(13), topRight: Radius.circular(13)));

// const LatLng kErbilLatLng = LatLng(36.19113315078098, 44.00934521108866);
