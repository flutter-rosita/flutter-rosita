// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderTransform on RositaRenderBoxMixin {
  @override
  RenderTransform get target => this as RenderTransform;

  @override
  void rositaPaint() {
    final origin = target.origin;
    final transform = target.rositaTransform;

    if (origin != null) {
      final offset = origin + (localOffset ?? Offset.zero);

      htmlElement.style.left = '${offset.dx}px';
      htmlElement.style.top = '${offset.dy}px';
    }

    if (transform != null) {
      if (transform.isIdentity()) {
        htmlElement.style.transform = '';
      } else {
        htmlElement.style.transform = 'matrix3d(${transform.storage.join(',')})';
      }
    }
  }
}
