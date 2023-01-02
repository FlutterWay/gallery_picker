import 'package:flutter/material.dart';
import '../controller/gallery_controller.dart';
import '../models/mode.dart';
import '/models/media_file.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailMediaFile extends StatelessWidget {
  final MediaFile file;
  final Color failIconColor;
  final PhoneGalleryController controller;
  final bool isCollapsedSheet;
  const ThumbnailMediaFile(
      {super.key,
      required this.file,
      required this.failIconColor,
      required this.isCollapsedSheet,
      required this.controller});

  Color adjustFailedBgColor() {
    if (controller.config.mode == Mode.dark) {
      return lighten(
        controller.config.backgroundColor,
      );
    } else {
      return darken(controller.config.backgroundColor);
    }
  }

  Color darken(Color color, [double amount = .03]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .05]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: file.thumbnail == null ? file.getThumbnail() : null,
        builder: (context, snapshot) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              if (file.thumbnailFailed)
                Container(
                    color: adjustFailedBgColor(),
                    child: Icon(
                      file.isImage
                          ? Icons.image_not_supported
                          : Icons.videocam_off_rounded,
                      size: 50,
                      color: failIconColor,
                    ))
              else if (file.thumbnail != null &&
                  !isCollapsedSheet &&
                  controller.heroBuilder != null)
                Hero(
                  tag: file.medium.id,
                  child: FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: MemoryImage(file.thumbnail!),
                  ),
                )
              else if (file.thumbnail != null && controller.heroBuilder == null)
                FadeInImage(
                  fadeInDuration: const Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: MemoryImage(file.thumbnail!),
                )
              else
                const SizedBox(),
              if (file.thumbnail != null && !file.thumbnailFailed)
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Icon(
                      file.isVideo ? Icons.video_camera_back : null,
                      color: Colors.white,
                      size: 20,
                    )),
            ],
          );
        });
  }
}
