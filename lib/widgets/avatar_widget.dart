import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../constants/app_constants.dart';
import 'circle_border_widget.dart';

class AvatarWidget extends StatelessWidget {
  AvatarWidget({
    super.key,
    this.imagePath,
    required this.size,
    this.color = kPrimaryColor,
  });

  final String? imagePath;
  final double size;
  Color color;

  @override
  Widget build(BuildContext context) {
    // import flutter_cache_manager to perform customCachManager
    final customCachManager = CacheManager(
      Config(
        "customCacheKey",
        stalePeriod: const Duration(days: 15),
        // maxNrOfCacheObjects: 100,
      ),
    );
    if (imagePath == null) {
      return CircleBorderWidget(
        // width: 1.0, // default
        // gap: 2.0, // default
        // gapColor: Colors.white, // default
        borderColor: kPrimaryColor,
        child: CircleAvatar(
          radius: size,
          backgroundColor: kPrimaryLightColor,
          child:
              Icon(Icons.person, color: kPrimaryMediumColor, size: size + 10),
        ),
      );
    }
    return CircleBorderWidget(
      // strokeWidth: 1.0, // default
      // gap: 2.0, // default
      borderColor: color,
      child: CircleAvatar(
        radius: size,
        backgroundColor: color,
        child: ClipOval(
          child: getImage(customCachManager, imagePath!),
        ),
      ),
    );
  }

  Widget getImage(CacheManager customCachManager, String imagePath) {
    return kIsWeb
        ? Image.network(
            imagePath,
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: imagePath,
            cacheManager: customCachManager,
            placeholder: (context, url) => const CircularProgressIndicator(),
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
          );
  }
}

class CoverWidget extends StatelessWidget {
  CoverWidget({
    super.key,
    this.imagePath,
    this.coverHeight = 280,
    this.coverBorderRadius,
    this.color = kPrimaryMediumColor,
  });

  final String? imagePath;
  final double coverHeight;
  final BorderRadiusGeometry? coverBorderRadius;
  Color color;

  @override
  Widget build(BuildContext context) {
    // import flutter_cache_manager to perform customCachManager
    final customCachManager = CacheManager(
      Config(
        "customCacheKey",
        stalePeriod: const Duration(days: 15),
        // maxNrOfCacheObjects: 100,
      ),
    );
    if (imagePath == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: coverBorderRadius,
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
                KScaffoldBackgroundColor,
                kPrimaryLightColor,
              ]),
        ),
        width: double.infinity,
        height: coverHeight,
        child: Icon(Icons.image_outlined, color: color, size: 50),
      );
    }

    return ClipRRect(
      borderRadius: coverBorderRadius ?? BorderRadius.zero,
      child: getImage(customCachManager, imagePath!),
    );
  }

  Widget getImage(CacheManager customCachManager, String imagePath) {
    return kIsWeb
        ? Image.network(
            imagePath,
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: imagePath,
            cacheManager: customCachManager,
            placeholder: (context, url) => const CircularProgressIndicator(),
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover,
          );
  }
}
