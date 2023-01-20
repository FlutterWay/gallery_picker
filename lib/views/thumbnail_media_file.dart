import 'package:flutter/material.dart';
import '../controller/gallery_controller.dart';
import '../functions/color.dart';
import '../models/mode.dart';
import '/models/media_file.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailMediaFile extends StatelessWidget {
  final MediaFile file;
  final Color failIconColor;
  final PhoneGalleryController controller;
  final BoxFit fit;
  final double? width, height;
  final double radius, borderWidth;
  final Color borderColor;
  final bool noIcon, noSelectedIcon;
  final bool highQuality;
  final Function()? onTap;
  final Function()? onLongPress;
  const ThumbnailMediaFile(
      {super.key,
      this.fit = BoxFit.cover,
      required this.file,
      this.width,
      this.onLongPress,
      this.onTap,
      this.height,
      this.radius = 0,
      this.noIcon = false,
      this.noSelectedIcon = false,
      this.highQuality = true,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      required this.failIconColor,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: file.thumbnail == null
            ? file.getThumbnail(highQuality: highQuality)
            : null,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: onTap != null
                ? () {
                    onTap!();
                  }
                : null,
            onLongPress: onLongPress != null
                ? () {
                    onLongPress!();
                  }
                : null,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: adjustFailedBgColor(),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: borderColor, width: borderWidth)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    if (snapshot.hasError)
                      Center(
                        child: Icon(
                          file.isImage
                              ? Icons.image_not_supported
                              : Icons.videocam_off_rounded,
                          size: 50,
                          color: failIconColor,
                        ),
                      )
                    else if (file.thumbnail != null &&
                        controller.heroBuilder != null)
                      Hero(
                        tag: file.id,
                        child: FadeInImage(
                          width: width,
                          height: height,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: fit,
                          placeholder: MemoryImage(kTransparentImage),
                          image: MemoryImage(file.thumbnail!),
                        ),
                      )
                    else if (file.thumbnail != null &&
                        controller.heroBuilder == null)
                      FadeInImage(
                        width: width,
                        height: height,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fit: fit,
                        placeholder: MemoryImage(kTransparentImage),
                        image: MemoryImage(file.thumbnail!),
                      )
                    else
                      SizedBox(
                        width: width,
                        height: height,
                      ),
                    if (!noIcon && file.thumbnail != null)
                      Positioned(
                          bottom: 10,
                          left: 10,
                          child: Icon(
                            file.isVideo ? Icons.video_camera_back : null,
                            color: Colors.white,
                            size: 20,
                          )),
                    if (!noSelectedIcon && controller.isSelectedMedia(file))
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          color: Colors.black,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
