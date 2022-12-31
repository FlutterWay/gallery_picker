import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/picker_listener.dart';
import '../models/media_file.dart';

class GalleryPickerBuilder extends StatelessWidget {
  final Widget Function(List<MediaFile>? selectedFiles, BuildContext context)
      builder;
  GalleryPickerBuilder({super.key, required this.builder}) {
    Get.put(PickerListener());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Get.find<PickerListener>().stream,
        builder: ((context, snapshot) {
          return builder(snapshot.data, context);
        }));
  }
}
