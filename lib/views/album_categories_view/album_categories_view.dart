import 'package:flutter/material.dart';
import '../../user_widgets/thumbnailAlbum.dart';
import '../../models/config.dart';
import '../../../controller/gallery_controller.dart';

class AlbumCategoriesView extends StatelessWidget {
  PhoneGalleryController controller;
  late Config config;
  AlbumCategoriesView(this.controller, {super.key}) {
    config = controller.config;
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
          children: <Widget>[
            ...controller.galleryAlbums.map(
              (album) => GestureDetector(
                onTap: () => controller.changeAlbum(album),
                child: Stack(fit: StackFit.passthrough, children: [
                  ThumbnailAlbum(
                    album: album,
                    failIconColor: config.appbarIconColor,
                    backgroundColor: config.backgroundColor,
                    mode: config.mode,
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
