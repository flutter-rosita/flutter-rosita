part of '../web_rendering.dart';

class RenderRositaSvgPicture extends RositaRenderBox {
  RenderRositaSvgPicture({
    String? src,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Color? color,
  })  : _src = src,
        _width = width,
        _height = height,
        _fit = fit,
        _alignment = alignment,
        _color = color;

  web.HTMLImageElement get imageElement => htmlElement as web.HTMLImageElement;

  @override
  web.HTMLElement? createRositaElement() => web.HTMLImageElement()
    ..loading = 'lazy'
    ..decoding = 'async';

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
    markNeedsPaint();
  }

  double? get width => _width;
  double? _width;

  set width(double? value) {
    if (value == _width) {
      return;
    }
    _width = value;
    markNeedsPaint();
  }

  double? get height => _height;
  double? _height;

  set height(double? value) {
    if (value == _height) {
      return;
    }
    _height = value;
    markNeedsPaint();
  }

  BoxFit? get fit => _fit;
  BoxFit? _fit;

  set fit(BoxFit? value) {
    if (value == _fit) {
      return;
    }
    _fit = value;
    markNeedsPaint();
  }

  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;

  set alignment(AlignmentGeometry? value) {
    if (value == _alignment) {
      return;
    }
    _alignment = value;
    markNeedsPaint();
  }

  Color? get color => _color;
  Color? _color;

  set color(Color? value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = Size(
      clampDouble(width ?? double.infinity, constraints.minWidth, constraints.maxWidth),
      clampDouble(height ?? double.infinity, constraints.minHeight, constraints.maxHeight),
    );
  }

  @override
  void rositaPaint() {
    final src = _src;
    final color = _color;
    final style = imageElement.style;

    RositaBoxFitUtils.applyBoxFitToObjectFit(style, fit);
    RositaBoxFitUtils.applyAlignmentToObjectPosition(style, alignment);

    final width = this.width;
    final height = this.height;

    if (width != null) {
      imageElement.width = width.toInt();
    }

    if (height != null) {
      imageElement.height = height.toInt();
    }

    if (src != null && color != null) {
      imageElement.src =
          'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'; // TRANSPARENT 1x1 GIF

      (style as JSObject).setProperty('backgroundColor' as JSAny, color.toStyleJSAny());
      style.maskImage = 'url($src)';
      style.maskRepeat = 'no-repeat';
      style.maskPosition = style.objectPosition;
      style.maskSize = switch (fit) {
        null => '',
        BoxFit.fill => '100%',
        BoxFit.contain => 'contain',
        BoxFit.cover => 'cover',
        BoxFit.fitWidth => '100% auto',
        BoxFit.fitHeight => 'auto 100%',
        BoxFit.none => 'auto',
        BoxFit.scaleDown => 'auto',
      };
    } else {
      style.backgroundColor = '';
      style.maskImage = '';
      imageElement.src = src ?? '';
    }
  }
}
