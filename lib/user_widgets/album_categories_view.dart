import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_album.dart';
import '../../user_widgets/thumbnailAlbum.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../models/config.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../controller/gallery_controller.dart';
import '../models/mode.dart';

class AlbumCategoriesView extends StatelessWidget {
  List<GalleryAlbum> albums;
  Function(GalleryAlbum album)? onPressed;
  Function(GalleryAlbum album, bool)? onHover;
  Function(GalleryAlbum album)? onLongPress;
  Function(GalleryAlbum album, bool)? onFocusChange;
  final Color categoryFailIconColor, categoryBackgroundColor;
  final Mode mode;
  AlbumCategoriesView(
      {super.key,
      required this.albums,
      required this.categoryBackgroundColor,
      required this.categoryFailIconColor,
      required this.mode,
      this.onFocusChange,
      this.onHover,
      this.onLongPress,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
          children: <Widget>[
            ...albums.map(
              (album) => TextButton(
                onPressed: () {
                  if (onPressed != null) {
                    onPressed!(album);
                  }
                },
                onFocusChange: (value) {
                  if (onFocusChange != null) {
                    onFocusChange!(album, value);
                  }
                },
                onHover: (value) {
                  if (onHover != null) {
                    onHover!(album, value);
                  }
                },
                onLongPress: () {
                  if (onLongPress != null) {
                    onLongPress!(album);
                  }
                },
                child: Stack(fit: StackFit.passthrough, children: [
                  ThumbnailAlbum(
                      album: album,
                      failIconColor: categoryFailIconColor,
                      mode: mode,
                      backgroundColor: categoryBackgroundColor),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
