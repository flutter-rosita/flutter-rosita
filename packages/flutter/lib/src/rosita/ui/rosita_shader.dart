// ignore_for_file: public_member_api_docs

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

sealed class RositaShader implements ui.Shader {
  @override
  bool get debugDisposed => false;

  @override
  void dispose() {}
}

class RositaGradientLinearShader extends RositaShader {
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
  final Float64List? matrix4;
}

class RositaGradientRadialShader extends RositaShader {
  RositaGradientRadialShader(
    this.center,
    this.radius,
    this.colors, [
    this.colorStops,
    this.tileMode = TileMode.clamp,
    this.matrix4,
    this.focal,
    this.focalRadius = 0.0,
  ]);

  final Offset center;
  final double radius;
  final List<Color> colors;
  final List<double>? colorStops;
  final TileMode tileMode;
  final Float64List? matrix4;
  final Offset? focal;
  final double focalRadius;
}

class RositaGradientSweepShader extends RositaShader {
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
  final Float64List? matrix4;
}
