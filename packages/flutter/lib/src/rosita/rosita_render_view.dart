// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:web/web.dart' as web;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rosita/rosita_web.dart';

mixin RositaRenderViewMixin on RositaRenderMixin {
  web.HTMLElement? _rositaRootElement;

  @override
  RenderView get target => this as RenderView;

  @override
  void rositaAttach() {
    if (_rositaRootElement != null) {
      return;
    }

    final fltGlassPane = web.document.getElementsByTagName('flt-glass-pane').item(0)! as web.HTMLElement;
    final root = fltGlassPane.shadowRoot ?? fltGlassPane;
    final rositaRootElement = web.HTMLDivElement()..className = 'rosita-root-element';

    root.append(rositaRootElement);
    root.append(createStyleElement());

    _rositaRootElement = rositaRootElement;

    rositaRootElement.append(htmlElement);
  }

  web.HTMLStyleElement createStyleElement() {
    final styleElement = web.HTMLStyleElement();
    final buffer = StringBuffer();

    buffer.writeAll([
      '.rosita-root-element, .rosita-root-element div {',
      'position: absolute;',
      'box-sizing: border-box;',
      'z-index: 0;',
      '}',
      '.rosita-root-element canvas, .rosita-root-element img {',
      'position: absolute;',
      '}',
    ]);

    styleElement.text = buffer.toString();
    return styleElement;
  }

  double? _devicePixelRatio;

  @override
  void rositaLayout() {
    super.rositaLayout();

    final devicePixelRatio = target.configuration.devicePixelRatio /
        WidgetsBinding.instance.platformDispatcher.implicitView!.devicePixelRatio;

    if (_devicePixelRatio != devicePixelRatio) {
      _devicePixelRatio = devicePixelRatio;
      htmlElement.style.transform = devicePixelRatio != 1.0 ? 'scale($devicePixelRatio)' : '';
    }
  }
}
