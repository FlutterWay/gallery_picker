import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bottom_sheet_controller.dart';

class TappableAppbar extends StatelessWidget {
   BottomSheetController? controller;
   Widget child;
   TappableAppbar({super.key, required this.controller,required this.child});

  @override
  Widget build(BuildContext context) {
    return GetInstance().isRegistered<BottomSheetController>()
        ? GestureDetector(
            onLongPressEnd: (a) {
              if (GetInstance().isRegistered<BottomSheetController>()) {
                controller!.tapingStatus(false);
              }
            },
            onPanCancel: () {},
            onPanDown: (a) {
              if (GetInstance().isRegistered<BottomSheetController>()) {
                controller!.tapingStatus(true);
              }
            },
            child: child,
          )
        : child;
  }
}
