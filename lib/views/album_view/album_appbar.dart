import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_album.dart';
import '../../controller/gallery_controller.dart';

class AlbumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PhoneGalleryController controller;
  final GalleryAlbum album;
  final bool isBottomSheet;
  const AlbumAppBar(
      {super.key,
      required this.album,
      required this.controller,
      required this.isBottomSheet});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: controller.config.appbarIconColor,
      backgroundColor: controller.config.appbarColor,
      leading: TextButton(
          onPressed: () async {
            controller.backToPicker();
          },
          child: Icon(
            Icons.arrow_back,
            color: controller.config.appbarIconColor,
          )),
      title: getTitle(),
      actions: [
        !controller.pickerMode
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
    if (!controller.pickerMode && controller.selectedFiles.isEmpty) {
      return Text(
        album.name ?? "Unnamed Album",
        style: controller.config.appbarTextStyle,
      );
    } else if (controller.pickerMode && controller.selectedFiles.isEmpty) {
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
