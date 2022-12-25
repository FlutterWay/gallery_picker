import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '/views/ThumbnailMedia.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../../controller/gallery_controller.dart';
import '../../../models/media_file.dart';

class MediaView extends StatelessWidget {
  final MediaFile file;
  var controller = Get.find<PhoneGalleryController>();
  MediaView(this.file, {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onLongPress: () {
            file.select();
          },
          onTap: () {
            if (controller.pickerMode) {
              file.isSelected ? file.unselect() : file.select();
            } else {
              if (controller.heroBuilder != null) {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return controller.heroBuilder!(file.mediaFile.id, file,context);
                }));
              } else {
                controller.onSelect([file]);
                Navigator.pop(context);
                GetInstance().delete<PhoneGalleryController>();
              }
            }
          },
          child: ThumbnailMedia(
              file: file, failIconColor: controller.config.appbarIconColor),
        ),
        if (file.isSelected)
          GestureDetector(
            onTap: () {
              file.isSelected ? file.unselect() : file.select();
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
