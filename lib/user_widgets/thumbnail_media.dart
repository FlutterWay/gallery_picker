import 'package:flutter/material.dart';
import '/models/media_file.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailMedia extends StatelessWidget {
  final MediaFile media;
  final bool noIcon;
  final Widget Function(MediaFile media, BuildContext context)? onErrorBuilder;
  const ThumbnailMedia(
      {super.key,
      required this.media,
      this.onErrorBuilder,
      this.noIcon = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: media.thumbnail == null ? media.getThumbnail() : null,
        builder: (context, snapshot) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              if (media.thumbnailFailed && onErrorBuilder == null)
                Icon(
                  media.type == MediumType.image
                      ? Icons.image_not_supported
                      : Icons.videocam_off_rounded,
                  color: Colors.grey,
                )
              else if (media.thumbnailFailed && onErrorBuilder == null)
                onErrorBuilder!(media, context)
              else if (media.thumbnail != null)
                FadeInImage(
                  fadeInDuration: const Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: MemoryImage(media.thumbnail!),
                )
              else
                const SizedBox(),
              if (media.thumbnail != null && !media.thumbnailFailed && !noIcon)
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Icon(
                      media.medium.mediumType == MediumType.video
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
