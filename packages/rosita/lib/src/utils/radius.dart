// ignore: unnecessary_import
import 'dart:typed_data';

// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

class RositaRadiusUtils {
  static bool _isAllEquals(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topRight.x &&
        borderRadius.topRight.x == borderRadius.bottomRight.x &&
        borderRadius.bottomRight.x == borderRadius.bottomLeft.x;
  }

  static void applyBorderRadius(html.CssStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      final radius = borderRadius.resolve(null);

      if (_isAllEquals(radius)) {
        style.borderRadius = radius.topLeft.x == 0 ? '' : '${radius.topLeft.x}px';
        return;
      }

      style.borderRadius =
          '${radius.topLeft.x}px ${radius.topRight.x}px ${radius.bottomRight.x}px ${radius.bottomLeft.x}px';
    }
  }

  static void applyClipBorderRadius(html.CssStyleDeclaration style, BorderRadiusGeometry? borderRadius) {
    if (borderRadius != null) {
      applyBorderRadius(style, borderRadius);

      style.overflow = 'hidden';
    }
  }

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
      final path = clipper.getClip(size);

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
                previousPoint = Offset(points[pIndex], points[pIndex + 1]);
                oddList.add('Z ');
              }
            case RositaSPath.kLineVerb:
              if (isEven) {
                sb.write('L ${points[pIndex + 2]} ${points[pIndex + 3]} ');
              } else {
                oddList.add('L ${previousPoint.dx} ${previousPoint.dy} ');
                previousPoint = Offset(points[pIndex + 2], points[pIndex + 3]);
              }
            case RositaSPath.kQuadVerb:
              if (isEven) {
                sb.write('Q ${points[pIndex + 2]} ${points[pIndex + 3]},'
                    ' ${points[pIndex + 4]} ${points[pIndex + 5]}');
              } else {
                oddList.add('Q ${points[pIndex + 2]} ${points[pIndex + 3]}, ${previousPoint.dx} ${previousPoint.dy} ');
                previousPoint = Offset(points[pIndex + 4], points[pIndex + 5]);
              }
            case RositaSPath.kConicVerb:
              // sb.write('Conic(${points[pIndex + 2]}, ${points[pIndex + 3]},'
              //     ' ${points[pIndex + 3]}, ${points[pIndex + 4]}, w = ${iter.conicWeight})');
              if (isEven) {
                sb.write('Q ${points[pIndex + 2]} ${points[pIndex + 3]},'
                    ' ${points[pIndex + 4]} ${points[pIndex + 5]}'); // [ROSITA] This is not Conic
              } else {
                oddList.add('Q ${points[pIndex + 2]} ${points[pIndex + 3]}, ${previousPoint.dx} ${previousPoint.dy} ');
                previousPoint = Offset(points[pIndex + 4], points[pIndex + 5]);
              }
            case RositaSPath.kCubicVerb:
              if (isEven) {
                sb.write('C ${points[pIndex + 2]} ${points[pIndex + 3]},'
                    ' ${points[pIndex + 4]} ${points[pIndex + 5]}, '
                    ' ${points[pIndex + 6]} ${points[pIndex + 7]}');
              } else {
                oddList.add('C ${points[pIndex + 4]} ${points[pIndex + 5]},'
                    ' ${points[pIndex + 2]} ${points[pIndex + 3]}, '
                    ' ${previousPoint.dx} ${previousPoint.dy} ');

                previousPoint = Offset(points[pIndex + 6], points[pIndex + 7]);
              }
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

        final result = sb.toString();

        style.setProperty('clip-path', 'path("$result")');
      }

      return;
    }
  }
}
