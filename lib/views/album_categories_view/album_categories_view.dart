import 'package:flutter/material.dart';
import '../../user_widgets/thumbnail_album.dart';
import '../../models/config.dart';
import '../../../controller/gallery_controller.dart';

class AlbumCategoriesView extends StatelessWidget {
  final PhoneGalleryController controller;
  final Config config;
  final bool isBottomSheet;
  final bool singleMedia;

  AlbumCategoriesView(
      {super.key,
      required this.controller,
      required this.isBottomSheet,
      required this.singleMedia})
      : config = controller.config;
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
                onTap: () => controller.changeAlbum(
                    album: album,
                    isBottomSheet: isBottomSheet,
                    controller: controller,
                    singleMedia: singleMedia,
                    context: context),
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
