import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../controller/bottom_sheet_controller.dart';
import '../../controller/gallery_controller.dart';
import '../../models/config.dart';

class SelectedMediasView extends StatelessWidget {
  PhoneGalleryController controller;
  late Config config;
  SelectedMediasView({super.key, required this.controller}) {
    config = controller.config;
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
                  for (var selectedMedia in controller.selectedFiles)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 3.0, right: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: ThumbnailProvider(
                                  mediumId: selectedMedia.medium.id,
                                  mediumType:
                                      selectedMedia.medium.mediumType,
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
                if (controller.selectedFiles.length == 1 &&
                    controller.heroBuilder != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return controller.heroBuilder!(
                        controller.selectedFiles[0].medium.id,
                        controller.selectedFiles[0],
                        context);
                  }));
                } else if (controller.multipleMediasBuilder != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return controller.multipleMediasBuilder!(
                        controller.selectedFiles, context);
                  }));
                } else {
                  controller.onSelect(controller.selectedFiles);
                  if (GetInstance().isRegistered<BottomSheetController>()) {
                    Get.find<BottomSheetController>().close();
                  } else {
                    Navigator.pop(context);
                    controller.disposeController();
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
