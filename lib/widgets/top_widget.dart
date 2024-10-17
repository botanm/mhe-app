import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'image_input.dart';
import 'responsive.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({this.cInitialImagePath, this.aInitialImagePath, super.key});

  final String? cInitialImagePath;
  final String? aInitialImagePath;

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);
    double coverHeight = isMobile ? 80 : (isTablet ? 110 : 140);
    double avatarRadius = isMobile ? 32 : (isTablet ? 64 : 96);

    final bottom = avatarRadius;
    final top = coverHeight - avatarRadius;

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Container(
          //     margin: EdgeInsets.only(bottom: bottom),
          //     child: _buildCoverImage(coverHeight)),
          Container(
              height: coverHeight,
              margin: EdgeInsets.only(bottom: bottom),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        KScaffoldBackgroundColor,
                        kPrimaryLightColor,
                      ])),
              child: SizedBox(
                height: coverHeight,
                width: double.infinity,
              )),
          Positioned(top: top, child: _buildProfileImage(avatarRadius))
        ]);
  }

  Widget _buildCoverImage(double coverHeight) {
    return ImageInput(
      initialImagePathOrObject: cInitialImagePath,
      isCover: true,
      coverHeight: coverHeight,
      coverBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      onTapHandler: (imagePath) {},
      isEnabled: false,
    );
  }

  ImageInput _buildProfileImage(double avatarRadius) => ImageInput(
        initialImagePathOrObject: aInitialImagePath,
        onTapHandler: (imagePath) {},
        avatarRadius: avatarRadius,
        isEnabled: false,
      );
}
