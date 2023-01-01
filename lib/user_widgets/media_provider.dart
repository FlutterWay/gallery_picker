import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';

class MediaProvider extends StatelessWidget {
  final MediaFile media;
  final double? width, height;
  const MediaProvider(
      {super.key, required this.media, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return media.isImage
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
