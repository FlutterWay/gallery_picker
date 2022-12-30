import 'package:flutter/material.dart';
import '/gallery_picker.dart';

class ReloadGallery extends StatelessWidget {
  final Config config;
  final Function() onpressed;
  ReloadGallery(Config? config, {super.key, required this.onpressed})
      : config = config ?? Config();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: Center(
          child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: const Center(
              child: Text(
                "Reload Gallery",
                style: TextStyle(color: Colors.white),
              ),
            )),
        onPressed: () {
          onpressed();
        },
      )),
    );
  }
}
