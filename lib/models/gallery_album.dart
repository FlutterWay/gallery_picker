import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '/models/media_file.dart';
import '/models/medium.dart';

class GalleryAlbum {
  Album album;
  late List<int>? thumbnail;
  List<DateCategory> dateCategories = [];
  int get count =>
      dateCategories.expand((element) => element.files).toList().length;
  String? get name => album.name;

  List<MediaFile> get medias {
    return dateCategories
        .expand<MediaFile>((element) => element.files)
        .toList();
  }

  late AlbumType type;

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

  GalleryAlbum({
    required this.album,
  });

  Future<void> initialize() async {
    List<DateCategory> dateCategory = [];
    for (var medium in sortAlbumMediaDates((await album.listMedia()).items)) {
      MediaFile mediaFile = MediaFile(medium: medium);
      String name = getDateCategory(medium);
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
    if (dateCategories.isNotEmpty) {
      return dateCategories.first.files.first.medium.lastDate;
    } else {
      return null;
    }
  }

  List<MediaFile> get files =>
      dateCategories.expand((element) => element.files).toList();

  String getDateCategory(Medium mediaFile) {
    if (daysBetween(mediaFile.lastDate!) <= 3) {
      return "Recent";
    } else if (daysBetween(mediaFile.lastDate!) > 3 &&
        daysBetween(mediaFile.lastDate!) <= 7) {
      return "Last week";
    } else if (daysBetween(mediaFile.lastDate!) > 7 &&
        daysBetween(mediaFile.lastDate!) <= 31) {
      return "Last month";
    } else if (daysBetween(mediaFile.lastDate!) > 31 &&
        daysBetween(mediaFile.lastDate!) <= 365) {
      return DateFormat.MMMM().format(mediaFile.lastDate!).toString();
    } else {
      return DateFormat.y().format(mediaFile.lastDate!).toString();
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
        return a.lastDate!.compareTo(b.lastDate!);
      }
    });
    return mediumList;
  }

  sort() {
    dateCategories.sort(
        (a, b) => a.getIndexOfCategory().compareTo(b.getIndexOfCategory()));

    for (var category in dateCategories) {
      category.files.sort((a, b) {
        if (a.medium.lastDate == null) {
          return 1;
        } else if (b.medium.lastDate == null) {
          return -1;
        } else {
          return b.medium.lastDate!.compareTo(a.medium.lastDate!);
        }
      });
    }
  }

  void addFile(MediaFile file) {
    String name = getDateCategory(file.medium);
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

List<String> dates = [
  "Recent",
  "Last week",
  "Last month",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class DateCategory {
  String name;
  List<MediaFile> files;
  DateCategory({required this.files, required this.name});

  int getIndexOfCategory() {
    int index = dates.indexOf(name);
    if (index == -1) {
      return 3000 - int.parse(name);
    } else {
      return index;
    }
  }
}

enum AlbumType { video, image, mixed }
