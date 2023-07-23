// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaRenderViewportBaseMixin on RositaRenderMixin {
  @override
  RenderViewportBase get target => this as RenderViewportBase;

  @override
  html.HtmlElement? createRositaElement() {
    final htmlElement = super.createRositaElement()!;

    if (target.clipBehavior != Clip.none) {
      htmlElement.style.overflow = 'hidden';
    }

    return htmlElement;
  }
}
