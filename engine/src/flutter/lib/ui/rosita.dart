part of dart.ui;

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
