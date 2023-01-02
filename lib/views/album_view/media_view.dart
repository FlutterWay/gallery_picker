import 'package:flutter/material.dart';
import '../../controller/bottom_sheet_controller.dart';
import 'package:get/get.dart';
import '../../../controller/gallery_controller.dart';
import '../../../models/media_file.dart';
import '../thumbnail_media_file.dart';

class MediaView extends StatelessWidget {
  final MediaFile file;
  final PhoneGalleryController controller;
  final bool singleMedia;
  final bool isCollapsedSheet;
  const MediaView(this.file,
      {super.key,
      required this.controller,
      required this.singleMedia,
      required this.isCollapsedSheet});
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onLongPress: () {
            if (singleMedia) {
              if (controller.heroBuilder != null) {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return controller.heroBuilder!(file.medium.id, file, context);
                }));
              } else {
                controller.selectedFiles.add(file);
                controller.onSelect(controller.selectedFiles);
                controller.updatePickerListener();
                if (GetInstance().isRegistered<BottomSheetController>()) {
                  Get.find<BottomSheetController>().close();
                } else {
                  Navigator.pop(context);
                  controller.disposeController();
                }
              }
            } else {
              file.select(controller: controller);
            }
          },
          onTap: () {
            if (controller.pickerMode) {
              file.isSelected(controller: controller)!
                  ? file.unselect(controller: controller)
                  : file.select(controller: controller);
            } else {
              if (controller.heroBuilder != null) {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return controller.heroBuilder!(file.medium.id, file, context);
                }));
              } else {
                controller.selectedFiles.add(file);
                controller.onSelect(controller.selectedFiles);
                controller.updatePickerListener();
                if (GetInstance().isRegistered<BottomSheetController>()) {
                  Get.find<BottomSheetController>().close();
                } else {
                  Navigator.pop(context);
                  controller.disposeController();
                }
              }
            }
          },
          child: ThumbnailMediaFile(
              file: file,
              failIconColor: controller.config.appbarIconColor,
              controller: controller,
              isCollapsedSheet: isCollapsedSheet),
        ),
        if (file.isSelected(controller: controller)!)
          GestureDetector(
            onTap: () {
              file.isSelected(controller: controller)!
                  ? file.unselect(controller: controller)
                  : file.select(controller: controller);
            },
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
