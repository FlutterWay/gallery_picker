import 'dart:async';
import 'package:get/get.dart';
import '../models/media_file.dart';

class PickerListener extends GetxController {
  StreamController<List<MediaFile>> controller =
      StreamController<List<MediaFile>>();

  Stream<List<MediaFile>> get stream => controller.stream;

  void updateController(List<MediaFile> medias) {
    controller.add(medias);
  }

  @override
  void dispose() {
    controller.close();
    GetInstance().delete<PickerListener>();
    super.dispose();
  }
}
