import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:gallery_picker/gallery_picker.dart';

import '../main.dart';
import 'multiple_medias.dart';

class PickMediasWithBuilder extends StatefulWidget {
  const PickMediasWithBuilder({super.key});

  @override
  State<PickMediasWithBuilder> createState() => _PickMediasWithBuilderState();
}

class _PickMediasWithBuilderState extends State<PickMediasWithBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Medias With Builder"),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                TextButton(
                    onPressed: pickMediaWithBuilder,
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const Text(
                        'Pick Medias With Builder',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const Spacer()
              ],
            ),
          ),
        ],
      ),
    );
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
}
