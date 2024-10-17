import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder? largeMobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? largeTablet;
  final WidgetBuilder desktop;
  final WidgetBuilder? largeDesktop;

  static const Map<String, int> breakpoints = {
    'mobile': 360,
    'largeMobile': 576,
    'tablet': 750,
    'largeTablet': 1024,
    'desktop': 1200,
    'largeDesktop': 1536,
  };

  const Responsive({
    super.key,
    required this.mobile,
    this.largeMobile,
    this.tablet,
    this.largeTablet,
    required this.desktop,
    this.largeDesktop,
  });

  static String getDeviceType(BuildContext context) {
    final int width = MediaQuery.of(context).size.width.toInt();
    final String deviceType = breakpoints.entries
        .firstWhere((entry) => width < entry.value,
            orElse: () => breakpoints.entries.last)
        .key;
    return deviceType;
  }

  static Size s(BuildContext context) => MediaQuery.of(context).size;
  static double h(BuildContext context) => MediaQuery.of(context).size.height;
  static double w(BuildContext context) => MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == 'mobile';

  static bool isLargeMobile(BuildContext context) =>
      getDeviceType(context) == 'largeMobile';

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == 'tablet';

  static bool isLargeTablet(BuildContext context) =>
      getDeviceType(context) == 'largeTablet';

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == 'desktop';

  static bool isLargeDesktop(BuildContext context) =>
      getDeviceType(context) == 'largeDesktop';

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        // To improve performance, you can use a Builder widget to rebuild only the widget that is currently being displayed.
        final String deviceType = getDeviceType(context);
        if (deviceType == 'largeDesktop' && largeDesktop != null) {
          return largeDesktop!(context);
        } else if (deviceType == 'desktop') {
          return desktop(context);
        } else if (deviceType == 'largeTablet' && largeTablet != null) {
          return largeTablet!(context);
        } else if (deviceType == 'tablet' && tablet != null) {
          return tablet!(context);
        } else if (deviceType == 'largeMobile' && largeMobile != null) {
          return largeMobile!(context);
        } else {
          return mobile(context);
        }
      },
    );
  }
}
// class Responsive extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget desktop;

//   const Responsive({
//     Key? key,
//     required this.mobile,
//     this.tablet,
//     required this.desktop,
//   }) : super(key: key);

//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 576;

//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 576 &&
//       MediaQuery.of(context).size.width <= 992;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width > 992;

//   static Size s(BuildContext context) => MediaQuery.of(context).size;
//   static double h(BuildContext context) => MediaQuery.of(context).size.height;
//   static double w(BuildContext context) => MediaQuery.of(context).size.width;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     if (size.width > 992) {
//       return desktop;
//     } else if (size.width >= 576 && tablet != null) {
//       return tablet!;
//     } else {
//       return mobile;
//     }
//   }
// }
