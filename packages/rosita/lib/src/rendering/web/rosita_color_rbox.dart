part of '../web_rendering.dart';

class RenderRositaColorRBox extends RositaRenderProxyBoxWithHitTestBehavior {
  RenderRositaColorRBox({
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
