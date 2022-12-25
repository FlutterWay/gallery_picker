import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/gallery_album.dart';
import '../../../controller/gallery_controller.dart';
import 'date_category_widget.dart';
import 'selected_item_viewer_widget.dart';

// ignore: must_be_immutable
class GalleryCategoryViewWidget extends StatelessWidget {
  GalleryCategoryViewWidget({super.key, required this.galleryAlbum});
  GalleryAlbum galleryAlbum;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        children: [
          for (var category in galleryAlbum.dateCategories)
            DateCategoryWidget(
              category: category,
            ),
        ],
      ),
      if (Get.find<PhoneGalleryController>().selectedFiles.isNotEmpty)
        Align(alignment: Alignment.bottomCenter, child: SelectedMediaWidget())
    ]);
  }
}
