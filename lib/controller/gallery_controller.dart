import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../models/config.dart';
import '../models/gallery_media.dart';
import '/models/gallery_album.dart';
import '/models/medium.dart';
import '../models/media_file.dart';
import 'picker_listener.dart';

class PhoneGalleryController extends GetxController {
  late Config config;

  PhoneGalleryController(Config? config,
      {required this.onSelect,
      required this.heroBuilder,
      required this.isRecent,
      List<MediaFile>? initSelectedMedias,
      required this.multipleMediasBuilder}) {
    this.config = config ?? Config();
    if (initSelectedMedias != null) {
      _selectedFiles = initSelectedMedias.map((e) => e).toList();
    }
  }
  bool isRecent;
  Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediasBuilder;
  GalleryAlbum? selectedAlbum;
  List<GalleryAlbum> _galleryAlbums = [];
  List<GalleryAlbum> get galleryAlbums => _galleryAlbums;
  List<MediaFile> _selectedFiles = [];
  List<MediaFile> get selectedFiles => _selectedFiles;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  bool _pickerMode = false;
  bool get pickerMode => _pickerMode;

  void updateSelectedFiles(List<MediaFile> medias) {
    _selectedFiles = medias;
    if (selectedFiles.isNotEmpty) {
      _pickerMode = true;
    }
    update();
  }

  void changeAlbum(GalleryAlbum? album) {
    selectedAlbum = album;
    _selectedFiles.clear();
    update();
    updatePickerListener();
  }

  void unselectMedia(MediaFile file) {
    _selectedFiles.remove(file);
    if (_selectedFiles.isEmpty) {
      _pickerMode = false;
    }
    update();
    updatePickerListener();
  }

  void selectMedia(MediaFile file) {
    if (!_selectedFiles.any((element) => element == file)) {
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
    }
    _pickerMode = value;
    update();
    updatePickerListener();
  }

  void updatePickerListener() {
    if (GetInstance().isRegistered<PickerListener>()) {
      Get.find<PickerListener>().updateController(_selectedFiles);
    }
  }

  static Future<bool> promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<void> initializeAlbums() async {
    GalleryMedia? media = await PhoneGalleryController.collectGallery;
    if (media != null) {
      _galleryAlbums = media.albums;
    }
    _isInitialized = true;
    update();
  }

  static Future<GalleryMedia?> get collectGallery async {
    if (await promptPermissionSetting()) {
      List<GalleryAlbum> tempGalleryAlbums = [];

      List<Album> photoAlbums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      List<Album> videoAlbums =
          await PhotoGallery.listAlbums(mediumType: MediumType.video);

      for (var photoAlbum in photoAlbums) {
        GalleryAlbum entireGalleryAlbum = GalleryAlbum(album: photoAlbum);
        await entireGalleryAlbum.initialize();
        entireGalleryAlbum.setType = AlbumType.image;
        if (videoAlbums.any((element) => element.name == photoAlbum.name)) {
          Album videoAlbum = videoAlbums
              .singleWhere((element) => element.name == photoAlbum.name);
          GalleryAlbum videoGalleryAlbum = GalleryAlbum(album: videoAlbum);
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
        GalleryAlbum galleryVideoAlbum = GalleryAlbum(album: videoAlbum);
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
    return _isInitialized
        ? _galleryAlbums.singleWhere((element) => element.album.name == "All")
        : null;
  }

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
    return _selectedFiles.any((element) => element.medium.id == file.medium.id);
  }

  void disposeController() {
    _galleryAlbums = [];
    _selectedFiles = [];
    _isInitialized = false;
    selectedAlbum = null;
    Get.delete<PhoneGalleryController>();
    update();
  }
}
