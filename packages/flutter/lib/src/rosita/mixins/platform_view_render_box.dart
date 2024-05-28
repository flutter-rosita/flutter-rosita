// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaPlatformViewRenderBoxMixin on RositaRenderMixin {
  @override
  PlatformViewRenderBox get target => this as PlatformViewRenderBox;

  web.HTMLElement? _childHtmlElement;

  int? _viewId;

  @override
  void rositaPaint() {
    final viewId = target.controller.viewId;

    if (_viewId != viewId) {
      _viewId = viewId;

      scheduleMicrotask(() {
        if (!target.attached) {
          return;
        }

        final childHtmlElement = _childHtmlElement;

        if (childHtmlElement != null) {
          childHtmlElement.remove();
          _childHtmlElement = null;
        }

        final el = RositaPlatformViewRegister._viewMap[viewId];

        if (el != null) {
          _childHtmlElement = el;
          htmlElement.append(el as JSAny);
        }
      });
    }
  }
}

class RositaPlatformViewRegister {
  static final _viewMap = <int, web.HTMLElement>{};

  static void createPlatformView({required int viewId, required String viewType}) {
    final view = ui_web.platformViewRegistry.getViewById(viewId);

    if (view is web.HTMLElement) {
      _viewMap[viewId] = view;
    }
  }

  static void disposePlatformView(int viewId) {
    _viewMap[viewId]?.remove();
    _viewMap.remove(viewId);
  }
}
