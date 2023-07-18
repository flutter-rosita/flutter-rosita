// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderDecoratedBoxMixin on RositaRenderMixin {
  @override
  RenderDecoratedBox get target => this as RenderDecoratedBox;

  @override
  void rositaPaint() {
    final decoration = target.decoration;

    if (decoration is BoxDecoration) {
      htmlElement.style.background = '${decoration.color?.toHexString()}';
    }
  }
}