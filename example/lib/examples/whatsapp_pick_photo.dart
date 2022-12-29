import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:camera/camera.dart';
import 'package:gallery_picker_example/examples/multiple_medias.dart';

class WhatsappPickPhoto extends StatefulWidget {
  const WhatsappPickPhoto({super.key});

  @override
  State<WhatsappPickPhoto> createState() => _WhatsappPickPhotoState();
}

class _WhatsappPickPhotoState extends State<WhatsappPickPhoto> {
  CameraController? cameraController;
  GalleryMedia? gallery;
  List<MediaFile> selectedMedias = [];
  List<CameraDescription>? cameras;
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  @override
  void initState() {
    initCamera();
    fetchMedias();
    GalleryPicker.listenSelectedFiles.listen((medias) {
      selectedMedias = medias;
      setState(() {});
    });
    super.initState();
  }

  Future<void> fetchMedias() async {
    gallery = await GalleryPicker.collectGallery;
    setState(() {});
  }

  Future<void> initCamera() async {
    cameraController = null;
    setState(() {});
    cameras ??= await availableCameras();
    cameraController = CameraController(
        cameras!.firstWhere(
            (camera) => camera.lensDirection == cameraLensDirection),
        ResolutionPreset.max);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  bool isRecording = false;
  bool anyProcess = false;
  @override
  void dispose() {
    cameraController!.dispose();
    GalleryPicker.disposeSelectedFilesListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BottomSheetLayout(
        onSelect: (List<MediaFile> selectedMedias) {
          this.selectedMedias = selectedMedias;
          setState(() {});
        },
        initSelectedMedias: selectedMedias,
        config: Config(mode: Mode.dark),
        child: Stack(
          children: [
            if (cameraController != null &&
                cameraController!.value.isInitialized)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(
                  cameraController!,
                ),
              ),
            if (gallery != null && gallery!.recent != null)
              Positioned(
                bottom: 100,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var media in gallery!.recent!.files)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedMedias.isEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MultipleMediasView([media])),
                                );
                              } else {
                                selectedMedias.any(
                                        (element) => element.id == media.id)
                                    ? selectedMedias.removeWhere(
                                        (element) => element.id == media.id)
                                    : selectedMedias.add(media);
                                setState(() {});
                              }
                            },
                            onLongPress: () {
                              if (selectedMedias
                                  .any((element) => element.id == media.id)) {
                                selectedMedias.removeWhere(
                                    (element) => element.id == media.id);
                              } else {
                                selectedMedias.add(media);
                              }
                              setState(() {});
                            },
                            child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: selectedMedias.any((element) =>
                                                element.id == media.id)
                                            ? Colors.red
                                            : Colors.black)),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 65,
                                      height: 65,
                                      child: ThumbnailMedia(
                                        media: media,
                                      ),
                                    ),
                                    if (selectedMedias.any(
                                        (element) => element.id == media.id))
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.check,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      )
                                  ],
                                )),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            if (selectedMedias.isNotEmpty)
              Positioned(
                  bottom: 150,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MultipleMediasView(selectedMedias)),
                      );
                    },
                    mini: true,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  )),
            Positioned(
                bottom: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          GalleryPicker.openSheet();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.image,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            anyProcess = true;
                          });
                          Future.delayed(Duration(milliseconds: 100))
                              .then((value) => setState(() {
                                    anyProcess = false;
                                  }));
                        },
                        onLongPressStart: (value) {
                          setState(() {
                            isRecording = true;
                            anyProcess = true;
                          });
                        },
                        onLongPressEnd: (value) async {
                          setState(() {
                            isRecording = false;
                            anyProcess = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          width: isRecording ? 80 : 65,
                          height: isRecording ? 80 : 65,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  anyProcess ? Colors.red : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (cameraLensDirection ==
                              CameraLensDirection.front) {
                            cameraLensDirection = CameraLensDirection.back;
                          } else {
                            cameraLensDirection = CameraLensDirection.front;
                          }
                          initCamera();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.cameraswitch,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
