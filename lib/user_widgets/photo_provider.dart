import 'package:flutter/material.dart';
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
  State<PhotoProvider> createState() => _PhotoProviderState();
}

class _PhotoProviderState extends State<PhotoProvider> {
  late MediaFile _media;
  @override
  void initState() {
    _media = widget.media;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initMedia();
    });
    super.initState();
  }

  Future<void> initMedia() async {
    await _media.getData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_media != widget.media) {
      _media = widget.media;
      if (_media.data == null) {
        initMedia();
      }
    }
    return _media.data == null
        ? SizedBox(
            width: widget.width,
            height: widget.height,
          )
        : Image.memory(
            _media.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
  }
}
