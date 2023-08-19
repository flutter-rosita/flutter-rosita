part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  int offset = 0;

  html.CanvasElement get canvas;

  html.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  void _setDirty() => _isDirty = true;

  Size? _size;

  late ({int width, int height}) _sizeWithOffset;

  void clean(Size size) {
    if (_size != size) {
      _size = size;

      canvas.style.left = '-${offset}px';
      canvas.style.top = '-${offset}px';

      _sizeWithOffset = (
        width: size.width.toInt() + offset * 2,
        height: size.height.toInt() + offset * 2,
      );

      canvas.width = _sizeWithOffset.width;
      canvas.height = _sizeWithOffset.height;
    }

    if (_isDirty) {
      context.clearRect(
        -offset,
        -offset,
        _sizeWithOffset.width + offset,
        _sizeWithOffset.height + offset,
      );
      _isDirty = false;
    }
  }

  void checkDirty() {
    canvas.style.display = _isDirty ? 'block' : 'none';
  }
}
