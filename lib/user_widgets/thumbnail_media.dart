import 'package:flutter/material.dart';
import '/models/media_file.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailMedia extends StatelessWidget {
  final MediaFile media;
  final bool noIcon;
  final double? width, height;
  final Color? backgroundColor;
  final BoxFit fit;
  final bool highQuality;
  final double radius, borderWidth;
  final Color borderColor;
  final Widget Function(MediaFile media, BuildContext context)? onErrorBuilder;
  const ThumbnailMedia(
      {super.key,
      required this.media,
      this.fit = BoxFit.cover,
      this.onErrorBuilder,
      this.radius = 0,
      this.highQuality = true,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.width,
      this.height,
      this.backgroundColor,
      this.noIcon = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: media.thumbnail == null
            ? media.getThumbnail(highQuality: highQuality)
            : null,
        builder: (context, snapshot) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: borderColor, width: borderWidth)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  if (snapshot.hasError && onErrorBuilder == null)
                    Center(
                      child: Icon(
                        media.isImage
                            ? Icons.image_not_supported
                            : Icons.videocam_off_rounded,
                        color: Colors.grey,
                      ),
                    )
                  else if (snapshot.hasError && onErrorBuilder == null)
                    onErrorBuilder!(media, context)
                  else if (media.thumbnail != null)
                    FadeInImage(
                      width: width,
                      height: height,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fit: fit,
                      placeholder: MemoryImage(kTransparentImage),
                      image: MemoryImage(media.thumbnail!),
                    )
                  else
                    SizedBox(
                      width: width,
                      height: height,
                    ),
                  if (media.thumbnail != null && !noIcon)
                    Positioned(
                        bottom: 10,
                        left: 10,
                        child: Icon(
                          media.isVideo ? Icons.video_camera_back : null,
                          color: Colors.white,
                          size: 20,
                        )),
                ],
              ),
            ),
          );
        });
  }
}
