import 'package:flutter/foundation.dart';

import 'gallery_album.dart';

class GalleryMedia {
  List<GalleryAlbum> albums;
  GalleryAlbum? get recent {
    return albums.singleWhere((element) => element.name == "All");
  }

  GalleryAlbum? getAlbum(String name) {
    try {
      return albums.singleWhere((element) => element.name == name);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  GalleryMedia(this.albums);
}
