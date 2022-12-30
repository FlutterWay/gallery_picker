import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:gallery_picker/gallery_picker.dart';

class GalleryPickerExample extends StatefulWidget {
  const GalleryPickerExample({super.key});

  @override
  State<GalleryPickerExample> createState() => _GalleryPickerExampleState();
}

class _GalleryPickerExampleState extends State<GalleryPickerExample> {
  List<MediaFile> selectedMedias = [];
  int pageIndex = 0;
  var controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick medias"),
      ),
      body: Center(
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
              flex: 2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickMedias,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> pickMedias() async {
    List<MediaFile>? medias = await GalleryPicker.pickMedias(
      context: context,
      config: Config(mode: Mode.dark),
    );
    if (medias != null) {
      setState(() {
        selectedMedias += medias;
      });
    }
  }
}
