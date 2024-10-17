import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart' as app_constants;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../utils/utils.dart';
import 'circle_border_widget.dart';
import 'icon_widget.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.initialImagePathOrObject,
    this.isCover = false,
    this.coverHeight = 280,
    this.coverBorderRadius,
    this.avatarRadius = 64,
    required this.onTapHandler,
    required this.isEnabled,
    this.isValidated = true,
  });
  final dynamic initialImagePathOrObject;
  final bool isCover;
  final double coverHeight;
  final BorderRadiusGeometry? coverBorderRadius;
  final double avatarRadius;
  final ValueChanged<dynamic> onTapHandler;
  final bool isEnabled;
  final bool isValidated;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  late final i18n i;
  dynamic _imagePathOrObject;
  Uint8List webImage = Uint8List(10);

  @override
  void initState() {
    i = Provider.of<i18n>(context, listen: false);
    _imagePathOrObject = widget.initialImagePathOrObject;
    super.initState();
  }

  @override
  void didUpdateWidget(ImageInput oldWidget) {
    _imagePathOrObject = widget.initialImagePathOrObject;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('*************** image_input build ***************');
    return GestureDetector(
      onTap: widget.isEnabled
          ? () async {
              final source = await showImageSource(context);
              if (source == null) return;
              pickImage(source);
            }
          : null,
      child: widget.isCover ? _buildCover : _buildAvatar,
    );
  }

  Widget get _buildCover {
    final cover =
        _imagePathOrObject == null ? buildCoverWithIcon : buildCoverWithImage;

    return Stack(
      children: [
        cover,
        if (widget.isEnabled)
          Positioned(
            bottom: 8,
            right: 8,
            child: buildEditIcon(Colors.teal, widget.coverHeight / 12),
          ),
      ],
    );
  }

  Widget get _buildAvatar {
    double size = widget.avatarRadius;
    const color = Colors.teal;

    if (_imagePathOrObject != null) {
      return Stack(
        children: [
          buildCircleAvatarWithBorder(size, color),
          if (widget.isEnabled)
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color, widget.avatarRadius / 3),
            ),
        ],
      );
    } else {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.black38,
        child: Icon(Icons.person_add_sharp,
            color: widget.isValidated ? Colors.white : Colors.red, size: 30),
      );
    }
  }

  Widget get buildCoverWithImage {
    return ClipRRect(
      borderRadius: widget.coverBorderRadius ?? BorderRadius.zero,
      child: getImage(_imagePathOrObject),
    );
  }

  Widget get buildCoverWithIcon {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.coverBorderRadius,
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
      height: widget.coverHeight,
      child: Icon(Icons.image_outlined,
          color: widget.isValidated ? kPrimaryMediumColor : Colors.red,
          size: 50),
    );
  }

  Widget buildCircleAvatarWithBorder(double size, Color color) {
    return CircleBorderWidget(
      borderColor: color,
      child: CircleAvatar(
        radius: size,
        backgroundColor: color,
        child: ClipOval(
          child: getImage(_imagePathOrObject),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color, double addIconSize) {
    return CircleBorderWidget(
      // strokeWidth: 1.0, // default
      // gap: 2.0, // default
      borderColor: color,
      child: const IconWidget(
        icon: Icons.add_a_photo,
        color: Colors.teal,
        size: 20,
      ),
    );
  }

  Widget getImage(dynamic imagePathOrObject) {
    late final Image image;

    if (imagePathOrObject is Map<String, dynamic>) {
      final List<int>? imageData =
          imagePathOrObject['image-object'] as List<int>?;
      if (imageData != null) {
        final Uint8List uint8ImageData = Uint8List.fromList(imageData);
        image = Image.memory(
          uint8ImageData,
          width: double.infinity,
          height: widget.coverHeight,
          fit: BoxFit.cover,
        );
      } else {
        image = const Image(
          image: AssetImage("assets/icons/Documents.svg"),
          fit: BoxFit.cover,
        );
      }
    } else {
      // check if a path is local path in OS filesystem JUST in syntax not really
      // final bool isAbsolutePath = !_imagePath!.contains('http://');
      // final bool isAbsolutePath = File(_imagePath!).isAbsolute; // import 'dart:io';
      final bool isAbsolutePath = p.isAbsolute(imagePathOrObject);
      image = isAbsolutePath && !kIsWeb
          ? Image.file(
              File(imagePathOrObject),
              width: double.infinity,
              height: widget.coverHeight,
              fit: BoxFit.cover,
            )
          : Image.network(
              imagePathOrObject,
              width: double.infinity,
              height: widget.coverHeight,
              fit: BoxFit.cover,
            );
    }

    return image;
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (kIsWeb) {
      return ImageSource.gallery;
    }
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (ctx) => Directionality(
                textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text(i.tr('Camera')),
                      onPressed: () =>
                          Navigator.of(ctx).pop(ImageSource.camera),
                    ),
                    CupertinoActionSheetAction(
                      child: Text(i.tr('Gallery')),
                      onPressed: () =>
                          Navigator.of(ctx).pop(ImageSource.gallery),
                    )
                  ],
                ),
              ));
    } else {
      return showModalBottomSheet(
          shape: app_constants.kBuildTopRoundedRectangleBorder,
          context: context,
          builder: (ctx) => Directionality(
                textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: Text(i.tr('Camera')),
                        onTap: () => Navigator.of(ctx).pop(ImageSource.camera)),
                    ListTile(
                        leading: const Icon(Icons.image),
                        title: Text(i.tr('Gallery')),
                        onTap: () =>
                            Navigator.of(ctx).pop(ImageSource.gallery)),
                  ],
                ),
              ));
    }
  }

  Future pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    // WEB NOT Work To Upload
    if (kIsWeb) {
      try {
        // Pick an image
        final XFile? cachedImageObject = await picker.pickImage(
          source: source,
          // maxHeight: 480,
          // maxWidth: 640,
          // imageQuality: 100, // 0-100
        );

        if (cachedImageObject == null) {
          return; // if you canceled image pick or capture
        }
        bool isPass = await imageSizeCheckPoint(cachedImageObject);
        if (!isPass) {
          Utils.openWarningSnackBar(context, i.tr("m84"));
          return;
        }

        Uint8List bytes = await cachedImageObject.readAsBytes();
        List<int> list = bytes.cast();
        setState(() => _imagePathOrObject = cachedImageObject.path);
        String fileName = getNameAndEx(_imagePathOrObject!);
        widget.onTapHandler({"image-object": list, "name": fileName});
      } on PlatformException {
        // print('Failed to pick image: $e');
      }
    }
    // MOBILE
    else {
      try {
        // Pick an image
        final XFile? cachedImageObject = await picker.pickImage(
          source: source,
          // maxHeight: 480,
          // maxWidth: 640,
          // imageQuality: 100, // 0-100
        );
        if (cachedImageObject == null) {
          return; // if you canceled image pick or capture
        }
        bool isPass = await imageSizeCheckPoint(cachedImageObject);
        if (!isPass) {
          Utils.openWarningSnackBar(context, i.tr("m84"));
          return;
        }

        final File permanentImageObject =
            await saveImagePermanently(cachedImageObject.path);

        setState(() => _imagePathOrObject = permanentImageObject.path);
        widget.onTapHandler(_imagePathOrObject!);
      } on PlatformException {
        // print('Failed to pick image: $e');
      }
    }
  }

  Future<File> saveImagePermanently(String temporaryCachedPath) async {
    /// "path_provider" package: to find or get access to the permanent location on the filesystem which IOS or Android reserved to the App to store it's data in, and this directory would be delete WITH Uninstall that App
    /// "path" package: to manipulating paths: joining, splitting, normalizing, etc. IN HERE we have used to get the name of the cached file, which assigned by "image_picker"
    /// import 'dart:io'; to use "File()"
    /// to set a new name to the file.ex:
    /// final fileName = '_${widget.idUser}_${Uuid().v4()}';
    /// final ex = p.extension(temporaryCachedPath);
    /// return File(temporaryCachedPath).copy('${appDir.path}/$fileName$ex');

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = getNameAndEx(temporaryCachedPath);

    return File(temporaryCachedPath).copy('${appDir.path}/$fileName');
  }

  String getNameAndEx(String temporaryCachedPath) {
    String fileName;
    if (widget.initialImagePathOrObject == null) {
      fileName = p.basename(temporaryCachedPath);
    } else {
      fileName = p.basenameWithoutExtension(widget.initialImagePathOrObject!);
      final ex = p.extension(temporaryCachedPath);
      fileName = "$fileName$ex";
    }
    return fileName;
  }

  Future<bool> imageSizeCheckPoint(XFile image) async {
    // Get the image size in bytes.
    final int imageSize = await image.length();
    // If the image size is smaller than 1 MB, acept it.
    if (imageSize < 1048576) {
      return true;
    }
    return false;
  }
}
