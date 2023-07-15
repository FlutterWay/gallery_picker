import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

import '/models/gallery_album.dart';
import '/models/medium.dart';
import '../models/config.dart';
import '../models/gallery_media.dart';
import '../models/media_file.dart';
import 'picker_listener.dart';

class PhoneGalleryController extends GetxController {
  late Config config;

  void configuration(Config? config,
      {required dynamic Function(List<MediaFile>) onSelect,
      required Widget Function(String, MediaFile, BuildContext)? heroBuilder,
      required bool isRecent,
      required bool startWithRecent,
      required List<MediaFile>? initSelectedMedias,
      required List<MediaFile>? extraRecentMedia,
      required Widget Function(List<MediaFile>, BuildContext)?
          multipleMediasBuilder}) {
    this.onSelect = onSelect;
    this.heroBuilder = heroBuilder;
    this.isRecent = isRecent;
    this.startWithRecent = startWithRecent;
    this.multipleMediasBuilder = multipleMediasBuilder;
    pageController = PageController();
    pickerPageController = PageController(initialPage: startWithRecent ? 0 : 1);
    this.config = config ?? Config();
    if (initSelectedMedias != null) {
      _selectedFiles = initSelectedMedias.map((e) => e).toList();
    }
    if (extraRecentMedia != null) {
      _extraRecentMedia = extraRecentMedia.map((e) => e).toList();
    }
    if (selectedFiles.isNotEmpty) {
      _pickerMode = true;
    }
    configurationCompleted = true;
  }

  late bool startWithRecent;
  late bool isRecent;
  bool? permissionGranted;
  bool configurationCompleted = false;
  late Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediasBuilder;
  GalleryMedia? _media;
  GalleryMedia? get media => _media;
  List<GalleryAlbum> get galleryAlbums => _media == null ? [] : _media!.albums;
  List<MediaFile> _selectedFiles = [];
  List<MediaFile>? _extraRecentMedia;
  List<MediaFile> get selectedFiles => _selectedFiles;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  List<MediaFile>? get extraRecentMedia => _extraRecentMedia;
  bool _pickerMode = false;
  bool get pickerMode => _pickerMode;
  late PageController pageController;
  late PageController pickerPageController;
  GalleryAlbum? selectedAlbum;

  void resetBottomSheetView() {
    if (permissionGranted == true) {
      isRecent = true;
      if (selectedAlbum == null) {
        pickerPageController.jumpToPage(0);
      } else {
        pageController.jumpToPage(0);
        pickerPageController = PageController();
      }
      selectedAlbum = null;
      update();
    }
  }

  void updateConfig(Config? config) {
    this.config = config ?? Config();
  }

  void updateSelectedFiles(List<MediaFile> media) {
    _selectedFiles = media.map((e) => e).toList();
    if (selectedFiles.isEmpty) {
      _pickerMode = false;
    } else {
      _pickerMode = true;
    }
    update();
  }

  void updateExtraRecentMedia(List<MediaFile> media) {
    _extraRecentMedia = media.map((e) => e).toList();
    GalleryAlbum? recentTmp = recent;
    if (recentTmp != null) {
      _extraRecentMedia!.removeWhere(
          (element) => recentTmp.files.any((file) => element.id == file.id));
    }
    update();
  }

  Future<void> changeAlbum(
      {required GalleryAlbum album,
      required BuildContext context,
      required PhoneGalleryController controller,
      required bool singleMedia,
      required bool isBottomSheet}) async {
    _selectedFiles.clear();
    selectedAlbum = album;
    update();
    updatePickerListener();
    await pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  Future<void> backToPicker() async {
    _selectedFiles.clear();
    _pickerMode = false;
    pickerPageController = PageController(initialPage: 1);
    update();
    await pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    selectedAlbum = null;
    update();
  }

  void unselectMedia(MediaFile file) {
    _selectedFiles.removeWhere((element) => element.id == file.id);
    if (_selectedFiles.isEmpty) {
      _pickerMode = false;
    }
    update();
    updatePickerListener();
  }

  void selectMedia(MediaFile file) {
    if (!_selectedFiles.any((element) => element.id == file.id)) {
      _selectedFiles.add(file);
    }
    if (!_pickerMode) {
      _pickerMode = true;
    }
    update();
    updatePickerListener();
  }

  void switchPickerMode(bool value) {
    if (!value) {
      _selectedFiles.clear();
      updatePickerListener();
    }
    _pickerMode = value;
    update();
  }

  void updatePickerListener() {
    if (GetInstance().isRegistered<PickerListener>()) {
      Get.find<PickerListener>().updateController(_selectedFiles);
    }
  }

  static Future<bool> promptPermissionSetting() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) {
        if (await PhoneGalleryController.requestPermission(Permission.photos)) {
          return await PhoneGalleryController.requestPermission(
              Permission.videos);
        } else {
          return false;
        }
      } else {
        return await PhoneGalleryController.requestPermission(
            Permission.storage);
      }
    }
    bool statusStorage =
        await PhoneGalleryController.requestPermission(Permission.storage);
    if (statusStorage) {
      return await PhoneGalleryController.requestPermission(Permission.photos);
    }
    return false;
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> initializeAlbums() async {
    _media = await PhoneGalleryController.collectGallery;
    if (_media != null) {
      if (_extraRecentMedia != null) {
        GalleryAlbum? recentTmp = recent;
        if (recentTmp != null) {
          _extraRecentMedia!.removeWhere((element) =>
              recentTmp.files.any((file) => element.id == file.id));
        }
      }
      permissionGranted = true;
      _isInitialized = true;
    } else {
      permissionGranted = false;
      permissionListener();
    }
    update();
  }

  void permissionListener() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await isGranted()) {
        initializeAlbums();
        timer.cancel();
      }
    });
  }

  Future<bool> isGranted() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) {
        if (await Permission.photos.isGranted) {
          return await Permission.videos.isGranted;
        } else {
          return false;
        }
      } else {
        return await Permission.storage.isGranted;
      }
    }
    return (await Permission.storage.isGranted) &&
        (await Permission.photos.isGranted);
  }

  static Future<GalleryMedia?> get collectGallery async {
    if (await promptPermissionSetting()) {
      List<GalleryAlbum> tempGalleryAlbums = [];

      List<Album> photoAlbums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      List<Album> videoAlbums =
          await PhotoGallery.listAlbums(mediumType: MediumType.video);
      for (var photoAlbum in photoAlbums) {
        GalleryAlbum entireGalleryAlbum = GalleryAlbum.album(photoAlbum);
        await entireGalleryAlbum.initialize();
        entireGalleryAlbum.setType = AlbumType.image;
        if (videoAlbums.any((element) => element.id == photoAlbum.id)) {
          Album videoAlbum =
              videoAlbums.singleWhere((element) => element.id == photoAlbum.id);
          GalleryAlbum videoGalleryAlbum = GalleryAlbum.album(videoAlbum);
          await videoGalleryAlbum.initialize();
          DateTime? lastPhotoDate = entireGalleryAlbum.lastDate;
          DateTime? lastVideoDate = videoGalleryAlbum.lastDate;

          if (lastPhotoDate == null) {
            try {
              entireGalleryAlbum.thumbnail =
                  await videoAlbum.getThumbnail(highQuality: true);
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          } else if (lastVideoDate == null) {
          } else {
            if (lastVideoDate.isAfter(lastPhotoDate)) {
              try {
                entireGalleryAlbum.thumbnail =
                    await videoAlbum.getThumbnail(highQuality: true);
              } catch (e) {
                entireGalleryAlbum.thumbnail = null;
                if (kDebugMode) {
                  print(e);
                }
              }
            }
          }
          for (var file in videoGalleryAlbum.files) {
            entireGalleryAlbum.addFile(file);
          }
          entireGalleryAlbum.sort();
          entireGalleryAlbum.setType = AlbumType.mixed;
          videoAlbums.remove(videoAlbum);
        }
        tempGalleryAlbums.add(entireGalleryAlbum);
      }
      for (var videoAlbum in videoAlbums) {
        GalleryAlbum galleryVideoAlbum = GalleryAlbum.album(videoAlbum);
        await galleryVideoAlbum.initialize();
        galleryVideoAlbum.setType = AlbumType.video;
        tempGalleryAlbums.add(galleryVideoAlbum);
      }

      return GalleryMedia(tempGalleryAlbums);
    } else {
      return null;
    }
  }

  GalleryAlbum? get recent {
    return galleryAlbums.isNotEmpty
        ? galleryAlbums.singleWhere((element) => element.album.name == "All")
        : null;
  }
  //GalleryAlbum? get recent {
  //  if (_isInitialized) {
  //    GalleryAlbum? recent;
  //    for (var album in _galleryAlbums) {
  //      if (recent == null || (album.count > recent.count)) {
  //        recent = album;
  //      }
  //    }
  //    if (recent != null) {
  //      return GalleryAlbum(
  //          album: recent.album,
  //          type: recent.type,
  //          thumbnail: recent.thumbnail,
  //          dateCategories: recent.dateCategories);
  //    } else {
  //      return null;
  //    }
  //  } else {
  //    return null;
  //  }
  //}

  List<Medium> sortAlbumMediaDates(List<Medium> mediumList) {
    mediumList.sort((a, b) {
      if (a.lastDate == null) {
        return 1;
      } else if (b.lastDate == null) {
        return -1;
      } else {
        return a.lastDate!.compareTo(b.lastDate!);
      }
    });
    return mediumList;
  }

  bool isSelectedMedia(MediaFile file) {
    return _selectedFiles.any((element) => element.id == file.id);
  }

  void disposeController() {
    _media = null;
    _selectedFiles = [];
    _isInitialized = false;
    Get.delete<PhoneGalleryController>();
    update();
  }
}
