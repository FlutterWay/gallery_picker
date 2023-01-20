import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/views/thumbnail_media_file.dart';
import '../../controller/gallery_controller.dart';
import '../../models/config.dart';

class SelectedMediasView extends StatelessWidget {
  final PhoneGalleryController controller;
  final Config config;
  final bool isBottomSheet;
  SelectedMediasView(
      {super.key, required this.controller, required this.isBottomSheet})
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
                  for (var mediaFile in controller.selectedFiles)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 3.0, right: 2),
                      child: ThumbnailMediaFile(
                          file: mediaFile,
                          width: 50,
                          height: 55,
                          radius: 5,
                          noIcon: true,
                          noSelectedIcon: true,
                          failIconColor: controller.config.appbarIconColor,
                          controller: controller),
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
                        controller.selectedFiles[0].id,
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
                  if (isBottomSheet) {
                    BottomSheetPanel.close();
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
