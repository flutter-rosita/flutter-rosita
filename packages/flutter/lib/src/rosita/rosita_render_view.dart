// ignore_for_file: public_member_api_docs

import 'dart:html' as html;

import 'package:rosita/rosita.dart';

mixin RositaRenderViewMixin on RositaRenderMixin {
  html.HtmlElement? _rositaRootElement;

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
      '}',
    ]);

    styleElement.text = buffer.toString();
    return styleElement;
  }
}
