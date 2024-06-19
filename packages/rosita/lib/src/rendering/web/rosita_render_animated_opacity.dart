import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/animation.dart';
import 'package:rosita/rosita_web.dart';
import 'package:web/web.dart' as web;

class RenderRositaAnimatedOpacity extends RositaRenderProxyBoxWithHitTestBehavior {
  RenderRositaAnimatedOpacity({
    required this.curve,
    required this.duration,
    required double opacity,
    this.onEnd,
  }) : _opacity = opacity;

  @override
  web.HTMLElement? createRositaElement() {
    final htmlElement = web.HTMLDivElement();
    final curve = this.curve;
    final onEnd = this.onEnd;

    RositaAnimationTransitionUtils.applyTransition(
      htmlElement.style,
      animations: 'opacity',
      curve: curve,
      duration: duration,
    );

    if (onEnd != null) {
      _onEndStreamSubscription = htmlElement.onTransitionEnd.listen((event) {
        onEnd.call();
      });
    }

    return htmlElement;
  }

  @override
  void rositaDetach() {
    htmlElement.ontransitionend = null;
    _onEndStreamSubscription?.cancel();
    _onEndStreamSubscription = null;
  }

  final Curve curve;

  final Duration duration;

  final VoidCallback? onEnd;

  double _opacity;

  StreamSubscription? _onEndStreamSubscription;

  set opacity(double value) {
    if (_opacity == value) return;

    _opacity = value;

    markNeedsPaint();
  }

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    (style as JSObject).setProperty('opacity' as JSAny, _opacity as JSAny);
  }
}
