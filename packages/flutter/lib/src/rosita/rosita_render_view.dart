// ignore_for_file: public_member_api_docs

import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderViewMixin on RositaRenderMixin {
  html.HtmlElement? _rositaRootElement;

  @override
  RenderView get target => this as RenderView;

  @override
  Rect buildHtmlRect() => Offset.zero & target.size;

  @override
  void rositaAttach() {
    if (_rositaRootElement != null) {
      return;
    }

    final shadowRoot = (html.document.getElementsByTagName('flt-glass-pane').first as html.HtmlElement).shadowRoot!;

    final rositaRootElement = html.DivElement()..className = 'rosita-root-element';

    shadowRoot.append(rositaRootElement);
    shadowRoot.append(createStyleElement());

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
      '}',
      '.rosita-root-element canvas {',
      'position: absolute;',
      '}',
      '.rosita-root-element img {',
      'width: 100%;',
      'height: 100%;',
      '}',
    ]);

    styleElement.text = buffer.toString();
    return styleElement;
  }
}
