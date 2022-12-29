import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:get/get.dart';

import 'gallery_controller.dart';

class BottomSheetController extends GetxController {
  BottomSheetBarController sheetController;
  PhoneGalleryController? galleryController;
  bool isClosing = false;
  bool appBarTapping = false;

  Future<void> open() async {
    await sheetController.expand();
  }

  void tapingStatus(bool value) {
    appBarTapping = value;
    if (galleryController == null) {
      Get.find<PhoneGalleryController>().update();
    } else {
      galleryController!.update();
    }
    update();
  }

  Future<void> close() async {
    isClosing = true;
    update();
    await sheetController.collapse();
    isClosing = false;
    update();
  }

  void disposeController() {
    isClosing = false;
    appBarTapping = false;
    GetInstance().delete<BottomSheetController>();
  }

  BottomSheetController(this.sheetController);
}
