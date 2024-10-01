import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

import 'rosita_animated_opacity_web.dart';

class RositaAnimatedOpacityState extends State<AnimatedOpacity>
    implements ImplicitlyAnimatedWidgetState<AnimatedOpacity> {
  @override
  Animation<double> get animation => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    if (!kIsRosita) throw UnimplementedError();

    return RositaAnimatedOpacityWeb(
      opacity: widget.opacity,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }

  @override
  AnimationController get controller => throw UnimplementedError();

  @override
  Ticker createTicker(TickerCallback onTick) {
    throw UnimplementedError();
  }

  @override
  void didUpdateTweens() {}

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {}
}
