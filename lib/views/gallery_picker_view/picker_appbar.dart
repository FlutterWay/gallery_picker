import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bottom_sheet_controller.dart';
import '../../controller/gallery_controller.dart';
import 'tappable_appbar.dart';

class PickerAppBar extends StatelessWidget with PreferredSizeWidget {
  PhoneGalleryController controller;
  BottomSheetController? bottomSheetController;
  PickerAppBar(
      {super.key,
      required this.bottomSheetController,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TappableAppbar(
      controller: bottomSheetController,
      child: AppBar(
        elevation: 0,
        backgroundColor: controller.config.appbarColor,
        leading: TextButton(
            onPressed: () async {
              if (GetInstance().isRegistered<BottomSheetController>()) {
                bottomSheetController!.close();
              } else {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 500));
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
      ),
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
  Size get preferredSize => Size.fromHeight(48);
}
