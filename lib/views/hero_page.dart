import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/media_file.dart';

class HeroPage extends StatelessWidget {
  List<MediaFile> selectedMedias;
  String heroTag;
  Widget child;
  HeroPage(
      {super.key,
      required this.selectedMedias,
      required this.heroTag,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
