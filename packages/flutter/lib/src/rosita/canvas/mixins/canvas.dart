part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  int get overscan;

  html.CanvasElement get canvas;

  html.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  void _setDirty() => _isDirty = true;

  void clean(Size size) {
    canvas.style.left = '-${overscan}px';
    canvas.style.top = '-${overscan}px';

    canvas.width = size.width.toInt() + overscan * 2;
    canvas.height = size.height.toInt() + overscan * 2;

    context.translate(overscan, overscan);

    if (_isDirty) {
      context.clearRect(0, 0, canvas.width!, canvas.height!);
      _isDirty = false;
    }
  }

  void checkDirty() {
    canvas.style.display = _isDirty ? 'block' : 'none';
  }
}
