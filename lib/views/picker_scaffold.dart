import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/controller/gallery_controller.dart';
import '/gallery_picker.dart';
import 'package:get/get.dart';

class PickerScaffold extends StatelessWidget {
  PickerScaffold(
      {super.key,
      required this.onSelect,
      this.body,
      this.appBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
      this.drawer,
      this.onDrawerChanged,
      this.endDrawer,
      this.onEndDrawerChanged,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.primary = true,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      this.drawerEnableOpenDragGesture = true,
      this.endDrawerEnableOpenDragGesture = true,
      this.restorationId,
      this.config,
      this.heroBuilder,
      this.initSelectedMedia,
      this.extraRecentMedia,
      this.singleMedia = false,
      this.multipleMediaBuilder,}) {
    if (GetInstance().isRegistered<PhoneGalleryController>()) {
      if (initSelectedMedia != null) {
        Get.find<PhoneGalleryController>()
            .updateSelectedFiles(initSelectedMedia!);
      }
      if (extraRecentMedia != null) {
        Get.find<PhoneGalleryController>()
            .updateExtraRecentMedia(extraRecentMedia!);
      }
    }
  }

  final Widget? body;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final Config? config;
  final List<MediaFile>? initSelectedMedia;
  final List<MediaFile>? extraRecentMedia;
  final bool singleMedia;
  final Function(List<MediaFile> selectedMedia) onSelect;
  final Widget Function(String tag, MediaFile media, BuildContext context)?
      heroBuilder;
  final Widget Function(List<MediaFile> media, BuildContext context)?
      multipleMediaBuilder;
  @override
  Widget build(BuildContext context) {
    return BottomSheetScaffold(
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      floatingActionButtonLocation: floatingActionButtonLocation,
      persistentFooterAlignment: persistentFooterAlignment,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      drawerScrimColor: drawerScrimColor,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      restorationId: restorationId,
      primary: primary,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
      bottomSheet: DraggableBottomSheet(
        draggableBody: true,
        maxHeight: MediaQuery.of(context).size.height,
        onHide: () {
          if (GetInstance().isRegistered<PhoneGalleryController>()) {
            Get.find<PhoneGalleryController>().resetBottomSheetView();
          }
        },
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GalleryPickerView(
              onSelect: onSelect,
              config: config,
              heroBuilder: heroBuilder,
              multipleMediaBuilder: multipleMediaBuilder,
              singleMedia: singleMedia,
              isBottomSheet: true,
              initSelectedMedia: initSelectedMedia,
              extraRecentMedia: extraRecentMedia,
              startWithRecent: true,
            )),
      ),
    );
  }
}
