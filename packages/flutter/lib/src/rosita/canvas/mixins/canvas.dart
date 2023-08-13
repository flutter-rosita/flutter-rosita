part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  int get overscan;

  html.CanvasElement get canvas;

  html.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  void _setDirty() => _isDirty = true;

  Size? _size;

  late ({int width, int height}) _sizeWithOverscan;

  void clean(Size size) {
    if (_size != size) {
      _size = size;

      canvas.style.left = '-${overscan}px';
      canvas.style.top = '-${overscan}px';

      _sizeWithOverscan = (
        width: size.width.toInt() + overscan * 2,
        height: size.height.toInt() + overscan * 2,
      );

      canvas.width = _sizeWithOverscan.width;
      canvas.height = _sizeWithOverscan.height;

      context.translate(overscan, overscan);
    }

    if (_isDirty) {
      context.clearRect(-overscan, -overscan, _sizeWithOverscan.width, _sizeWithOverscan.height);
      _isDirty = false;
    }
  }

  void checkDirty() {
    canvas.style.display = _isDirty ? 'block' : 'none';
  }
}
