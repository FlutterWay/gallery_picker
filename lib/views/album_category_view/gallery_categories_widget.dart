import 'package:flutter/material.dart';
import 'package:gallery_picker/views/thumbnailAlbum.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../models/config.dart';
import '../album_view/gallery_category_view_page.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../controller/gallery_controller.dart';

class GalleryCategoriesWidget extends StatelessWidget {
  var galleryController = Get.find<PhoneGalleryController>();
  late Config config;
  GalleryCategoriesWidget({super.key}) {
    config = galleryController.config;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            children: <Widget>[
              ...galleryController.galleryAlbums.map(
                (album) => GestureDetector(
                  onTap: () => galleryController.changeAlbum(album),
                  child: Stack(fit: StackFit.passthrough, children: [
                    ThumbnailAlbum(album: album, failIconColor: galleryController.config.appbarIconColor),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
