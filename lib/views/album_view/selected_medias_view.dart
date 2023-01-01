import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bottom_sheet_controller.dart';
import '../../controller/gallery_controller.dart';
import '../../models/config.dart';

class SelectedMediasView extends StatelessWidget {
  final PhoneGalleryController controller;
  final Config config;
  SelectedMediasView({super.key, required this.controller})
      : config = controller.config;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                      child: !selectedMedia.thumbnailFailed
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: Image.memory(
                                      selectedMedia.thumbnail!,
                                      fit: BoxFit.fill,
                                    ).image),
                              ),
                              child: const SizedBox(
                                width: 47,
                                height: 47,
                              ),
                            )
                          : Container(
                              width: 47,
                              height: 47,
                              alignment: Alignment.center,
                              child: Icon(
                                selectedMedia.isImage
                                    ? Icons.image_not_supported
                                    : Icons.videocam_off_rounded,
                                color: Colors.grey,
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
