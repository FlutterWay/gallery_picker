import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../controller/gallery_controller.dart';

class MediaFile {
  Medium medium;
  MediumType? type;
  Uint8List? thumbnail;
  Uint8List? data;
  late String id;
  bool thumbnailFailed = false;
  File? file;
  MediaFile({required this.medium}) {
    type = medium.mediumType;
    id = medium.id;
  }
  Future<void> getThumbnail() async {
    try {
      thumbnail =
          Uint8List.fromList(await medium.getThumbnail(highQuality: true));
    } catch (e) {
      thumbnailFailed = true;
    }
  }

  Future<File> getFile() async {
    file = await medium.getFile();
    return file!;
  }

  Future<Uint8List> getData() async {
    if (file == null) {
      await getFile();
    }
    data = await file!.readAsBytes();
    return data!;
  }

  void unselect({PhoneGalleryController? controller}) {
    if (controller != null) {
      controller.unselectMedia(this);
    } else {
      if (GetInstance().isRegistered<PhoneGalleryController>()) {
        Get.find<PhoneGalleryController>().unselectMedia(this);
      }
    }
  }

  void select({PhoneGalleryController? controller}) {
    if (controller != null) {
      controller.selectMedia(this);
    } else {
      if (GetInstance().isRegistered<PhoneGalleryController>()) {
        Get.find<PhoneGalleryController>().selectMedia(this);
      }
    }
  }

  bool? isSelected({PhoneGalleryController? controller}) {
    if (controller != null) {
      return controller.isSelectedMedia(this);
    } else {
      if (GetInstance().isRegistered<PhoneGalleryController>()) {
        return Get.find<PhoneGalleryController>().isSelectedMedia(this);
      } else {
        return null;
      }
    }
  }
}
