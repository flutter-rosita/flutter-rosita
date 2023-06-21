part of '../io_rendering.dart';

class RenderRositaColorRBox extends RositaRenderProxyBoxWithHitTestBehavior {
  RenderRositaColorRBox({
    required this.color,
    this.borderRadius,
  });

  Color color;

  BorderRadius? borderRadius;
}
