// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

part 'mixins/canvas.dart';

part 'mixins/paragraph.dart';

class RositaCanvas with _CanvasMixin, _ParagraphMixin implements Canvas {
  RositaCanvas(this.canvas);

  @override
  final html.CanvasElement canvas;

  @override
  html.CanvasRenderingContext2D get context => canvas.context2D;

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {}

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {}

  @override
  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {}

  @override
  void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint) {
    _setDirty();
    context.beginPath();
    context.arc(rect.center.dx, rect.center.dy, rect.width / 2, startAngle, startAngle + sweepAngle);
    _fillPain(paint);
  }

  @override
  void drawAtlas(Image atlas, List<RSTransform> transforms, List<Rect> rects, List<Color>? colors, BlendMode? blendMode,
      Rect? cullRect, Paint paint) {}

  @override
  void drawCircle(Offset center, double radius, Paint paint) {
    drawArc(Rect.fromCircle(center: center, radius: radius), 0, math.pi * 2, false, paint);
  }

  @override
  void drawColor(Color color, BlendMode blendMode) {}

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) {}

  @override
  void drawImage(Image image, Offset offset, Paint paint) {}

  @override
  void drawImageNine(Image image, Rect center, Rect dst, Paint paint) {}

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {}

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {}

  @override
  void drawOval(Rect rect, Paint paint) {}

  @override
  void drawPaint(Paint paint) {}

  @override
  void drawParagraph(Paragraph paragraph, Offset offset) {}

  @override
  void drawPath(Path path, Paint paint) {}

  @override
  void drawPicture(Picture picture) {}

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {}

  @override
  void drawRRect(RRect rrect, Paint paint) {
    final sRect = rrect.scaleRadii();

    if (sRect.isEllipse) {
      drawArc(sRect.outerRect, 0, math.pi * 2, false, paint);
    } else {
      _setDirty();
      context.beginPath();
      _roundRect(sRect);
      _fillPain(paint);
    }
  }

  void _fillPain(Paint paint) {
    switch (paint.style) {
      case PaintingStyle.fill:
        context.fillStyle = paint.color.toHexString();
        context.fill();
      case PaintingStyle.stroke:
        context.strokeStyle = paint.color.toHexString();
        context.lineWidth = paint.strokeWidth;
        context.stroke();
    }
  }

  void _roundRect(RRect rrect) {
    // ------------------------
    // | x0 y0 | .... | x1 y0 |
    // | ..... | .... | ..... |
    // | x0 y1 | .... | x1 y1 |
    // ------------------------

    final coords = (
      x0: rrect.left,
      y0: rrect.top,
      x1: rrect.left + rrect.width,
      y1: rrect.top + rrect.height,
    );

    final radius = (
      tlX: rrect.tlRadiusX,
      tlY: rrect.tlRadiusY,
      trX: rrect.trRadiusX,
      trY: rrect.trRadiusY,
      brX: rrect.brRadiusX,
      brY: rrect.brRadiusY,
      blX: rrect.blRadiusX,
      blY: rrect.blRadiusY,
    );

    final points = (
      tl: (x0: coords.x0, y0: coords.y0 + radius.tlY, x1: coords.x0 + radius.tlX, y1: coords.y0),
      tr: (x0: coords.x1 - radius.trX, y0: coords.y0, x1: coords.x1, y1: coords.y0 + radius.trY),
      br: (x0: coords.x1, y0: coords.y1 - radius.brY, x1: coords.x1 - radius.brX, y1: coords.y1),
      bl: (x0: coords.x0 + radius.blX, y0: coords.y1, x1: coords.x0, y1: coords.y1 - radius.blY),
    );

    context.beginPath();

    context.moveTo(points.tl.x1, points.tl.y1);

    // TR
    context.lineTo(points.tr.x0, points.tr.y0);
    context.quadraticCurveTo(coords.x1, coords.y0, points.tr.x1, points.tr.y1);

    // BR
    context.lineTo(points.br.x0, points.br.y0);
    context.quadraticCurveTo(coords.x1, coords.y1, points.br.x1, points.br.y1);

    // BL
    context.lineTo(points.bl.x0, points.bl.y0);
    context.quadraticCurveTo(coords.x0, coords.y1, points.bl.x1, points.bl.y1);

    // TL
    context.lineTo(points.tl.x0, points.tl.y0);
    context.quadraticCurveTo(coords.x0, coords.y0, points.tl.x1, points.tl.y1);

    context.closePath();
  }

  @override
  void drawRawAtlas(Image atlas, Float32List rstTransforms, Float32List rects, Int32List? colors, BlendMode? blendMode,
      Rect? cullRect, Paint paint) {}

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) {}

  @override
  void drawRect(Rect rect, Paint paint) {
    _setDirty();
    context.beginPath();
    context.rect(rect.left, rect.top, rect.width, rect.height);
    _fillPain(paint);
  }

  @override
  void drawShadow(Path path, Color color, double elevation, bool transparentOccluder) {}

  @override
  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {}

  @override
  Rect getDestinationClipBounds() {
    throw UnimplementedError();
  }

  @override
  Rect getLocalClipBounds() {
    throw UnimplementedError();
  }

  @override
  int getSaveCount() => throw UnimplementedError();

  @override
  Float64List getTransform() => throw UnimplementedError();

  @override
  void restore() {}

  @override
  void restoreToCount(int count) {}

  @override
  void rotate(double radians) {}

  @override
  void save() {}

  @override
  void saveLayer(Rect? bounds, Paint paint) {}

  @override
  void scale(double sx, [double? sy]) {}

  @override
  void skew(double sx, double sy) {}

  @override
  void transform(Float64List matrix4) {}

  @override
  void translate(double dx, double dy) {}
}
