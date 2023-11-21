// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderTransform on RositaRenderBoxMixin {
  @override
  RenderTransform get target => this as RenderTransform;

  @override
  void rositaPaint() {
    final style = htmlElement.style;
    final origin = target.origin ?? Offset.zero;
    final transform = target.rositaTransform;
    final offset = origin + (localOffset ?? Offset.zero);

    if (transform != null) {
      if (transform.isIdentity()) {
        styleTransform = '';
      } else if (_isScale(transform.storage)) {
        styleTransform = 'scale(${transform.storage[0]},${transform.storage[5]})';
      } else {
        styleTransform = 'matrix3d(${transform.storage.join(',')})';
      }
    }

    style.transform = 'translate(${offset.dx}px,${offset.dy}px)$styleTransform';
  }

  bool _isScale(Float64List list) {
    if (list[0] != 1 || list[5] != 1) {
      return list[1] == 0 &&
          list[2] == 0 &&
          list[3] == 0 &&
          list[4] == 0 &&
          list[6] == 0 &&
          list[7] == 0 &&
          list[8] == 0 &&
          list[9] == 0 &&
          list[10] == 1 &&
          list[11] == 0 &&
          list[12] == 0 &&
          list[13] == 0 &&
          list[14] == 0 &&
          list[15] == 1;
    }

    return false;
  }
}
