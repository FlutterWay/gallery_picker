library gallery_picker;

export 'models/config.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controller/gallery_controller.dart';
import 'models/config.dart';
import 'models/media_file.dart';
import 'views/album_category_view/gallery_categories_widget.dart';
import 'views/album_view/gallery_category_view_page.dart';
import 'views/album_view/gallery_category_view_widget.dart';
import 'views/hero_page.dart';

void disposeGalleryPicker() {
  GetInstance().delete<PhoneGalleryController>();
}

class GalleryPicker extends StatefulWidget {
  Config? config;
  Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediaBuilder;
  bool startWithRecent;
  GalleryPicker(
      {super.key,
      this.config,
      required this.onSelect,
      this.heroBuilder,
      this.multipleMediaBuilder,
      this.startWithRecent = false});

  @override
  State<GalleryPicker> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker> {
  late PhoneGalleryController galleryController;
  late PageController _scrollController;
  bool noPhotoSeleceted = true;
  late Config config;
  @override
  void initState() {
    _scrollController =
        PageController(initialPage: widget.startWithRecent ? 0 : 1);
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      galleryController = Get.find<PhoneGalleryController>();
      config = galleryController.config;
    } else {
      galleryController = Get.put(PhoneGalleryController(widget.config,
          onSelect: widget.onSelect,
          heroBuilder: widget.heroBuilder,
          multipleMediaBuilder: widget.multipleMediaBuilder,
          isRecent: widget.startWithRecent));
      config = galleryController.config;
    }
    if (!galleryController.isInitialized) {
      initializeGallery();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeGallery() async {
    if (await _promptPermissionSetting()) {
      print("granted");
      await galleryController.initializeAlbums();
    }
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 119;
    return GetBuilder<PhoneGalleryController>(builder: (galleryController) {
      return galleryController.selectedAlbum == null
          ? Scaffold(
              backgroundColor: config.backgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: config.appbarColor,
                leading: TextButton(
                    onPressed: () {
                      galleryController.switchPickerMode(false);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: config.appbarIconColor,
                    )),
                title: getTitle(),
                actions: [
                  !galleryController.pickerMode && galleryController.isRecent
                      ? TextButton(
                          onPressed: () {
                            galleryController.switchPickerMode(true);
                          },
                          child: Icon(
                            Icons.check_box_outlined,
                            color: config.appbarIconColor,
                          ))
                      : const SizedBox()
                ],
              ),
              body: Column(
                children: [
                  Container(
                    width: width,
                    height: 48,
                    color: config.appbarColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: galleryController.isRecent
                              ? BoxDecoration(
                                  border: Border(
                                  bottom: BorderSide(
                                    color: config.underlineColor,
                                    width: 3.0,
                                  ),
                                ))
                              : null,
                          height: 48,
                          width: width / 2,
                          child: TextButton(
                              onPressed: () {
                                _scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 50),
                                    curve: Curves.easeIn);
                                setState(() {
                                  galleryController.isRecent = true;
                                  galleryController.switchPickerMode(false);
                                });
                              },
                              child: Text(config.recents,
                                  style: galleryController.isRecent
                                      ? config.selectedMenuStyle
                                      : config.unselectedMenuStyle)),
                        ),
                        Container(
                          decoration: !galleryController.isRecent
                              ? BoxDecoration(
                                  border: Border(
                                  bottom: BorderSide(
                                    color: config.underlineColor,
                                    width: 3.0,
                                  ),
                                ))
                              : null,
                          height: 48,
                          width: width / 2,
                          child: TextButton(
                              onPressed: () {
                                _scrollController.animateTo(width,
                                    duration: const Duration(milliseconds: 50),
                                    curve: Curves.easeIn);
                                galleryController.isRecent = false;
                                galleryController.switchPickerMode(false);
                              },
                              child: Text(
                                config.gallery,
                                style: galleryController.isRecent
                                    ? config.unselectedMenuStyle
                                    : config.selectedMenuStyle,
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                        controller: _scrollController,
                        onPageChanged: (value) {
                          if (value == 0) {
                            galleryController.isRecent = true;
                            galleryController.switchPickerMode(false);
                          } else {
                            galleryController.isRecent = false;
                            galleryController.switchPickerMode(false);
                          }
                        },
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                              width: width,
                              height: height - 48,
                              child: galleryController.isInitialized
                                  ? GalleryCategoryViewWidget(
                                      galleryAlbum: galleryController.recent!,
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ))),
                          SizedBox(
                              width: width,
                              height: height - 48,
                              child: GalleryCategoriesWidget())
                        ]),
                  ),
                ],
              ),
            )
          : GalleryAlbumViewPage(
              album: galleryController.selectedAlbum!,
            );
    });
  }

  Widget getTitle() {
    if (galleryController.pickerMode &&
        galleryController.selectedFiles.isEmpty) {
      return Text(
        config.tapPhotoSelect,
        style: config.appbarTextStyle,
      );
    } else if (galleryController.pickerMode &&
        galleryController.selectedFiles.isNotEmpty) {
      return Text(
        "${galleryController.selectedFiles.length} ${config.selected}",
        style: config.appbarTextStyle,
      );
    } else {
      return const SizedBox();
    }
  }
}
