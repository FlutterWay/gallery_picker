import 'package:flutter/material.dart';
import '../models/media_file.dart';
import '../views/gridview_static.dart';
import '/models/gallery_album.dart';
import 'thumbnail_media.dart';

class DateCategoryWiew extends StatelessWidget {
  TextStyle? textStyle;
  final Widget Function(MediaFile media, BuildContext context)?
      onMediaErrorBuilder;
  DateCategoryWiew(
      {super.key,
      required this.category,
      this.textStyle,
      this.onMediaErrorBuilder});
  DateCategory category;

  int getRowCount() {
    if (category.files.length % 4 != 0) {
      return category.files.length ~/ 4 + 1;
    } else {
      return category.files.length ~/ 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: textStyle,
                ),
              ),
            ),
            GridViewStatic(
              size: MediaQuery.of(context).size.width,
              padding: EdgeInsets.zero,
              crossAxisCount: 4,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: <Widget>[
                ...category.files.map(
                  (medium) => ThumbnailMedia(
                    media: medium,
                    onErrorBuilder: onMediaErrorBuilder,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
