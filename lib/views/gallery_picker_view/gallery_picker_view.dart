import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bottom_sheet_controller.dart';
import '../../controller/gallery_controller.dart';
import '../../models/config.dart';
import '../../models/media_file.dart';
import '../album_categories_view/album_categories_view.dart';
import '../album_view/album_page.dart';
import '../album_view/album_medias_view.dart';
import 'picker_appbar.dart';
import 'reload_gallery.dart';

class GalleryPickerView extends StatefulWidget {
  Config? config;
  Function(List<MediaFile> selectedMedias) onSelect;
  Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediasBuilder;
  bool startWithRecent;
  BottomSheetBarController? sheetController;
  List<MediaFile>? initSelectedMedias;
  bool singleMedia;
  GalleryPickerView(
      {super.key,
      this.config,
      required this.onSelect,
      this.initSelectedMedias,
      this.singleMedia=false,
      this.sheetController,
      this.heroBuilder,
      this.multipleMediasBuilder,
      this.startWithRecent = false});

  @override
  State<GalleryPickerView> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPickerView> {
  late PhoneGalleryController galleryController;
  BottomSheetController? bottomSheetController;
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
          multipleMediasBuilder: widget.multipleMediasBuilder,
          initSelectedMedias:widget.initSelectedMedias,
          isRecent: widget.startWithRecent));
      config = galleryController.config;
    }

    if (widget.sheetController != null) {
      if (GetInstance().isRegistered<BottomSheetController>()) {
        bottomSheetController = Get.find<BottomSheetController>();
      } else {
        bottomSheetController =
            Get.put(BottomSheetController(widget.sheetController!));
      }
      bottomSheetController!.galleryController = galleryController;
    }
    if (!galleryController.isInitialized) {
      galleryController.initializeAlbums();
    }
    if (galleryController.isRecent) {
      _scrollController = PageController(initialPage: 0);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<PhoneGalleryController>(builder: (controller) {
      return GetInstance().isRegistered<PhoneGalleryController>()
          ? controller.selectedAlbum == null
              ? Scaffold(
                  backgroundColor: config.backgroundColor,
                  appBar: PickerAppBar(
                    controller: controller,
                    bottomSheetController: bottomSheetController,
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
                              decoration: controller.isRecent
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
                                        duration:
                                            const Duration(milliseconds: 50),
                                        curve: Curves.easeIn);
                                    setState(() {
                                      controller.isRecent = true;
                                      controller.switchPickerMode(false);
                                    });
                                  },
                                  child: Text(config.recents,
                                      style: controller.isRecent
                                          ? config.selectedMenuStyle
                                          : config.unselectedMenuStyle)),
                            ),
                            Container(
                              decoration: !controller.isRecent
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
                                        duration:
                                            const Duration(milliseconds: 50),
                                        curve: Curves.easeIn);
                                    controller.isRecent = false;
                                    controller.switchPickerMode(false);
                                  },
                                  child: Text(
                                    config.gallery,
                                    style: controller.isRecent
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
                                controller.isRecent = true;
                                controller.switchPickerMode(false);
                              } else {
                                controller.isRecent = false;
                                controller.switchPickerMode(false);
                              }
                            },
                            scrollDirection: Axis.horizontal,
                            children: [
                              controller.isInitialized
                                  ? AlbumMediasView(
                                      galleryAlbum: controller.recent!,
                                      controller: controller,
                                      singleMedia:widget.singleMedia
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    )),
                              AlbumCategoriesView(controller)
                            ]),
                      ),
                    ],
                  ),
                )
              : AlbumPage(
                  controller: controller,
                  album: controller.selectedAlbum!,
                  singleMedia: widget.singleMedia,
                  bottomSheetController: bottomSheetController,
                )
          : ReloadGallery(
              config,
              onpressed: () async {
                if (widget.sheetController != null) {
                  bottomSheetController =
                      Get.put(BottomSheetController(widget.sheetController!));
                }
                galleryController = Get.put(PhoneGalleryController(config,
                    onSelect: widget.onSelect,
                    heroBuilder: widget.heroBuilder,
                    initSelectedMedias:widget.initSelectedMedias,
                    multipleMediasBuilder: widget.multipleMediasBuilder,
                    isRecent: widget.startWithRecent));
                await controller.initializeAlbums();
                if (bottomSheetController != null) {
                  bottomSheetController!.galleryController = galleryController;
                }
                setState(() {});
              },
            );
    });
  }
}
