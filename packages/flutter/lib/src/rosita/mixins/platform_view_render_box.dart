// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:html' as html;

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

mixin RositaPlatformViewRenderBoxMixin on RositaRenderMixin {
  @override
  PlatformViewRenderBox get target => this as PlatformViewRenderBox;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final controller = target.controller;
    final el = RositaPlatformViewRegister._viewMap[controller.viewId];

    if (el != null) {
      htmlElement.append(el);
    }
  }
}

class RositaPlatformViewRegister {
  static final _viewMap = <int, html.HtmlElement>{};

  static void createPlatformView(({int viewId, String viewType}) arguments) {
    final viewList = html.document.getElementsByTagName('flt-platform-view');

    final el = viewList.cast<html.HtmlElement>().firstWhereOrNull((el) => el.slot == 'flt-pv-slot-${arguments.viewId}');

    final child = el?.firstChild;

    if (child is html.HtmlElement) {
      _viewMap[arguments.viewId] = child;
    }
  }

  static void disposePlatformView(int viewId) {
    _viewMap[viewId]?.remove();
    _viewMap.remove(viewId);
  }
}
