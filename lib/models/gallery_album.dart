import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../controller/gallery_controller.dart';
import '/models/media_file.dart';
import '/models/medium.dart';
import 'config.dart';

class GalleryAlbum {
  late Album album;
  List<int>? thumbnail;
  List<DateCategory> dateCategories = [];
  late AlbumType type;
  int get count =>
      dateCategories.expand((element) => element.files).toList().length;
  String? get name => album.name;

  GalleryAlbum.album(this.album);

  GalleryAlbum(
      {required this.album,
      required this.type,
      this.thumbnail,
      this.dateCategories = const []});

  List<MediaFile> get medias {
    return dateCategories
        .expand<MediaFile>((element) => element.files)
        .toList();
  }

  set setType(AlbumType type) {
    this.type = type;
  }

  IconData get icon {
    switch (type) {
      case AlbumType.image:
        return Icons.image;
      case AlbumType.video:
        return Icons.videocam;
      case AlbumType.mixed:
        return Icons.perm_media_outlined;
    }
  }

  Future<void> initialize() async {
    List<DateCategory> dateCategory = [];
    for (var medium in sortAlbumMediaDates((await album.listMedia()).items)) {
      MediaFile mediaFile = MediaFile.medium(medium);
      String name = getDateCategory(mediaFile);
      if (dateCategory.any((element) => element.name == name)) {
        dateCategory
            .singleWhere((element) => element.name == name)
            .files
            .add(mediaFile);
      } else {
        dateCategory.add(DateCategory(files: [mediaFile], name: name));
      }
    }
    dateCategories = dateCategory;
    try {
      thumbnail = await album.getThumbnail(highQuality: true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  DateTime? get lastDate {
    if (dateCategories.isNotEmpty &&
        dateCategories.first.files.first.medium != null) {
      return dateCategories.first.files.first.medium!.lastDate;
    } else {
      return null;
    }
  }

  List<MediaFile> get files =>
      dateCategories.expand((element) => element.files).toList();

  String getDateCategory(MediaFile media) {
    Config config = GetInstance().isRegistered<PhoneGalleryController>()
        ? Get.find<PhoneGalleryController>().config
        : Config();
    DateTime? lastDate = media.lastModified;
    lastDate = lastDate ?? DateTime.now();
    if (daysBetween(lastDate) <= 3) {
      return config.recent;
    } else if (daysBetween(lastDate) > 3 && daysBetween(lastDate) <= 7) {
      return config.lastWeek;
    } else if (daysBetween(lastDate) > 7 && daysBetween(lastDate) <= 31) {
      return config.lastMonth;
    } else if (daysBetween(lastDate) > 31 && daysBetween(lastDate) <= 365) {
      return DateFormat.MMMM().format(lastDate).toString();
    } else {
      return DateFormat.y().format(lastDate).toString();
    }
  }

  int daysBetween(DateTime from) {
    from = DateTime(from.year, from.month, from.day);
    return (DateTime.now().difference(from).inHours / 24).round();
  }

  static List<Medium> sortAlbumMediaDates(List<Medium> mediumList) {
    mediumList.sort((a, b) {
      if (a.lastDate == null) {
        return 1;
      } else if (b.lastDate == null) {
        return -1;
      } else {
        return b.lastDate!.compareTo(a.lastDate!);
      }
    });
    return mediumList;
  }

  sort() {
    dateCategories.sort(
        (a, b) => a.getIndexOfCategory().compareTo(b.getIndexOfCategory()));

    for (var category in dateCategories) {
      category.files.sort((a, b) {
        if (a.medium == null) {
          return 1;
        } else if (b.medium == null) {
          return -1;
        } else {
          return b.medium!.lastDate!.compareTo(a.medium!.lastDate!);
        }
      });
    }
  }

  void addFile(MediaFile file) {
    String name = getDateCategory(file);
    if (dateCategories.any((element) => element.name == name)) {
      dateCategories
          .singleWhere((element) => element.name == name)
          .files
          .add(file);
    } else {
      dateCategories.add(DateCategory(files: [file], name: name));
    }
  }
}

class DateCategory {
  String name;
  List<MediaFile> files;
  DateCategory({required this.files, required this.name});

  int getIndexOfCategory() {
    Config config = GetInstance().isRegistered<PhoneGalleryController>()
        ? Get.find<PhoneGalleryController>().config
        : Config();
    int index = [
      config.recent,
      config.lastWeek,
      config.lastMonth,
      ...config.months
    ].indexOf(name);
    if (index == -1) {
      return 3000 - int.parse(name);
    } else {
      return index;
    }
  }
}

enum AlbumType { video, image, mixed }
