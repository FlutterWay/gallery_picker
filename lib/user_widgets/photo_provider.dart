import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/media_file.dart';

class PhotoProvider extends StatelessWidget {
  final MediaFile media;
  final BoxFit fit;
  final double? width, height;
  final Color? backgroundColor;
  final Widget Function(BuildContext context)? onFailBuilder;

  const PhotoProvider({
    super.key,
    required this.media,
    this.onFailBuilder,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: media.getData(),
      builder: ((context, snapshot) {
        return Container(
          color: backgroundColor,
          width: width,
          height: height,
          child: (snapshot.hasError && onFailBuilder != null)
              ? onFailBuilder!(context)
              : (snapshot.hasData)
                  ? FadeInImage(
                      fadeInDuration: const Duration(milliseconds: 200),
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: MemoryImage(snapshot.data!),
                    )
                  : const SizedBox(),
        );
      }),
    );
  }
}
