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
export 'user_widgets/thumbnailAlbum.dart';
export 'user_widgets/files_stream_builder.dart';
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

  static Future<List<MediaFile>?> pickMedias(
      {Config? config,
      bool startWithRecent = false,
      List<MediaFile>? initSelectedMedias,
      required BuildContext context}) async {
    List<MediaFile>? medias;
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GalleryPickerView(
                onSelect: (mediasTmp) {
                  medias = mediasTmp;
                },
                config: config,
                initSelectedMedias: initSelectedMedias,
                startWithRecent: startWithRecent,
              )),
    );
    return medias;
  }

  static Future<void> pickMediasWithBuilder(
      {Config? config,
      required Widget Function(List<MediaFile> medias, BuildContext context)?
          multipleMediasBuilder,
      Widget Function(String tag, MediaFile media, BuildContext context)?
          heroBuilder,
      List<MediaFile>? initSelectedMedias,
      bool startWithRecent = false,
      required BuildContext context}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GalleryPickerView(
                onSelect: (medias) {},
                multipleMediasBuilder: multipleMediasBuilder,
                heroBuilder: heroBuilder,
                config: config,
                initSelectedMedias: initSelectedMedias,
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
