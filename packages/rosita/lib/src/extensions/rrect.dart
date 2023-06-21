// ignore_for_file: public_member_api_docs

import 'dart:ui';

extension RositaRRectxtension on RRect {
  /// Optimize [RRect.isEllipse] for JS
  bool get rositaIsEllipse {
    return tlRadiusX == trRadiusX &&
        tlRadiusY == trRadiusY &&
        trRadiusX == brRadiusX &&
        trRadiusY == brRadiusY &&
        brRadiusX == blRadiusX &&
        brRadiusY == blRadiusY &&
        width <= 2.0 * tlRadiusX &&
        height <= 2.0 * tlRadiusY;
  }
}
