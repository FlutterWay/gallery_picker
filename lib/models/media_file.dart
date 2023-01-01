import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../controller/gallery_controller.dart';

enum MediaType { image, video }

class MediaFile {
  late Medium medium;
  late MediaType type;
  Uint8List? thumbnail;
  Uint8List? data;
  late String id;
  bool thumbnailFailed = false;
  File? file;
  bool _noMedium = false;
  bool get isVideo => type == MediaType.video;
  bool get isImage => type == MediaType.image;

  MediaFile({required this.medium}) {
    type = medium.mediumType == MediumType.video
        ? MediaType.video
        : MediaType.image;
    id = medium.id;
  }
  MediaFile.file({required this.id, required this.file, required this.type}) {
    _noMedium = true;
    medium = Medium(
        id: id,
        mediumType:
            type == MediaType.image ? MediumType.image : MediumType.video);
  }

  Future<Uint8List?> getThumbnail() async {
    if (thumbnail == null) {
      try {
        if (_noMedium) {
          thumbnail = isVideo
              ? await VideoThumbnail.thumbnailData(
                  video: file!.path,
                  imageFormat: ImageFormat.JPEG,
                  maxWidth:
                      128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  quality: 25,
                )
              : await getData();
        } else {
          thumbnail =
              Uint8List.fromList(await medium.getThumbnail(highQuality: true));
        }
      } catch (e) {
        thumbnailFailed = true;
      }
    }
    return thumbnail;
  }

  Future<File> getFile() async {
    if (file == null) {
      file = await medium.getFile();
      return file!;
    } else {
      return file!;
    }
  }

  Future<Uint8List> getData() async {
    if (file == null) {
      await getFile();
    }
    data ??= await file!.readAsBytes();

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
