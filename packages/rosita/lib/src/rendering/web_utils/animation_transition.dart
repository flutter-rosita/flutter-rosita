part of '../web_rendering.dart';

class RositaAnimationTransitionUtils {
  static void applyTransition(
    web.CSSStyleDeclaration style, {
    required String animations,
    required Curve curve,
    required Duration duration,
  }) {
    final JSAny curveString = switch (curve) {
      Cubic() => ('cubic-bezier(' as JSAny)
          .add(curve.a as JSAny)
          .add(',' as JSAny)
          .add(curve.b as JSAny)
          .add(',' as JSAny)
          .add(curve.c as JSAny)
          .add(',' as JSAny)
          .add(curve.d as JSAny)
          .add(')' as JSAny),
      _ => 'linear' as JSAny,
    };

    (style as JSObject).setProperty('transition' as JSAny,
        (animations as JSAny).add(' ' as JSAny).add(duration.inMilliseconds as JSAny).add('ms ' as JSAny).add(curveString));
  }
}
