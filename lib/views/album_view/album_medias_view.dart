import 'package:flutter/material.dart';
import '/models/gallery_album.dart';
import '../../../controller/gallery_controller.dart';
import 'date_category_view.dart';
import 'selected_medias_view.dart';

class AlbumMediasView extends StatelessWidget {
  final PhoneGalleryController controller;
  final bool singleMedia;
  const AlbumMediasView(
      {super.key,
      required this.galleryAlbum,
      required this.controller,
      required this.singleMedia});
  final GalleryAlbum galleryAlbum;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            for (var category in galleryAlbum.dateCategories)
              DateCategoryWiew(
                category: category,
                controller: controller,
                singleMedia: singleMedia,
              ),
          ],
        ),
        if (controller.selectedFiles.isNotEmpty)
          Align(
              alignment: Alignment.bottomCenter,
              child: SelectedMediasView(
                controller: controller,
              ))
      ],
    );
  }
}
