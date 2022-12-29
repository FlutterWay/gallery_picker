import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controller/picker_listener.dart';
import '../models/media_file.dart';

class FilesStreamBuilder extends StatelessWidget {
  final Widget Function(List<MediaFile>? medias, BuildContext context) builder;
  FilesStreamBuilder({super.key, required this.builder}) {
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
