import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_picker/gallery_picker.dart';

import '../main.dart';

class MultipleMediasView extends StatefulWidget {
  final List<MediaFile> medias;
  const MultipleMediasView(this.medias, {super.key});

  @override
  State<MultipleMediasView> createState() => _MultipleMediasViewState();
}

class _MultipleMediasViewState extends State<MultipleMediasView> {
  int pageIndex = 0;
  var controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Destination Page"),
      ),
      body: Column(children: [
        const Spacer(),
        Text("These are your selected medias"),
        Divider(),
        Expanded(
          flex: 5,
          child: Stack(children: [
            PageView(
              controller: controller,
              children: [
                for (var media in widget.medias)
                  Center(
                    child: MediaProvider(
                      media: media,
                    ),
                  )
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    print(pageIndex);
                    if (pageIndex < widget.medias.length - 1) {
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
        const Divider(),
        SizedBox(
          height: 50,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < widget.medias.length; i++)
              TextButton(
                  onPressed: () {
                    pageIndex=i;
                    controller.animateToPage(i,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: i == pageIndex ? Colors.red : Colors.grey),
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ))
          ]),
        ),
        const Spacer(),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          GalleryPicker.dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "Selected Medias",
                      medias: widget.medias,
                    )),
          );
        },
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}
