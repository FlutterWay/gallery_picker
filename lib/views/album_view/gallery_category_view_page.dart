import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/gallery_controller.dart';
import '../../../models/gallery_album.dart';
import '../../models/config.dart';
import 'gallery_category_view_widget.dart';

class GalleryAlbumViewPage extends StatelessWidget {
  GalleryAlbumViewPage({super.key, required this.album});
  GalleryAlbum album;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneGalleryController>(builder: (controller) {
      Config config = controller.config;
      return Scaffold(
        backgroundColor: config.backgroundColor,

        appBar: AppBar(
          elevation: 0,
          foregroundColor: config.appbarIconColor,
          backgroundColor: config.appbarColor,
          leading: TextButton(
              onPressed: () {
                controller.changeAlbum(null);
              },
              child: Icon(
                Icons.arrow_back,
                color: config.appbarIconColor,
              )),
          title: Text(
            album.album.name!,
            style: config.appbarTextStyle,
          ),
          actions: [
            !Get.find<PhoneGalleryController>().pickerMode
                ? TextButton(
                    onPressed: () {
                      Get.find<PhoneGalleryController>().switchPickerMode(true);
                    },
                    child: Icon(
                      Icons.check_box_outlined,
                      color: config.appbarIconColor,
                    ))
                : const SizedBox()
          ],
        ),
        body: GalleryCategoryViewWidget(galleryAlbum: album),
      );
    });
  }
}
