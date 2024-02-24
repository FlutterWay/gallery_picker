library gallery_picker;

import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/models/gallery_media.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../controller/gallery_controller.dart';
import 'controller/picker_listener.dart';
import 'models/config.dart';
import 'models/media_file.dart';
import 'views/gallery_picker_view/gallery_picker_view.dart';

export 'package:bottom_sheet_scaffold/models/sheet_status.dart';
export 'package:bottom_sheet_scaffold/views/bottom_sheet_builder.dart';
export 'package:page_transition/src/enum.dart';

export 'models/config.dart';
export 'models/gallery_album.dart';
export 'models/gallery_media.dart';
export 'models/media_file.dart';
export 'models/medium.dart';
export 'models/mode.dart';
export 'user_widgets/album_categories_view.dart';
export 'user_widgets/album_media_view.dart';
export 'user_widgets/date_category_view.dart';
export 'user_widgets/gallery_picker_builder.dart';
export 'user_widgets/media_provider.dart';
export 'user_widgets/photo_provider.dart';
export 'user_widgets/thumbnail_album.dart';
export 'user_widgets/thumbnail_media.dart';
export 'user_widgets/video_provider.dart';
export 'views/gallery_picker_view/gallery_picker_view.dart';
export 'views/picker_scaffold.dart';

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
  }

  static Future<List<MediaFile>?> pickMedia(
      {Config? config,
      bool startWithRecent = false,
      bool singleMedia = false,
      Locale? locale,
      PageTransitionType pageTransitionType = PageTransitionType.rightToLeft,
      List<MediaFile>? initSelectedMedia,
      List<MediaFile>? extraRecentMedia,
      required BuildContext context}) async {
    List<MediaFile>? media;
    await Navigator.push(
        context,
        PageTransition(
            type: pageTransitionType,
            child: GalleryPickerView(
              onSelect: (mediaTmp) {
                media = mediaTmp;
              },
              config: config,
              locale: locale,
              singleMedia: singleMedia,
              initSelectedMedia: initSelectedMedia,
              extraRecentMedia: extraRecentMedia,
              startWithRecent: startWithRecent,
            )));
    return media;
  }

  static Future<void> pickMediaWithBuilder(
      {Config? config,
      required Widget Function(List<MediaFile> media, BuildContext context)?
          multipleMediaBuilder,
      Widget Function(String tag, MediaFile media, BuildContext context)?
          heroBuilder,
      Locale? locale,
      bool singleMedia = false,
      PageTransitionType pageTransitionType = PageTransitionType.rightToLeft,
      List<MediaFile>? initSelectedMedia,
      List<MediaFile>? extraRecentMedia,
      bool startWithRecent = false,
      required BuildContext context}) async {
    await Navigator.push(
        context,
        PageTransition(
            type: pageTransitionType,
            child: GalleryPickerView(
              onSelect: (media) {},
              locale: locale,
              multipleMediaBuilder: multipleMediaBuilder,
              heroBuilder: heroBuilder,
              singleMedia: singleMedia,
              config: config,
              initSelectedMedia: initSelectedMedia,
              extraRecentMedia: extraRecentMedia,
              startWithRecent: startWithRecent,
            )));
  }

  static Future<void> openSheet() async {
    BottomSheetPanel.open();
  }

  static Future<void> closeSheet() async {
    BottomSheetPanel.close();
  }

  static bool get isSheetOpened {
    return BottomSheetPanel.isOpen;
  }

  static bool get isSheetExpanded {
    return BottomSheetPanel.isExpanded;
  }

  static bool get isSheetCollapsed {
    return BottomSheetPanel.isCollapsed;
  }

  static Future<GalleryMedia?> collectGallery({Locale? locale}) async {
    return await PhoneGalleryController.collectGallery(locale: locale);
  }

  static Future<GalleryMedia?> initializeGallery({Locale? locale}) async {
    final controller = Get.put(PhoneGalleryController());
    await controller.initializeAlbums(locale: locale);
    return controller.media;
  }
}
