library gallery_picker;

export 'models/config.dart';
export 'models/media_file.dart';
export 'models/mode.dart';
export 'models/medium.dart';
export 'models/gallery_media.dart';
export 'models/gallery_album.dart';
export 'user_widgets/thumbnail_media.dart';
export 'user_widgets/album_categories_view.dart';
export 'user_widgets/album_medias.dart';
export 'user_widgets/date_category_view.dart';
export 'user_widgets/thumbnail_album.dart';
export 'user_widgets/gallery_picker_builder.dart';
export 'user_widgets/photo_provider.dart';
export 'user_widgets/video_provider.dart';
export 'user_widgets/media_provider.dart';
export 'views/bottom_sheet.dart';
export 'views/gallery_picker_view/gallery_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_media.dart';
import 'package:get/get.dart';
import '../../controller/gallery_controller.dart';
import 'controller/bottom_sheet_controller.dart';
import 'controller/picker_listener.dart';
import 'models/config.dart';
import 'models/media_file.dart';
import 'views/gallery_picker_view/gallery_picker_view.dart';

class GalleryPicker {
  static Stream<List<MediaFile>> get listenSelectedFiles {
    var controller = Get.put(PickerListener());
    return controller.stream;
  }

  static void disposeSelectedFilesListener() {
    if (GetInstance().isRegistered<PickerListener>()) {
      Get.find<PickerListener>().dispose();
    }
  }

  static void dispose() {
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      Get.find<PhoneGalleryController>().disposeController();
    }
    if (GetInstance().isRegistered<BottomSheetController>()) {
      Get.find<BottomSheetController>().disposeController();
    }
  }

  static Future<List<MediaFile>?> pickMedia(
      {Config? config,
      bool startWithRecent = false,
      bool singleMedia = false,
      List<MediaFile>? initSelectedMedia,
      List<MediaFile>? extraRecentMedia,
      required BuildContext context}) async {
    List<MediaFile>? media;
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GalleryPickerView(
                onSelect: (mediaTmp) {
                  media = mediaTmp;
                },
                config: config,
                singleMedia: singleMedia,
                initSelectedMedia: initSelectedMedia,
                extraRecentMedia: extraRecentMedia,
                startWithRecent: startWithRecent,
              )),
    );
    return media;
  }

  static Future<void> pickMediaWithBuilder(
      {Config? config,
      required Widget Function(List<MediaFile> media, BuildContext context)?
          multipleMediaBuilder,
      Widget Function(String tag, MediaFile media, BuildContext context)?
          heroBuilder,
      bool singleMedia = false,
      List<MediaFile>? initSelectedMedia,
      List<MediaFile>? extraRecentMedia,
      bool startWithRecent = false,
      required BuildContext context}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GalleryPickerView(
                onSelect: (media) {},
                multipleMediaBuilder: multipleMediaBuilder,
                heroBuilder: heroBuilder,
                singleMedia: singleMedia,
                config: config,
                initSelectedMedia: initSelectedMedia,
                extraRecentMedia: extraRecentMedia,
                startWithRecent: startWithRecent,
              )),
    );
  }

  static Future<void> openSheet() async {
    if (GetInstance().isRegistered<BottomSheetController>()) {
      await Get.find<BottomSheetController>().open();
    }
  }

  static Future<void> closeSheet() async {
    if (GetInstance().isRegistered<BottomSheetController>()) {
      await Get.find<BottomSheetController>().close();
    }
  }

  static bool get isSheetOpened {
    if (GetInstance().isRegistered<BottomSheetController>()) {
      return Get.find<BottomSheetController>().sheetController.isExpanded;
    } else {
      return false;
    }
  }

  static Future<GalleryMedia?> get collectGallery async {
    return await PhoneGalleryController.collectGallery;
  }
}
