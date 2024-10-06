import 'package:flutter/widgets.dart';

class EdgeInsetsX extends EdgeInsets {
  const EdgeInsetsX({
    double? all,
    double? vertical,
    double? horizontal,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) : super.only(
          left: left ?? horizontal ?? all ?? 0,
          top: top ?? vertical ?? all ?? 0,
          right: right ?? horizontal ?? all ?? 0,
          bottom: bottom ?? vertical ?? all ?? 0,
        );
}
