import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

enum MediaType { image, video }

class MediaFile {
  Medium? _medium;
  File? _file;
  Uint8List? thumbnail;
  late MediaType _type;
  late String _id;
  bool get isVideo => _type == MediaType.video;
  bool get isImage => _type == MediaType.image;
  Medium? get medium => _medium;
  MediaType get type => _type;
  String get id => _id;
  File? get file => _file;
  DateTime? get lastModified =>
      _medium != null ? _medium!.modifiedDate : _file!.lastModifiedSync();

  MediaFile.medium(Medium medium) {
    _medium = medium;
    _type = _medium!.mediumType == MediumType.video
        ? MediaType.video
        : MediaType.image;
    _id = _medium!.id;
  }
  MediaFile.file(
      {required String id, required File file, required MediaType type}) {
    _file = file;
    _id = id;
    _type = type;
  }

  Future<Uint8List> getThumbnail({bool highQuality = true}) async {
    if (_medium == null) {
      thumbnail = isVideo
          ? (await VideoThumbnail.thumbnailData(
              video: _file!.path,
              imageFormat: ImageFormat.JPEG,
              quality: highQuality ? 100 : 20,
            ))!
          : await getData();
    } else {
      thumbnail = Uint8List.fromList(
          await _medium!.getThumbnail(highQuality: highQuality));
    }
    return thumbnail!;
  }

  Future<File> getFile() async {
    if (_medium != null) {
      return await _medium!.getFile();
    } else {
      return _file!;
    }
  }

  Future<Uint8List> getData() async {
    _file ??= await getFile();
    return _file!.readAsBytesSync();
  }
}
