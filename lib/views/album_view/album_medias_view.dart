import 'package:flutter/material.dart';
import '/models/gallery_album.dart';
import '../../../controller/gallery_controller.dart';
import 'date_category_view.dart';
import 'selected_medias_view.dart';

// ignore: must_be_immutable
class AlbumMediasView extends StatelessWidget {
  PhoneGalleryController controller;
  bool singleMedia;
  AlbumMediasView(
      {super.key,
      required this.galleryAlbum,
      required this.controller,
      required this.singleMedia});
  GalleryAlbum galleryAlbum;
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
