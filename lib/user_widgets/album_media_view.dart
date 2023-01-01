import 'package:flutter/material.dart';
import '/models/gallery_album.dart';
import 'date_category_view.dart';

// ignore: must_be_immutable
class AlbumMediaView extends StatelessWidget {
  final TextStyle? textStyle;
  const AlbumMediaView({super.key, required this.galleryAlbum, this.textStyle});
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
                textStyle: textStyle,
              ),
          ],
        ),
      ],
    );
  }
}
