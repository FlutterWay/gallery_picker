import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../controller/gallery_controller.dart';
import '../../functions/color.dart';
import '../../models/mode.dart';

class SelectedMediaThumbnail extends StatelessWidget {
  final Uint8List? data;
  final double? width, height;
  final BoxFit fit;
  final PhoneGalleryController controller;
  final Color failIconColor;
  const SelectedMediaThumbnail({
    super.key,
    required this.failIconColor,
    required this.controller,
    required this.data,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  Color adjustFailedBgColor() {
    if (controller.config.mode == Mode.dark) {
      return lighten(
        controller.config.backgroundColor,
      );
    } else {
      return darken(controller.config.backgroundColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: adjustFailedBgColor(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: data != null
          ? FadeInImage(
              width: width,
              height: height,
              fadeInDuration: const Duration(milliseconds: 200),
              fit: fit,
              placeholder: MemoryImage(kTransparentImage),
              image: MemoryImage(data!),
            )
          : Center(
              child: Icon(
                Icons.browser_not_supported,
                size: 50,
                color: failIconColor,
              ),
            ),
    );
  }
}
