import 'package:flutter/material.dart';
import 'package:gallery_picker/views/album_view/album_appbar.dart';
import '../../../controller/gallery_controller.dart';
import '../../../models/gallery_album.dart';
import '../../controller/bottom_sheet_controller.dart';
import '../../models/config.dart';
import 'album_medias_view.dart';

class AlbumPage extends StatelessWidget {
  bool singleMedia;
  AlbumPage(
      {super.key,
      required this.album,
      required this.controller,
      required this.singleMedia,
      required this.bottomSheetController});
  PhoneGalleryController controller;
  BottomSheetController? bottomSheetController;
  GalleryAlbum album;
  @override
  Widget build(BuildContext context) {
    Config config = controller.config;
    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AlbumAppBar(
          bottomSheetController: bottomSheetController,
          album: album,
          controller: controller),
      body: AlbumMediasView(
        galleryAlbum: album,
        controller: controller,
        singleMedia: singleMedia,
      ),
    );
  }
}
