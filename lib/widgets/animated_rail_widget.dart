import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class AnimatedRailWidget extends StatelessWidget {
  const AnimatedRailWidget(
      {super.key, required this.child, required this.press});

  final Function() press;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = NavigationRail.extendedAnimation(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => SizedBox(
        height: 56,
        child: Container(
          // padding: EdgeInsets.only(
          //   right: lerpDouble(0, 200, animation.value)!,
          // ),// to leading alignment
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: FloatingActionButton.extended(
            onPressed: press,
            label: child!,
            // isExtended: animation.status != AnimationStatus.dismissed,
            backgroundColor: kPrimaryColor,
          ),
        ),
      ),
      child: child,
    );
  }
}
