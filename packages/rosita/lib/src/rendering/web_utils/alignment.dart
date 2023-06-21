part of '../web_rendering.dart';

class RositaAlignmentUtils {
  static String getAngleDeg(
    AlignmentGeometry begin,
    AlignmentGeometry end, {
    TextDirection? direction,
  }) {
    final angle = getAngle(begin.resolve(direction), end.resolve(direction));

    return '${angle}deg';
  }

  static String getAngleDegFromRectAndOffset(Rect rect, Offset from, Offset to) {
    final fromAlignment = _getAlignmentFromRectAndOffset(rect, from);
    final toAlignment = _getAlignmentFromRectAndOffset(rect, to);
    final angle = getAngle(fromAlignment, toAlignment);

    return '${angle}deg';
  }

  static double _getLength(Alignment vector) => sqrt(vector.x * vector.x + vector.y * vector.y);

  static (double x, double y) _getNormalized(Alignment vector) {
    final length = _getLength(vector);
    return (vector.x / length, vector.y / length);
  }

  static double _getCos(Alignment begin, Alignment end) {
    double x1, x2, y1, y2;
    (x1, y1) = _getNormalized(begin);
    (x2, y2) = _getNormalized(end);
    final length = _getLength(Alignment(x1 - x2, y1 - y2));
    return (y1 - y2) / length;
  }

  static double getAngle(Alignment begin, Alignment end) {
    final cos = _getCos(begin, end);
    double angle = acos(cos) * 180 / pi;
    if (end.x - begin.x < 0) {
      angle = 360 - angle;
    }
    return angle;
  }

  static Alignment _getAlignmentFromRectAndOffset(Rect rect, Offset offset) {
    final double halfWidth = rect.width / 2.0;
    final double halfHeight = rect.height / 2.0;

    final x = (offset.dx - halfWidth - rect.left) / halfWidth;
    final y = (offset.dy - halfHeight - rect.top) / halfHeight;

    return Alignment(x, y);
  }
}
