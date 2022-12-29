import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/gallery_controller.dart';
import '../models/config.dart';
import '../models/mode.dart';
import '/models/media_file.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailMedia extends StatelessWidget {
  final MediaFile file;
  final Color failIconColor;
  final Config config;
  ThumbnailMedia({super.key, required this.file, required this.failIconColor,required this.config});

  Color adjustFailedBgColor() {
    if (config.mode == Mode.dark) {
      return lighten(
        config.backgroundColor,
      );
    } else {
      return darken(config.backgroundColor);
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
                      file.type == MediumType.image
                          ? Icons.image_not_supported
                          : Icons.videocam_off_rounded,
                      size: 50,
                      color: failIconColor,
                    ))
              else if (file.thumbnail != null)
                Hero(
                  tag: file.medium.id,
                  child: FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: MemoryImage(file.thumbnail!),
                  ),
                )
              else
                const SizedBox(),
              if (file.thumbnail != null && !file.thumbnailFailed)
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Icon(
                      file.medium.mediumType == MediumType.video
                          ? Icons.video_camera_back
                          : null,
                      color: Colors.white,
                      size: 20,
                    )),
            ],
          );
        });
  }
}
