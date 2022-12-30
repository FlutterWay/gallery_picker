import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:gallery_picker/gallery_picker.dart';

class BottomSheetExample extends StatefulWidget {
  const BottomSheetExample({super.key});

  @override
  State<BottomSheetExample> createState() => _BottomSheetExampleState();
}

class _BottomSheetExampleState extends State<BottomSheetExample> {
  List<MediaFile> selectedMedias = [];
  int pageIndex = 0;
  var controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BottomSheetLayout(
        onSelect: (List<MediaFile> selectedMedias) {
          this.selectedMedias = selectedMedias;
          pageIndex = 0;
          if (this.selectedMedias.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              controller.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            });
          }
          setState(() {});
        },
        config: Config(mode: Mode.dark),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Text(
                'These are your selected medias',
              ),
              const Divider(),
              Expanded(
                flex: 5,
                child: Stack(children: [
                  if (selectedMedias.isNotEmpty)
                    PageView(
                      controller: controller,
                      children: [
                        for (var media in selectedMedias)
                          Center(
                            child: MediaProvider(
                              media: media,
                            ),
                          )
                      ],
                    ),
                  if (selectedMedias.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            if (pageIndex < selectedMedias.length - 1) {
                              pageIndex++;
                              controller.animateToPage(pageIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              setState(() {});
                            }
                          },
                          child: const Icon(
                            Icons.chevron_right,
                            size: 100,
                            color: Colors.red,
                          )),
                    ),
                  if (selectedMedias.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            if (pageIndex > 0) {
                              pageIndex--;
                              controller.animateToPage(pageIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                              setState(() {});
                            }
                          },
                          child: const Icon(
                            Icons.chevron_left,
                            size: 100,
                            color: Colors.red,
                          )),
                    ),
                ]),
              ),
              SizedBox(
                height: 65,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < selectedMedias.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextButton(
                          onPressed: () {
                            pageIndex = i;
                            controller.animateToPage(pageIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            setState(() {});
                          },
                          child: Container(
                              width: 65,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: pageIndex == i
                                          ? Colors.red
                                          : Colors.black)),
                              child: ThumbnailMedia(
                                media: selectedMedias[i],
                              )),
                        ),
                      )
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              TextButton(
                onPressed: () {
                  GalleryPicker.openSheet();
                },
                child: const Icon(
                  Icons.open_in_new,
                  size: 40,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
