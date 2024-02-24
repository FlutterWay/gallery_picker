import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/gallery_controller.dart';
import '../../models/config.dart';
import '../../models/gallery_album.dart';
import '../../models/media_file.dart';
import '../album_categories_view/album_categories_view.dart';
import '../album_view/album_medias_view.dart';
import '../album_view/album_page.dart';
import 'permission_denied_view.dart';
import 'picker_appbar.dart';
import 'reload_gallery.dart';

class GalleryPickerView extends StatefulWidget {
  final Config? config;
  final Function(List<MediaFile> selectedMedia) onSelect;
  final Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  final Widget Function(List<MediaFile> media, BuildContext context)?
      multipleMediaBuilder;
  final bool startWithRecent;
  final bool isBottomSheet;
  final Locale? locale;
  final List<MediaFile>? initSelectedMedia;
  final List<MediaFile>? extraRecentMedia;
  final bool singleMedia;
  const GalleryPickerView(
      {super.key,
      this.config,
      required this.onSelect,
      this.initSelectedMedia,
      this.extraRecentMedia,
      this.singleMedia = false,
      this.isBottomSheet = false,
      this.heroBuilder,
      this.locale,
      this.multipleMediaBuilder,
      this.startWithRecent = false});

  @override
  State<GalleryPickerView> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPickerView> {
  late PhoneGalleryController galleryController;
  bool noPhotoSeleceted = true;
  late Config config;
  @override
  void initState() {
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      galleryController = Get.find<PhoneGalleryController>();
      if (galleryController.configurationCompleted) {
        galleryController.updateConfig(widget.config);
      } else {
        galleryController.configuration(widget.config,
            onSelect: widget.onSelect,
            startWithRecent: widget.startWithRecent,
            heroBuilder: widget.heroBuilder,
            multipleMediasBuilder: widget.multipleMediaBuilder,
            initSelectedMedias: widget.initSelectedMedia,
            extraRecentMedia: widget.extraRecentMedia,
            isRecent: widget.startWithRecent);
      }
    } else {
      galleryController = Get.put(PhoneGalleryController());
      galleryController.configuration(widget.config,
          onSelect: widget.onSelect,
          startWithRecent: widget.startWithRecent,
          heroBuilder: widget.heroBuilder,
          multipleMediasBuilder: widget.multipleMediaBuilder,
          initSelectedMedias: widget.initSelectedMedia,
          extraRecentMedia: widget.extraRecentMedia,
          isRecent: widget.startWithRecent);
    }
    config = galleryController.config;
    if (!galleryController.isInitialized) {
      galleryController.initializeAlbums(locale: widget.locale);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GalleryAlbum? selectedAlbum;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<PhoneGalleryController>(builder: (controller) {
      return GetInstance().isRegistered<PhoneGalleryController>()
          ? controller.permissionGranted != false
              ? PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PopScope(
                        canPop: true,
                        onPopInvoked: (value) {
                          if (!widget.isBottomSheet) {
                            controller.disposeController();
                          }
                        },
                        child: Scaffold(
                          backgroundColor: config.backgroundColor,
                          appBar: PickerAppBar(
                            controller: controller,
                            isBottomSheet: widget.isBottomSheet,
                          ),
                          body: Column(
                            children: [
                              Container(
                                width: width,
                                height: 48,
                                color: config.appbarColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                            controller.pickerPageController
                                                .animateToPage(0,
                                                    duration: const Duration(
                                                        milliseconds: 50),
                                                    curve: Curves.easeIn);
                                            setState(() {
                                              controller.isRecent = true;
                                              controller
                                                  .switchPickerMode(false);
                                            });
                                          },
                                          child: Text(config.recents,
                                              style: controller.isRecent
                                                  ? config.selectedMenuStyle
                                                  : config
                                                      .unselectedMenuStyle)),
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
                                            controller.pickerPageController
                                                .animateToPage(1,
                                                    duration: const Duration(
                                                        milliseconds: 50),
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
                                    controller: controller.pickerPageController,
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
                                      controller.isInitialized &&
                                              controller.recent != null
                                          ? AlbumMediasView(
                                              galleryAlbum: controller.recent!,
                                              controller: controller,
                                              isBottomSheet:
                                                  widget.isBottomSheet,
                                              singleMedia: widget.singleMedia)
                                          : const Center(
                                              child: CircularProgressIndicator(
                                              color: Colors.grey,
                                            )),
                                      AlbumCategoriesView(
                                        controller: controller,
                                        isBottomSheet: widget.isBottomSheet,
                                        singleMedia: widget.singleMedia,
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        )),
                    AlbumPage(
                        album: controller.selectedAlbum,
                        controller: controller,
                        singleMedia: widget.singleMedia,
                        isBottomSheet: widget.isBottomSheet)
                  ],
                )
              : Material(
                  child: controller.config.permissionDeniedPage ??
                      PermissionDeniedView(
                        config: controller.config,
                      ),
                )
          : ReloadGallery(
              config,
              onpressed: () async {
                galleryController = Get.put(PhoneGalleryController());
                galleryController.configuration(widget.config,
                    onSelect: widget.onSelect,
                    startWithRecent: widget.startWithRecent,
                    heroBuilder: widget.heroBuilder,
                    multipleMediasBuilder: widget.multipleMediaBuilder,
                    initSelectedMedias: widget.initSelectedMedia,
                    extraRecentMedia: widget.extraRecentMedia,
                    isRecent: widget.startWithRecent);
                if (!controller.isInitialized) {
                  await controller.initializeAlbums(locale: widget.locale);
                }
                setState(() {});
              },
            );
    });
  }
}
