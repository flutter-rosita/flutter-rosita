import 'dart:math' as math;

// ignore: unnecessary_import
import 'dart:typed_data';

// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

class RositaPathUtils {
  static void applyCustomClipper(html.CssStyleDeclaration style, CustomClipper? clipper, Size size) {
    if (clipper is ShapeBorderClipper) {
      final shape = clipper.shape;

      switch (shape) {
        case RoundedRectangleBorder():
          RositaRadiusUtils.applyClipBorderRadius(style, shape.borderRadius);

          return;
        case StadiumBorder() || CircleBorder():
          RositaRadiusUtils.applyClipBorderRadius(
            style,
            BorderRadius.all(
              Radius.circular(size.shortestSide / 2),
            ),
          );
          return;
      }
    }

    if (clipper is CustomClipper<Path>) {
      final Path path = clipper.getClip(size);

      applyCustomClipperPath(style, path);
    }
  }

  static void applyCustomClipperPath(html.CssStyleDeclaration style, Path path) {
    if (path is RositaSurfacePath) {
      final pathRef = path.pathRef;
      final StringBuffer sb = StringBuffer();
      final RositaPathRefIterator iter = RositaPathRefIterator(pathRef);
      final Float32List points = pathRef.points;
      int verb;

      bool isEven = false;

      final oddList = <String>[];

      Offset previousPoint = Offset.zero;

      while ((verb = iter.nextIndex()) != RositaSPath.kDoneVerb) {
        final int pIndex = iter.iterIndex;

        switch (verb) {
          case RositaSPath.kMoveVerb:
            isEven = !isEven && path.fillType == PathFillType.evenOdd;

            oddList.clear();

            if (isEven) {
              sb.write('M ${points[pIndex]} ${points[pIndex + 1]} ');
            } else {
              oddList.add('Z ');
            }

            previousPoint = Offset(points[pIndex], points[pIndex + 1]);
          case RositaSPath.kLineVerb:
            if (isEven) {
              sb.write('L ${points[pIndex + 2]} ${points[pIndex + 3]} ');
            } else {
              oddList.add('L ${previousPoint.dx} ${previousPoint.dy} ');
            }

            previousPoint = Offset(points[pIndex + 2], points[pIndex + 3]);
          case RositaSPath.kQuadVerb:
            if (isEven) {
              sb.write('Q ${points[pIndex + 2]} ${points[pIndex + 3]},'
                  ' ${points[pIndex + 4]} ${points[pIndex + 5]}');
            } else {
              oddList.add('Q ${points[pIndex + 2]} ${points[pIndex + 3]}, ${previousPoint.dx} ${previousPoint.dy} ');
            }

            previousPoint = Offset(points[pIndex + 4], points[pIndex + 5]);
          case RositaSPath.kConicVerb:
            final bool skip = points[pIndex + 2] == points[pIndex + 4] &&
                points[pIndex + 4] == previousPoint.dx &&
                points[pIndex + 3] == points[pIndex + 5] &&
                points[pIndex + 5] == previousPoint.dy;

            if (!skip) {
              if (isEven) {
                final convertPoints = _convertConicToCubic(
                  previousPoint,
                  Offset(points[pIndex + 2], points[pIndex + 3]),
                  Offset(points[pIndex + 4], points[pIndex + 5]),
                  iter.conicWeight,
                );

                sb.write(
                    'C ${convertPoints.$1.dx} ${convertPoints.$1.dy}, ${convertPoints.$2.dx} ${convertPoints.$2.dy}, ${points[pIndex + 4]} ${points[pIndex + 5]}'); // [ROSITA] This is not true Conic
              } else {
                final convertPoints = _convertConicToCubic(
                  Offset(points[pIndex + 4], points[pIndex + 5]),
                  Offset(points[pIndex + 2], points[pIndex + 3]),
                  previousPoint,
                  iter.conicWeight,
                );

                oddList.add(
                    'C ${convertPoints.$1.dx} ${convertPoints.$1.dy}, ${convertPoints.$2.dx} ${convertPoints.$2.dy}, ${previousPoint.dx} ${previousPoint.dy} '); // [ROSITA] This is not true Conic
              }
            }

            previousPoint = Offset(points[pIndex + 4], points[pIndex + 5]);
          case RositaSPath.kCubicVerb:
            if (isEven) {
              sb.write('C ${points[pIndex + 2]} ${points[pIndex + 3]},'
                  ' ${points[pIndex + 4]} ${points[pIndex + 5]}, '
                  ' ${points[pIndex + 6]} ${points[pIndex + 7]}');
            } else {
              oddList.add('C ${points[pIndex + 4]} ${points[pIndex + 5]},'
                  ' ${points[pIndex + 2]} ${points[pIndex + 3]}, '
                  ' ${previousPoint.dx} ${previousPoint.dy} ');
            }

            previousPoint = Offset(points[pIndex + 6], points[pIndex + 7]);
          case RositaSPath.kCloseVerb:
            if (isEven) {
              sb.write('Z ');
            } else {
              oddList.add('M ${previousPoint.dx} ${previousPoint.dy} ');

              sb.writeAll(oddList.reversed);

              oddList.clear();
            }
        }
        if (iter.peek() != RositaSPath.kDoneVerb) {
          sb.write(' ');
        }
      }

      if (oddList.isNotEmpty) {
        sb.writeAll(oddList.reversed);
      }

      final String result = sb.toString();

      style.setProperty('clip-path', 'path("$result")');
    }
  }

  static (Offset, Offset) _convertConicToCubic(Offset from, Offset a, Offset to, double w) {
    Offset scaleVertex(Offset a, Offset b, double s) {
      final double size = math.sqrt(math.pow(b.dx - a.dx, 2) + math.pow(b.dy - a.dy, 2)) * s;

      final Offset v = Offset(b.dx - a.dx, b.dy - a.dy);

      final double sqrt = math.sqrt(math.pow(v.dx, 2) + math.pow(v.dy, 2));

      final Offset scaled = Offset(v.dx * size / sqrt, v.dy * size / sqrt);

      return Offset(scaled.dx + a.dx, scaled.dy + a.dy);
    }

    final double w2 = (w - 0.125 - 0.375) / 0.375;

    if (w2 > 0) {
      return (scaleVertex(from, a, w2), scaleVertex(to, a, w2));
    }

    return (scaleVertex(from, a, w), scaleVertex(to, a, w));
  }
}
