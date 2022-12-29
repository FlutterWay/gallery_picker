import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:photo_gallery/photo_gallery.dart' as photo_gallery;

class MediaProvider extends StatelessWidget {
  final MediaFile media;
  final double? width, height;
  const MediaProvider(
      {super.key, required this.media, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return media.type == photo_gallery.MediumType.image
        ? PhotoProvider(
            media: media,
            width: width,
            height: height,
          )
        : VideoProvider(
            media: media,
            width: width,
            height: height,
          );
  }
}
