import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'image_input.dart'; // Import your ImageInput widget

class TopImageSection extends StatelessWidget {
  final Map<String, dynamic> formData;
  final double coverHeight;
  final ValueChanged<dynamic> onTapHandler;

  const TopImageSection({
    super.key,
    required this.formData,
    this.coverHeight = 140,
    required this.onTapHandler,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 80;
    const double variation = 30;

    const bottom = avatarRadius;
    double top = (coverHeight - avatarRadius) + variation;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: bottom),
          child: _buildCoverImage(coverHeight),
        ),
        Positioned(
          top: top,
          child: _buildImage1Image2(coverHeight - variation),
        ),
      ],
    );
  }

  Widget _buildCoverImage(double coverHeight) {
    return ImageInput(
      initialImagePathOrObject: formData['image0'],
      isCover: true,
      coverHeight: coverHeight,
      coverBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      onTapHandler: (image) =>
          onTapHandler({'imageKey': 'image0', 'image': image}),
      isEnabled: true,
      isValidated: formData['isVal0'],
    );
  }

  Widget _buildImage1Image2(double coverHeight) {
    return Row(
      children: [
        _buildImage1(coverHeight),
        const SizedBox(width: defaultPadding),
        _buildImage2(coverHeight)
      ],
    );
  }

  Widget _buildImage1(double coverHeight) {
    return SizedBox(
      width: coverHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            width: 1,
            color: kPrimaryColor,
          ),
        ),
        child: ImageInput(
          initialImagePathOrObject: formData['image1'],
          isCover: true,
          coverHeight: coverHeight,
          coverBorderRadius: const BorderRadius.all(Radius.circular(40)),
          onTapHandler: (image) =>
              onTapHandler({'imageKey': 'image1', 'image': image}),
          isEnabled: true,
          isValidated: formData['isVal1'],
        ),
      ),
    );
  }

  Widget _buildImage2(double coverHeight) {
    return SizedBox(
      width: coverHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            width: 1,
            color: kPrimaryColor,
          ),
        ),
        child: ImageInput(
          initialImagePathOrObject: formData['image2'],
          isCover: true,
          coverHeight: coverHeight,
          coverBorderRadius: const BorderRadius.all(Radius.circular(40)),
          onTapHandler: (image) =>
              onTapHandler({'imageKey': 'image2', 'image': image}),
          isEnabled: true,
          isValidated: formData['isVal2'],
        ),
      ),
    );
  }
}
