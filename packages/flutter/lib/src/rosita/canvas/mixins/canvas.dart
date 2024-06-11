part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  static const double _defaultOffset = 10.0;

  double get _devicePixelRatio => RendererBinding.instance.renderViews.first.flutterView.devicePixelRatio;

  Rect offsetRect = Rect.zero;

  Offset? _offset;

  Offset get offset => _offset!;

  web.HTMLCanvasElement get canvas;

  web.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  bool _isMarkNeedRepaint = false;

  bool get isMarkNeedRepaint => _isMarkNeedRepaint;

  double _translateX = 0;
  double _translateY = 0;

  void _setTranslate(double dx, double dy) {
    _translateX = dx;
    _translateY = dy;
  }

  void _setDirty(Rect rect, double weight) {
    _isDirty = true;

    if (_translateX == 0 && _translateY == 0) {
      _checkRectOverflow(rect, weight);
    } else {
      _checkRectOverflow(rect.translate(_translateX, _translateY), weight);
    }
  }

  Size? _size;

  BlendMode? _blendMode;

  bool get isModulate => _blendMode == BlendMode.modulate;

  void paintCallback(Size size, RositaPaintCallback callback) {
    final RositaPaintingContext context = RositaPaintingContext(this as RositaCanvas);

    do {
      clean(size);
      callback.call(context);
      checkDirty();
    } while (isMarkNeedRepaint);
  }

  void clean(Size size) {
    if (_size != size) {
      _size = size;

      if (offsetRect.size.width < size.width || offsetRect.size.height < size.height) {
        final Rect rectWithDefaultOffsets = const Offset(-_defaultOffset, -_defaultOffset) &
            Size(size.width + _defaultOffset * 2, size.height + _defaultOffset * 2);
        _setOffsetRect(rectWithDefaultOffsets);
      }
    }

    _updateCanvasSize();

    _isMarkNeedRepaint = false;

    if (_isDirty) {
      context.clearRect(0, 0, offsetRect.width, offsetRect.height);
      _isDirty = false;
    }

    resetMatrixTransform();
  }

  void checkDirty() {
    canvas.style.display = _isDirty ? 'block' : 'none';
  }

  void _setOffsetRect(Rect rect) {
    _offset = Offset(-rect.left, -rect.top);
    offsetRect = rect;

    final Rect(:left, :top) = rect;

    if (left != 0 || top != 0) {
      (canvas.style as JSObject).setProperty('transform' as JSAny,
          ('translate(' as JSAny).add(left as JSAny).add('px,' as JSAny).add(top as JSAny).add('px)' as JSAny));
    } else {
      canvas.style.transform = '';
    }
  }

  double? _previousPixelRatio;
  double? _previousWidth;
  double? _previousHeight;

  void _updateCanvasSize() {
    final double scale = _devicePixelRatio;
    final Rect(:double width, :double height) = offsetRect;

    if (_previousPixelRatio == scale && _previousWidth == width && _previousHeight == height) {
      return;
    }

    _transformScale = null;
    _previousPixelRatio = scale;
    _previousWidth = width;
    _previousHeight = height;

    (canvas.style as JSObject)
      ..setProperty('width' as JSAny, (width as JSAny).add('px' as JSAny))
      ..setProperty('height' as JSAny, (height as JSAny).add('px' as JSAny));

    canvas.width = (width * scale).toInt();
    canvas.height = (height * scale).toInt();
  }

  void _checkRectOverflow(Rect rect, double weight) {
    final bool isLeft = rect.left - weight < offsetRect.left;
    final bool isTop = rect.top - weight < offsetRect.top;
    final bool isRight = rect.right + weight > offsetRect.right;
    final bool isBottom = rect.bottom + weight > offsetRect.bottom;

    if (isLeft || isTop || isRight || isBottom) {
      _setOffset(
        isLeft ? offsetRect.left - rect.left + weight : 0,
        isTop ? offsetRect.top - rect.top + weight : 0,
        isRight ? rect.right + weight - offsetRect.right : 0,
        isBottom ? rect.bottom + weight - offsetRect.bottom : 0,
      );
    }
  }

  void _setOffset(double left, double top, double right, double bottom) {
    _isMarkNeedRepaint = true;

    _setOffsetRect(
      Rect.fromLTRB(
        offsetRect.left - left,
        offsetRect.top - top,
        offsetRect.right + right,
        offsetRect.bottom + bottom,
      ),
    );

    _updateCanvasSize();
  }

  double? _transformScale;

  void resetMatrixTransform() {
    _setTranslate(0, 0);

    final double devicePixelRatio = _devicePixelRatio;

    if (_transformScale != devicePixelRatio) {
      _transformScale = devicePixelRatio;

      context.setTransform(1 as JSAny, 0, 0, 1, 0, 0);

      if (devicePixelRatio != 1) {
        context.scale(devicePixelRatio, devicePixelRatio);
      }
    }
  }
}
