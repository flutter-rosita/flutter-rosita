part of '../web_rendering.dart';

class RositaAnimationTransitionUtils {
  static void applyTransition(
    web.CSSStyleDeclaration style, {
    required String animations,
    required Curve curve,
    required Duration duration,
  }) {
    final JSAny curveString = switch (curve) {
      Cubic() => ('cubic-bezier('.toJS)
          .add(curve.a.toJS)
          .add(','.toJS)
          .add(curve.b.toJS)
          .add(','.toJS)
          .add(curve.c.toJS)
          .add(','.toJS)
          .add(curve.d.toJS)
          .add(')'.toJS),
      _ => 'linear'.toJS,
    };

    (style as JSObject).setProperty('transition'.toJS,
        (animations.toJS).add(' '.toJS).add(duration.inMilliseconds.toJS).add('ms '.toJS).add(curveString));
  }
}
