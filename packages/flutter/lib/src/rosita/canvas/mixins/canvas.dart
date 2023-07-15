part of '../rosita_canvas.dart';

mixin _CanvasMixin {
  html.CanvasElement get canvas;

  html.CanvasRenderingContext2D get context;

  bool _isDirty = false;

  void _setDirty() => _isDirty = true;

  void clean(Size size) {
    canvas.width = size.width.toInt();
    canvas.height = size.height.toInt();

    if (_isDirty) {
      context.clearRect(0, 0, canvas.width!, canvas.height!);
      _isDirty = false;
    }
  }

  void checkDirty() {
    canvas.style.display = _isDirty ? 'block' : 'none';
  }
}
