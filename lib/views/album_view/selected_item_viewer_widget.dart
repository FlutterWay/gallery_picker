import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../controller/gallery_controller.dart';
import '../../models/config.dart';

class SelectedMediaWidget extends StatelessWidget {
  var galleryController = Get.find<PhoneGalleryController>();
  late Config config;
  SelectedMediaWidget({super.key}) {
    config = galleryController.config;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 167;
    return Container(
      color: config.bottomSheetColor,
      width: width,
      height: 65,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.8,
              height: 55,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var selectedMedia in galleryController.selectedFiles)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 3.0, right: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: ThumbnailProvider(
                                  mediumId: selectedMedia.mediaFile.id,
                                  mediumType:
                                      selectedMedia.mediaFile.mediumType,
                                  highQuality: true,
                                ))),
                        child: SizedBox(
                          width: 47,
                          height: 47,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (galleryController.selectedFiles.length == 1 &&
                    galleryController.heroBuilder != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return galleryController.heroBuilder!(
                        galleryController.selectedFiles[0].mediaFile.id,
                        galleryController.selectedFiles[0],context);
                  }));
                } else if (galleryController.multipleMediaBuilder != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return galleryController
                        .multipleMediaBuilder!(galleryController.selectedFiles,context);
                  }));
                } else {
                  galleryController.onSelect(galleryController.selectedFiles);
                  Navigator.pop(context);
                  if (!galleryController.isRecent) {
                    Navigator.pop(context);
                  }
                }
              },
              child: config.selectIcon,
            )
          ],
        ),
      ),
    );
  }
}
