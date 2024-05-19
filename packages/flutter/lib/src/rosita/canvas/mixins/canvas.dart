part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  static const double _defaultOffset = 10.0;

  double get _devicePixelRatio {
    final num devicePixelRatio = html.window.devicePixelRatio;
    final int outerWidth = html.window.outerWidth;
    final int innerWidth = html.window.innerWidth ?? outerWidth;

    return devicePixelRatio / (outerWidth / innerWidth);
  }

  Rect offsetRect = Rect.zero;

  Offset? _offset;

  Offset get offset => _offset!;

  html.CanvasElement get canvas;

  html.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  bool _isMarkNeedRepaint = false;

  bool get isMarkNeedRepaint => _isMarkNeedRepaint;

  void _setDirty(Rect rect, double weight) {
    _isDirty = true;
    _checkRectOverflow(rect, weight);
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

    final Rect(:left, :top, :width, :height) = rect;
    final double scale = _devicePixelRatio;

    if (scale != 1) {
      canvas.style.transform = 'scale(${1 / scale})translate(${left * scale - width}px,${top * scale - height}px)';
    } else if (left != 0 || top != 0) {
      canvas.style.transform = 'translate(${left}px,${top}px)';
    } else {
      canvas.style.transform = '';
    }

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
  }

  void resetMatrixTransform() {
    context.setTransform(1, 0, 0, 1, 0, 0);

    final double devicePixelRatio = _devicePixelRatio;

    if (devicePixelRatio != 1) {
      context.scale(devicePixelRatio, devicePixelRatio);
    }
  }
}
