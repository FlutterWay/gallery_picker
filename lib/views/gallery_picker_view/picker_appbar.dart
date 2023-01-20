import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import '../../controller/gallery_controller.dart';

class PickerAppBar extends StatelessWidget with PreferredSizeWidget {
  final PhoneGalleryController controller;
  final bool isBottomSheet;
  const PickerAppBar(
      {super.key, required this.isBottomSheet, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: controller.config.appbarColor,
      leading: TextButton(
          onPressed: () async {
            if (isBottomSheet) {
              BottomSheetPanel.close();
            } else {
              Navigator.pop(context);
              await Future.delayed(const Duration(milliseconds: 500));
              controller.disposeController();
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: controller.config.appbarIconColor,
          )),
      title: getTitle(),
      actions: [
        !controller.pickerMode && controller.isRecent
            ? TextButton(
                onPressed: () {
                  controller.switchPickerMode(true);
                },
                child: Icon(
                  Icons.check_box_outlined,
                  color: controller.config.appbarIconColor,
                ))
            : const SizedBox()
      ],
    );
  }

  Widget getTitle() {
    if (controller.pickerMode && controller.selectedFiles.isEmpty) {
      return Text(
        controller.config.tapPhotoSelect,
        style: controller.config.appbarTextStyle,
      );
    } else if (controller.pickerMode && controller.selectedFiles.isNotEmpty) {
      return Text(
        "${controller.selectedFiles.length} ${controller.config.selected}",
        style: controller.config.appbarTextStyle,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
