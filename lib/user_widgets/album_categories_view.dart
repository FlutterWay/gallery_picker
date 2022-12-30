import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_album.dart';
import 'thumbnail_album.dart';
import '../models/mode.dart';

class AlbumCategoriesView extends StatelessWidget {
  final List<GalleryAlbum> albums;
  final Function(GalleryAlbum album)? onPressed;
  final Function(GalleryAlbum album, bool)? onHover;
  final Function(GalleryAlbum album)? onLongPress;
  final Function(GalleryAlbum album, bool)? onFocusChange;
  final Color categoryFailIconColor, categoryBackgroundColor;
  final Mode mode;
  const AlbumCategoriesView(
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
