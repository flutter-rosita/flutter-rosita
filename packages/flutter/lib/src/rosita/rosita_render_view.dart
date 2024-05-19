// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderViewMixin on RositaRenderMixin {
  html.HtmlElement? _rositaRootElement;

  @override
  RenderView get target => this as RenderView;

  @override
  void rositaAttach() {
    if (_rositaRootElement != null) {
      return;
    }

    final fltGlassPane = html.document.getElementsByTagName('flt-glass-pane').first as html.HtmlElement;
    final root = fltGlassPane.shadowRoot ?? fltGlassPane;
    final rositaRootElement = html.DivElement()..className = 'rosita-root-element';

    root.append(rositaRootElement);
    root.append(createStyleElement());

    _rositaRootElement = rositaRootElement;

    rositaRootElement.append(htmlElement);
  }

  html.StyleElement createStyleElement() {
    final styleElement = html.StyleElement();
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
