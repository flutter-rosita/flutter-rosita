part of ui;

class RositaBlurImageFilter implements ImageFilter {
  RositaBlurImageFilter({
    required this.sigmaX,
    required this.sigmaY,
    this.tileMode,
  });

  final double sigmaX;
  final double sigmaY;
  final TileMode? tileMode;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

sealed class RositaGradient implements Gradient {
  @override
  bool get debugDisposed => false;

  @override
  void dispose() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class RositaGradientLinearShader extends RositaGradient {
  RositaGradientLinearShader(
    this.from,
    this.to,
    this.colors, [
    this.colorStops,
    this.tileMode = TileMode.clamp,
    this.matrix4,
  ]);

  final Offset from;
  final Offset to;
  final List<Color> colors;
  final List<double>? colorStops;
  final TileMode tileMode;
  final Float32List? matrix4;
}

final class RositaGradientRadialShader extends RositaGradient {
  RositaGradientRadialShader(
    this.focal,
    this.focalRadius,
    this.center,
    this.radius,
    this.colors, [
    this.colorStops,
    this.tileMode = TileMode.clamp,
    this.matrix4,
  ]);

  final Offset center;
  final double radius;
  final List<Color> colors;
  final List<double>? colorStops;
  final TileMode tileMode;
  final Float32List? matrix4;
  final Offset? focal;
  final double focalRadius;
}

final class RositaGradientSweepShader extends RositaGradient {
  RositaGradientSweepShader(
    this.center,
    this.colors, [
    this.colorStops,
    this.tileMode = TileMode.clamp,
    this.startAngle = 0.0,
    this.endAngle = math.pi * 2,
    this.matrix4,
  ]);

  final Offset center;
  final List<Color> colors;
  final List<double>? colorStops;
  final TileMode tileMode;
  final double startAngle;
  final double endAngle;
  final Float32List? matrix4;
}

class RositaSurfacePath extends engine.SurfacePath {
  RositaSurfacePath();

  RositaSurfacePath.from(Path source) : super.from(source as engine.SurfacePath);

  @override
  RositaSurfacePath transform(Float64List matrix4) {
    final RositaSurfacePath newPath = RositaSurfacePath.from(this);
    newPath._transform(matrix4);
    return newPath;
  }

  void _transform(Float64List m) {
    pathRef.startEdit();
    final int pointCount = pathRef.countPoints();
    final Float32List points = pathRef.points;
    final int len = pointCount * 2;
    for (int i = 0; i < len; i += 2) {
      final double x = points[i];
      final double y = points[i + 1];
      final double w = 1.0 / ((m[3] * x) + (m[7] * y) + m[15]);
      final double transformedX = ((m[0] * x) + (m[4] * y) + m[12]) * w;
      final double transformedY = ((m[1] * x) + (m[5] * y) + m[13]) * w;
      points[i] = transformedX;
      points[i + 1] = transformedY;
    }
    setConvexityType(RositaSPathConvexityType.kUnknown);
  }
}

class RositaPathRefIterator extends engine.PathRefIterator {
  RositaPathRefIterator(super.pathRef);
}

abstract final class RositaSPath {
  static const int kMoveVerb = engine.SPathVerb.kMove;
  static const int kLineVerb = engine.SPathVerb.kLine;
  static const int kQuadVerb = engine.SPathVerb.kQuad;
  static const int kConicVerb = engine.SPathVerb.kConic;
  static const int kCubicVerb = engine.SPathVerb.kCubic;
  static const int kCloseVerb = engine.SPathVerb.kClose;
  static const int kDoneVerb = engine.SPathVerb.kClose + 1;
}

class RositaSPathConvexityType {
  static const int kUnknown = -1;
  static const int kConvex = 0;
  static const int kConcave = 1;
}
