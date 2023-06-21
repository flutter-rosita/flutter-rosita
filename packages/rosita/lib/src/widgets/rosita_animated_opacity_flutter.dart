import 'package:flutter/widgets.dart';
import 'package:rosita/src/rendering/io/rosita_render_animated_opacity.dart';

class RositaAnimatedOpacityFlutter extends SingleChildRenderObjectWidget {
  const RositaAnimatedOpacityFlutter({
    super.key,
    super.child,
    required this.opacity,
    this.curve = Curves.linear,
    required this.duration,
    this.onEnd,
  }) : assert(opacity >= 0.0 && opacity <= 1.0);

  final double opacity;

  final Curve curve;

  final Duration duration;

  final VoidCallback? onEnd;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRositaAnimatedOpacity(
      opacity: opacity,
      curve: curve,
      duration: duration,
      onEnd: onEnd,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaAnimatedOpacity renderObject) {
    renderObject
      ..opacity = opacity
      ..onEnd = onEnd;
  }
}
