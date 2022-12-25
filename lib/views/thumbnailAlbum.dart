import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_album.dart';
import 'package:get/get.dart';
import '../controller/gallery_controller.dart';
import '../models/config.dart';
import '../models/mode.dart';
import '/models/media_file.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailAlbum extends StatelessWidget {
  final GalleryAlbum album;
  final Color failIconColor;
  final Config config = Get.find<PhoneGalleryController>().config;
  ThumbnailAlbum({super.key, required this.album, required this.failIconColor});

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
          FadeInImage(
            fadeInDuration: const Duration(milliseconds: 200),
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
            image: MemoryImage(Uint8List.fromList(album.thumbnail!)),
          )
        else
          const SizedBox(),
        Positioned(
            bottom: 10,
            left: 10,
            child: Icon(
              album.type == AlbumType.video
                  ? Icons.video_camera_back
                  : album.type == AlbumType.image
                      ? Icons.image
                      : Icons.folder,
              color: Colors.white,
              size: 20,
            )),
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
