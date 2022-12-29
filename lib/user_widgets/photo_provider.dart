import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';

import '../models/media_file.dart';

class PhotoProvider extends StatefulWidget {
  final MediaFile media;
  final BoxFit fit;
  final double? width, height;

  const PhotoProvider({
    super.key,
    required this.media,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  _PhotoProviderState createState() => _PhotoProviderState();
}

class _PhotoProviderState extends State<PhotoProvider> {
  VideoPlayerController? _controller;
  late MediaFile media;
  @override
  void initState() {
    media = widget.media;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initMedia();
    });
    super.initState();
  }

  Future<void> initMedia() async {
    await media.getData();
    if (mounted) {
      setState(() {});
    }
  }

  bool anyProcess = false;
  @override
  Widget build(BuildContext context) {
    if (media != widget.media) {
      media = widget.media;
      if (media.data == null) {
        initMedia();
      }
    }
    return media.data == null
        ? Container(
            width: widget.width,
            height: widget.height,
          )
        : Image.memory(
            media.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
  }
}
