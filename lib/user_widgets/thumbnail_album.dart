import 'dart:typed_data';

import 'package:flutter/material.dart';
import '/models/gallery_album.dart';
import '../models/mode.dart';

class ThumbnailAlbum extends StatelessWidget {
  final GalleryAlbum album;
  final Color failIconColor, backgroundColor;
  final Mode mode;
  const ThumbnailAlbum(
      {super.key,
      required this.album,
      required this.failIconColor,
      required this.mode,
      required this.backgroundColor});

  Color adjustFailedBgColor() {
    if (mode == Mode.dark) {
      return lighten(
        backgroundColor,
      );
    } else {
      return darken(backgroundColor);
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
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (album.thumbnail == null)
          Container(
              color: adjustFailedBgColor(),
              child: Icon(
                album.type == AlbumType.image
                    ? Icons.image_not_supported
                    : album.type == AlbumType.video
                        ? Icons.videocam_off_rounded
                        : Icons.browser_not_supported,
                size: 50,
                color: failIconColor,
              ))
        else if (album.thumbnail != null)
          Image.memory(
            Uint8List.fromList(album.thumbnail!),
            fit: BoxFit.cover,
          )
        else
          const SizedBox(),
        Opacity(
          opacity: 0.5,
          child: Container(
            color: Colors.black,
          ),
        ),
        Positioned(
            bottom: 5,
            left: 5,
            child: Icon(
              album.icon,
              color: Colors.white,
              size: 16,
            )),
        Positioned(
          left: 25,
          bottom: 5,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              album.name ?? "Unnamed Album",
              maxLines: 1,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                height: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              album.count.toString(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                height: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
