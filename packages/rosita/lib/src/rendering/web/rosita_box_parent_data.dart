part of '../web_rendering.dart';

mixin RositaBoxParentDataMixin {
  bool rositaIsReady = false;

  VoidCallback? rositaCallback;

  Offset _offset = Offset.zero;

  Offset get offset => _offset;

  set offset(Offset value) {
    if (!rositaIsReady) {
      _offset = value;
      return;
    }

    if (_offset == value) return;

    _offset = value;

    rositaCallback?.call();
  }
}
