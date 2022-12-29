import 'package:flutter/material.dart';
import '/models/gallery_album.dart';
import 'date_category_view.dart';

// ignore: must_be_immutable
class AlbumMediasView extends StatelessWidget {
  TextStyle? textStyle;
  Widget Function(BuildContext)? onFileErrorBuilder;
  AlbumMediasView(
      {super.key, required this.galleryAlbum,this.textStyle});
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
                textStyle: textStyle,
              ),
          ],
        ),
      ],
    );
  }
}
