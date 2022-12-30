import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/media_file.dart';

class VideoProvider extends StatefulWidget {
  final MediaFile media;
  final double? width, height;

  const VideoProvider({
    super.key,
    required this.media,
    this.width,
    this.height,
  });
  @override
  State<VideoProvider> createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  VideoPlayerController? _controller;
  File? _file;
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
    try {
      if (media.file == null) {
        _file = await media.getFile();
      } else {
        _file = media.file;
      }
      _controller = VideoPlayerController.file(_file!);
      _controller?.initialize().then((_) {
        setState(() {});
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed : $e");
      }
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  void disposeController() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  bool anyProcess = false;
  @override
  Widget build(BuildContext context) {
    if (media != widget.media) {
      media = widget.media;
      disposeController();
      initMedia();
    }
    return _controller == null || !_controller!.value.isInitialized
        ? SizedBox(
            width: widget.width,
            height: widget.height,
          )
        : SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: Stack(children: [
                    VideoPlayer(_controller!),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          anyProcess = true;
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                        child: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
  }
}
