import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({required this.imgUrls, super.key});

  final List<String> imgUrls;

  @override
  Widget build(BuildContext context) {
    return Center(
      // https://www.youtube.com/watch?v=3GJach7WmFY
      child: CarouselSlider(items: _items, options: _options),
    );
  }

  CarouselOptions get _options {
    return CarouselOptions(
      height: 400,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 7),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.3,
      // onPageChanged: callbackFunction,
      scrollDirection: Axis.horizontal,
    );
  }

  List<Builder> get _items {
    return imgUrls.map((imagePath) {
      return Builder(
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imagePath.startsWith('http://') ||
                    imagePath.startsWith('https://')
                ? Image.network(
                    // SvgPicture.asset
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    // SvgPicture.asset
                    imagePath,
                    fit: BoxFit.contain,
                  ),
          );
        },
      );
    }).toList();
  }
}
