import 'package:flutter/material.dart';

import '../../../controller/gallery_controller.dart';
import '/models/gallery_album.dart';
import 'date_category_view.dart';
import 'selected_medias_view.dart';

class AlbumMediasView extends StatelessWidget {
  final PhoneGalleryController controller;
  final bool singleMedia;
  final bool isBottomSheet;
  const AlbumMediasView(
      {super.key,
      required this.galleryAlbum,
      required this.controller,
      required this.isBottomSheet,
      required this.singleMedia});
  final GalleryAlbum galleryAlbum;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            for (var category in checkCategories(galleryAlbum.dateCategories))
              DateCategoryWiew(
                category: category,
                controller: controller,
                singleMedia: singleMedia,
                isBottomSheet: isBottomSheet,
              ),
          ],
        ),
        if (controller.selectedFiles.isNotEmpty)
          Align(
              alignment: Alignment.bottomCenter,
              child: SelectedMediasView(
                controller: controller,
                isBottomSheet: isBottomSheet,
              ))
      ],
    );
  }

  List<DateCategory> checkCategories(List<DateCategory> categories) {
    if (controller.isRecent &&
        controller.extraRecentMedia != null &&
        controller.extraRecentMedia!.isNotEmpty) {
      List<DateCategory> categoriesTmp = categories.map((e) => e).toList();
      int index = categoriesTmp
          .indexWhere((element) => element.name == controller.config.recent);
      if (index != -1) {
        DateCategory category = DateCategory(
            files: [
              ...controller.extraRecentMedia!,
              ...categoriesTmp[index].files,
            ],
            name: categoriesTmp[index].name,
            dateTime: categoriesTmp[index].dateTime);
        categoriesTmp[index] = category;
        return categoriesTmp;
      } else {
        return [
          DateCategory(
              files: controller.extraRecentMedia!,
              dateTime: controller.extraRecentMedia!.first.lastModified ??
                  DateTime.now(),
              name: controller.config.recent),
          ...categoriesTmp
        ];
      }
    } else {
      return categories;
    }
  }
}
