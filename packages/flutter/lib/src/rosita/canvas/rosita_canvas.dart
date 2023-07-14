// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/rosita.dart';

part 'mixins/canvas.dart';

part 'mixins/paragraph.dart';

class RositaCanvas with _CanvasMixin, _ParagraphMixin implements Canvas {
  RositaCanvas(this.canvas);

  final html.CanvasElement canvas;

  @override
  html.CanvasRenderingContext2D get context => canvas.context2D;

  void clean(Size size) {
    canvas.width = size.width.toInt();
    canvas.height = size.height.toInt();
    context.clearRect(0, 0, canvas.width!, canvas.height!);
  }

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {}

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {}

  @override
  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {}

  @override
  void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint) {
    context.beginPath();
    context.arc(rect.center.dx, rect.center.dy, rect.width / 2, startAngle, startAngle + sweepAngle);
    _fillPain(paint);
  }

  @override
  void drawAtlas(Image atlas, List<RSTransform> transforms, List<Rect> rects, List<Color>? colors, BlendMode? blendMode,
      Rect? cullRect, Paint paint) {}

  @override
  void drawCircle(Offset c, double radius, Paint paint) {}

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
    context.beginPath();
    _roundRect(rrect);
    _fillPain(paint);
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
    final x = rrect.left;
    final y = rrect.top;
    final width = rrect.width;
    final height = rrect.height;

    context.beginPath();
    context.moveTo(x + rrect.tlRadiusX, y);
    context.lineTo(x + width - rrect.trRadiusX, y);
    context.quadraticCurveTo(x + width, y, x + width, y + rrect.trRadiusX);
    context.lineTo(x + width, y + height - rrect.brRadiusX);
    context.quadraticCurveTo(x + width, y + height, x + width - rrect.brRadiusX, y + height);
    context.lineTo(x + rrect.blRadiusX, y + height);
    context.quadraticCurveTo(x, y + height, x, y + height - rrect.blRadiusX);
    context.lineTo(x, y + rrect.tlRadiusX);
    context.quadraticCurveTo(x, y, x + rrect.tlRadiusX, y);
    context.closePath();
  }

  @override
  void drawRawAtlas(Image atlas, Float32List rstTransforms, Float32List rects, Int32List? colors, BlendMode? blendMode,
      Rect? cullRect, Paint paint) {}

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) {}

  @override
  void drawRect(Rect rect, Paint paint) {
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
