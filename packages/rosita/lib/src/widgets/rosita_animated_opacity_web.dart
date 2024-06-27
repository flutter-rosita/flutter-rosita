import 'package:flutter/widgets.dart';
import 'package:rosita/src/rendering/io/rosita_render_animated_opacity.dart'
    if (dart.library.js_interop) 'package:rosita/src/rendering/web/rosita_render_animated_opacity.dart';

class RositaAnimatedOpacityWeb extends SingleChildRenderObjectWidget {
  const RositaAnimatedOpacityWeb({
    super.key,
    super.child,
    required this.opacity,
    this.curve = Curves.linear,
    required this.duration,
    this.onEnd,
  });

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
