import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:gallery_picker/gallery_picker.dart';

import 'examples/multiple_medias.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(
        title: "Gallery Picker",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<MediaFile>? medias;
  const MyHomePage({super.key, required this.title, this.medias});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MediaFile> selectedMedias = [];

  @override
  void initState() {
    if (widget.medias != null) {
      selectedMedias = widget.medias!;
    }
    super.initState();
  }

  int pageIndex = 0;
  var controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
        onPressed: pickMedia,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> pickMedia() async {
    List<MediaFile>? media = await GalleryPicker.pickMedia(
        context: context,
        initSelectedMedia: selectedMedias,
        extraRecentMedia: selectedMedias,
        startWithRecent: true);
    if (media != null) {
      setState(() {
        selectedMedias += media;
      });
    }
  }

  pickMediaWithBuilder() {
    GalleryPicker.pickMediaWithBuilder(
        multipleMediaBuilder: ((medias, context) {
          return MultipleMediasView(medias);
        }),
        heroBuilder: (tag, media, context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hero Page'),
            ),
            body: Center(
                child: Hero(
              tag: tag,
              child: MediaProvider(
                media: media,
                width: MediaQuery.of(context).size.width - 50,
                height: 300,
              ),
            )),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                GalleryPicker.dispose();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: "Selected Medias",
                            medias: [media],
                          )),
                );
              },
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          );
        },
        context: context);
  }

  Future<void> getGalleryMedia() async {
    // ignore: unused_local_variable
    GalleryMedia? allmedia =
        await GalleryPicker.collectGallery(locale: const Locale("tr"));
  }
}
