import 'package:flutter/foundation.dart';

import 'gallery_album.dart';

class GalleryMedia {
  List<GalleryAlbum> albums;
  GalleryAlbum? get recent {
    return albums.singleWhere((element) => element.album.name == "All");
  }

  GalleryAlbum? getAlbum(String name) {
    try {
      return albums.singleWhere((element) => element.album.name == name);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  GalleryMedia(this.albums);
}
