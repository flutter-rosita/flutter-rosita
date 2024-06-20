import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';

class RenderRositaAnimatedOpacity extends AnimatedRenderProxyBoxWithHitTestBehavior {
  RenderRositaAnimatedOpacity({
    required super.curve,
    required super.duration,
    required double opacity,
    super.onEnd,
  })  : _beginOpacity = opacity,
        _endOpacity = opacity,
        _alpha = ui.Color.getAlphaFromOpacity(opacity);

  double _beginOpacity;
  double _endOpacity;
  int _alpha;

  set opacity(double value) {
    if (_endOpacity == value) return;

    setupTicker();

    _endOpacity = value;

    markNeedsPaint();
  }

  double _lerpOpacity(double t) {
    if (t == 0.0) {
      return _beginOpacity;
    }
    if (t == 1.0) {
      return _endOpacity;
    }

    return _beginOpacity + (_endOpacity - _beginOpacity) * t;
  }

  @override
  void lerpAnimation(double t) {
    _alpha = ui.Color.getAlphaFromOpacity(_lerpOpacity(t));
  }

  @override
  bool paintsChild(RenderObject child) {
    return _alpha > 0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;

    if (child == null || _alpha == 0) return;

    layer = context.pushOpacity(
      offset,
      _alpha,
      super.paint,
      oldLayer: layer is OpacityLayer ? layer as OpacityLayer? : null,
    );
  }
}
