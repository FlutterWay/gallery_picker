import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../controller/gallery_controller.dart';

class MediaFile {
  Medium mediaFile;
  MediumType? type;
  Uint8List? thumbnail;
  bool thumbnailFailed=false;

  MediaFile({required this.mediaFile}) {
    type = mediaFile.mediumType;
  }
  Future<void> getThumbnail() async {
    print("zooooortlamaca");
    try {
      thumbnail =
          Uint8List.fromList(await mediaFile.getThumbnail(highQuality: true));
    } catch (e) {
      thumbnailFailed = true;
    }
  }

  void unselect() {
    Get.find<PhoneGalleryController>().unselectMedia(this);
  }

  void select() {
    Get.find<PhoneGalleryController>().selectMedia(this);
  }

  bool get isSelected =>
      Get.find<PhoneGalleryController>().isSelectedMedia(this);
}
