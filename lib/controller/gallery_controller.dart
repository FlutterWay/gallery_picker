import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../models/config.dart';
import '../views/hero_page.dart';
import '/models/gallery_album.dart';
import '/models/medium.dart';
import '../models/media_file.dart';

class PhoneGalleryController extends GetxController {
  late Config config;

  PhoneGalleryController(Config? config,
      {required this.onSelect,
      required this.heroBuilder,
      required this.isRecent,
      required this.multipleMediaBuilder}) {
    this.config = config ?? Config();
  }
  bool isRecent;
  Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediaBuilder;
  GalleryAlbum? selectedAlbum;
  List<GalleryAlbum> _galleryAlbums = [];
  List<GalleryAlbum> get galleryAlbums => _galleryAlbums;
  List<MediaFile> _selectedFiles = [];
  List<MediaFile> get selectedFiles => _selectedFiles;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  bool _pickerMode = false;
  bool get pickerMode => _pickerMode;

  void changeAlbum(GalleryAlbum? album) {
    selectedAlbum = album;
    selectedFiles.clear();
    update();
  }

  void unselectMedia(MediaFile file) {
    _selectedFiles.remove(file);
    if (_selectedFiles.isEmpty) {
      _pickerMode = false;
    }
    update();
  }

  void selectMedia(MediaFile file) {
    if (!_selectedFiles.any((element) => element == file)) {
      _selectedFiles.add(file);
    }
    if (!_pickerMode) {
      _pickerMode = true;
    }
    update();
  }

  void switchPickerMode(bool value) {
    if (!value) {
      selectedFiles.clear();
    }
    _pickerMode = value;
    update();
  }

  Future<void> initializeAlbums() async {
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
            entireGalleryAlbum.thumbnail = await videoAlbum.getThumbnail(highQuality: true);
          } catch (e) {
            print(e);
          }
        } else if (lastVideoDate == null) {
        } else {
          if (lastVideoDate.isBefore(lastPhotoDate)) {
            try {
              entireGalleryAlbum.thumbnail = await videoAlbum.getThumbnail(highQuality: true);
            } catch (e) {
              entireGalleryAlbum.thumbnail = null;
              print(e);
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
      print(videoAlbum.name);
      GalleryAlbum galleryVideoAlbum = GalleryAlbum(album: videoAlbum);
      await galleryVideoAlbum.initialize();
      galleryVideoAlbum.setType = AlbumType.video;
      tempGalleryAlbums.add(galleryVideoAlbum);
    }

    _galleryAlbums = tempGalleryAlbums;
    _isInitialized = true;
    update();
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
    return _selectedFiles.any((element) => element == file);
  }
}
