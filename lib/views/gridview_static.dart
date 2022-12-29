import 'package:flutter/cupertino.dart';

class GridViewStatic extends StatelessWidget {
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final List<Widget> children;
  final double size;
  const GridViewStatic({
    super.key,
    required this.size,
    required this.children,
    required this.crossAxisCount,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return verticalView();
  }
  Widget horizontalView() {
    return SizedBox(
      height: size,
      child: Column(
        children: [
          for (int i = 0; i < crossAxisCount; i+=crossAxisCount)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i != children.length - 1 ? mainAxisSpacing : 0),
              child: SizedBox(
                height: size / crossAxisCount,
                child: Row(
                  children: [
                    for (int j = i; j < i + (children.length~/crossAxisCount)+1; j++)
                      j < children.length
                          ? Expanded(
                              child: Padding(
                              padding: EdgeInsets.only(
                                  right: j != i + crossAxisCount
                                      ? crossAxisSpacing
                                      : 0),
                              child: children[j],
                            ))
                          : Spacer()
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget verticalView() {
    return SizedBox(
      width: size,
      child: Column(
        children: [
          for (int i = 0; i < children.length; i+=crossAxisCount)
            SizedBox(
              width: size,
              height: (size / crossAxisCount) * childAspectRatio,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: i != children.length - 1 ? mainAxisSpacing : 0),
                child: Row(
                  children: [
                    for (int j = i; j < i + crossAxisCount; j++)
                      j < children.length
                          ? Expanded(
                              child: Padding(
                              padding: EdgeInsets.only(
                                  right: j != i + crossAxisCount
                                      ? crossAxisSpacing
                                      : 0),
                              child: children[j],
                            ))
                          : Spacer()
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
