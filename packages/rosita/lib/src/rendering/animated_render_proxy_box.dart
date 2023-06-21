import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

abstract class AnimatedRenderProxyBoxWithHitTestBehavior extends RenderProxyBoxWithHitTestBehavior {
  AnimatedRenderProxyBoxWithHitTestBehavior({
    super.behavior,
    super.child,
    required this.curve,
    required Duration duration,
    VoidCallback? onEnd,
  })  : durationInMicroseconds = duration.inMicroseconds,
        _onEnd = onEnd;

  final Curve curve;
  final int durationInMicroseconds;
  VoidCallback? _onEnd;

  set onEnd(VoidCallback? value) => _onEnd = value;

  Ticker? _ticker;

  @override
  void dispose() {
    disposeTicker();
    super.dispose();
  }

  int _offsetDurationInMicroseconds = 0;

  int _lastDurationInMicroseconds = 0;

  void setupTicker() {
    _offsetDurationInMicroseconds = _lastDurationInMicroseconds;

    final ticker = _ticker ??= Ticker(_onTick);

    if (!ticker.isActive) {
      ticker.start();
    }
  }

  void disposeTicker() {
    _lastDurationInMicroseconds = 0;
    _ticker?.dispose();
    _ticker = null;
  }

  void _onTick(Duration elapsed) {
    _lastDurationInMicroseconds = elapsed.inMicroseconds;

    final t = curve.transform(
      ui.clampDouble((_lastDurationInMicroseconds - _offsetDurationInMicroseconds) / durationInMicroseconds, 0, 1),
    );

    lerpAnimation(t);

    if (t >= 1.0) {
      disposeTicker();

      try {
        _onEnd?.call();
      } catch (_) {}
    }

    markNeedsPaint();
  }

  void lerpAnimation(double t);
}
