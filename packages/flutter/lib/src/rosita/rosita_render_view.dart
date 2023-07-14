// ignore_for_file: public_member_api_docs

import 'dart:html' as html;

import 'rosita_render_object.dart';

mixin RositaRenderViewMixin on RositaRenderMixin {
  html.HtmlElement? _rositaRootElement;

  @override
  html.HtmlElement findParentHtmlElement() {
    if (_rositaRootElement != null) {
      return _rositaRootElement!;
    }

    final shadowRoot = (html.document.getElementsByTagName('flt-glass-pane').first as html.HtmlElement).shadowRoot!;

    final rositaRootElement = html.DivElement()..className = 'rosita-root-element';

    shadowRoot.append(rositaRootElement);
    shadowRoot.append(createStyleElement());

    _rositaRootElement = rositaRootElement;

    return rositaRootElement;
  }

  html.StyleElement createStyleElement() {
    final styleElement = html.StyleElement();
    final buffer = StringBuffer();

    buffer.writeAll([
      '.rosita-root-element, .rosita-root-element div {',
      'width: 100%;',
      'height: 100%;',
      'inset: 0;',
      'position: absolute;',
      '}',
    ]);

    styleElement.text = buffer.toString();
    return styleElement;
  }
}
