import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedView extends StatelessWidget {
  final Config config;
  const PermissionDeniedView({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: config.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "Please allow access to your photos",
            style: TextStyle(
                color: config.textStyle.color,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "This lets access your photos and videos from your library.",
            style: TextStyle(
              color: config.textStyle.color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text("Enable library access"),
          )
        ],
      ),
    );
  }
}
