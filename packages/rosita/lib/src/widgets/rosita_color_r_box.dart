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
    return _RenderRositaColorRBox(
      color: color,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderRositaColorRBox)
      ..color = color
      ..borderRadius = borderRadius;
  }
}

class _RenderRositaColorRBox extends RositaRenderProxyBoxWithHitTestBehavior {
  _RenderRositaColorRBox({
    required Color color,
    BorderRadius? borderRadius,
  })  : _color = color,
        _borderRadius = borderRadius;

  Color get color => _color;

  Color _color;

  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  BorderRadius? get borderRadius => _borderRadius;

  BorderRadius? _borderRadius;

  set borderRadius(BorderRadius? value) {
    if (value == _borderRadius) {
      return;
    }
    _borderRadius = value;
    markNeedsPaint();
  }

  @override
  void rositaPaint() {
    final style = htmlElement.style;

    style.backgroundColor = color.toStyleString();

    RositaRadiusUtils.applyBorderRadius(style, borderRadius);
  }
}
