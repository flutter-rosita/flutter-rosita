import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

import 'rosita_animated_opacity_flutter.dart';
import 'rosita_animated_opacity_web.dart';

class RositaAnimatedOpacity extends StatelessWidget {
  const RositaAnimatedOpacity({
    super.key,
    required this.child,
    required this.opacity,
    this.curve = Curves.linear,
    required this.duration,
    this.onEnd,
  }) : assert(opacity >= 0.0 && opacity <= 1.0);

  final Widget child;

  /// The target opacity.
  ///
  /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
  /// (i.e., invisible).
  final double opacity;

  /// The curve to apply when animating the parameters of this container.
  final Curve curve;

  /// The duration over which to animate the parameters of this container.
  final Duration duration;

  /// Called every time an animation completes.
  ///
  /// This can be useful to trigger additional actions (e.g. another animation)
  /// at the end of the current animation.
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    if (kIsRosita) {
      return RositaAnimatedOpacityWeb(
        opacity: opacity,
        curve: curve,
        duration: duration,
        onEnd: onEnd,
        child: child,
      );
    }

    return RepaintBoundary(
      child: RositaAnimatedOpacityFlutter(
        opacity: opacity,
        curve: curve,
        duration: duration,
        onEnd: onEnd,
        child: child,
      ),
    );
  }
}
