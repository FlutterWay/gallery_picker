import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_picker/controller/gallery_controller.dart';
import '/gallery_picker.dart';
import '/views/gallery_picker_view/gallery_picker_view.dart';
import 'package:get/get.dart';
import '../controller/bottom_sheet_controller.dart';

class BottomSheetLayout extends StatefulWidget {
  final Widget child;
  final Config? config;
  final List<MediaFile>? initSelectedMedias;
  final Function(List<MediaFile> selectedMedias) onSelect;
  final Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  final Widget Function(List<MediaFile> medias, BuildContext context)?
      multipleMediasBuilder;
  final bool startWithRecent;
   BottomSheetLayout(
      {super.key,
      required this.child,
      required this.onSelect,
      this.config,
      this.heroBuilder,
      this.initSelectedMedias,
      this.multipleMediasBuilder,
      this.startWithRecent = true}){
        if(initSelectedMedias!=null&&GetInstance().isRegistered<PhoneGalleryController>()){
          Get.find<PhoneGalleryController>().updateSelectedFiles(initSelectedMedias!);
        }
      }

  @override
  State<BottomSheetLayout> createState() => _BottomSheetLayoutState();
}

class _BottomSheetLayoutState extends State<BottomSheetLayout> {
  BuildContext? collapsedContext;
  bool viewCollapsedPicker = false;
  BottomSheetBarController bottomSheetBarController =
      BottomSheetBarController();
  late BottomSheetController controller;

  @override
  void initState() {
    controller = Get.put(BottomSheetController(bottomSheetBarController));
    super.initState();
  }

  check() async {
    var sheetController = controller.sheetController;
    if (collapsedContext != null) {
      final RenderBox renderBox =
          collapsedContext!.findRenderObject() as RenderBox;
      if (renderBox.size.height > 200 &&
          !sheetController.isExpanded &&
          !viewCollapsedPicker) {
        await Future.delayed(Duration(milliseconds: 100));
        controller.appBarTapping = false;
        setState(() {
          viewCollapsedPicker = true;
        });
      } else if ((renderBox.size.height <= 200 || sheetController.isExpanded)) {
        if (viewCollapsedPicker) {
          viewCollapsedPicker = false;
          controller.appBarTapping = false;
          await Future.delayed(Duration(milliseconds: 10));
          setState(() {});
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomSheetController>(builder: (controller) {
      return BottomSheetBar(
        willPopScope: true,
        color: Colors.transparent,
        locked:
            (controller.sheetController.isExpanded && !controller.appBarTapping)
                ? true
                : false,
        controller: controller.sheetController,
        expandedBuilder: (scrollController) {
          check();
          return controller.sheetController.isExpanded
              ? GalleryPickerView(
                  onSelect: widget.onSelect,
                  config: widget.config,
                  sheetController: bottomSheetBarController,
                  heroBuilder: widget.heroBuilder,
                  multipleMediasBuilder: widget.multipleMediasBuilder,
                  initSelectedMedias: widget.initSelectedMedias,
                  startWithRecent: widget.startWithRecent,
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                );
        },
        body: widget.child,
        collapsed: GetBuilder<BottomSheetController>(
          builder: (controller) => ViewCollapsed(
              picker: GalleryPickerView(
                onSelect: widget.onSelect,
                config: widget.config,
                sheetController: bottomSheetBarController,
                heroBuilder: widget.heroBuilder,
                multipleMediasBuilder: widget.multipleMediasBuilder,
                initSelectedMedias: widget.initSelectedMedias,
                startWithRecent: widget.startWithRecent,
              ),
              viewPicker: controller.isClosing ? false : viewCollapsedPicker,
              onBuild: (context) {
                collapsedContext = context;
              }),
        ),
      );
    });
  }
}

class ViewCollapsed extends StatelessWidget {
  final GalleryPickerView picker;
  final bool viewPicker;
  final Function(BuildContext context) onBuild;
  ViewCollapsed({
    super.key,
    required this.picker,
    required this.onBuild,
    required this.viewPicker,
  });

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return Container(
      height: 50,
      color: Colors.transparent,
      child: viewPicker ? picker : null,
    );
  }
}
