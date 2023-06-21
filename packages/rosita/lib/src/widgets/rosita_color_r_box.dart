import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

class RositaColorRBox extends SingleChildRenderObjectWidget {
  final Color color;
  final BorderRadius? borderRadius;

  const RositaColorRBox({
    super.key,
    super.child,
    required this.color,
    this.borderRadius,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRositaColorRBox(
      color: color,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderRositaColorRBox)
      ..color = color
      ..borderRadius = borderRadius;
  }
}
