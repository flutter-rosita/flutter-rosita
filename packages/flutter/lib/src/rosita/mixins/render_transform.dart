// ignore_for_file: public_member_api_docs, always_specify_types
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

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
    final alignment = target.alignment?.resolve(target.textDirection);
    final Offset(:dx, :dy) = offset;

    if (transform != null) {
      if (transform.isIdentity()) {
        styleTransform = '' as JSAny;
      } else if (_isScale(transform.storage)) {
        styleTransform = ('scale(' as JSAny)
            .add(transform.storage[0] as JSAny)
            .add(',' as JSAny)
            .add(transform.storage[5] as JSAny)
            .add(')' as JSAny);
      } else {
        styleTransform = 'matrix3d(${transform.storage.join(',')})' as JSAny;
      }
    }

    (style as JSObject).setProperty(
        'transformOrigin' as JSAny,
        alignment != null && alignment != Alignment.center
            ? ((1 + alignment.x) / 2 * 100 as JSAny)
                .add('% ' as JSAny)
                .add((1 + alignment.y) / 2 * 100 as JSAny)
                .add('%' as JSAny)
            : '' as JSAny);

    if (dx != 0 || dy != 0) {
      (style as JSObject).setProperty(
        'transform' as JSAny,
        ('translate(' as JSAny)
            .add(dx as JSAny)
            .add('px,' as JSAny)
            .add(dy as JSAny)
            .add('px)' as JSAny)
            .add(styleTransform),
      );
    } else {
      (style as JSObject).setProperty('transform' as JSAny, styleTransform);
    }
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
