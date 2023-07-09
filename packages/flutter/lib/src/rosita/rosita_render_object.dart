// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../widgets.dart';

mixin RositaRenderMixin on AbstractNode {
  html.HtmlElement? _htmlElement;

  html.HtmlElement get htmlElement => _htmlElement!;

  bool get hasHtmlElement => _htmlElement != null;

  @override
  void attach(covariant Object owner) {
    super.attach(owner);

    createRositaElement();

    if (hasHtmlElement) {
      final parentHtmlElement = findParentHtmlElement();

      assert(() {
        htmlElement.setAttribute('rosita-debug-object', describeIdentity(this));
        return true;
      }());

      if (parentHtmlElement != null) {
        parentHtmlElement.append(htmlElement);
      } else {
        throw Exception('Parent HtmlElement not found for: $this');
      }
    }
  }

  @override
  void detach() {
    super.detach();
    _htmlElement?.remove();
    _htmlElement = null;
  }

  @override
  void adoptChild(covariant AbstractNode child) {
    super.adoptChild(child);
  }

  @override
  void dropChild(covariant AbstractNode child) {
    super.dropChild(child);
  }

  void createRositaElement() {
    _htmlElement = html.DivElement();
  }

  html.HtmlElement? findParentHtmlElement() {
    AbstractNode? element = parent;

    while (element != null) {
      if (element is RositaRenderMixin && element.hasHtmlElement) {
        return element.htmlElement;
      }
      element = element.parent;
    }

    return null;
  }

  RenderObject get target => this as RenderObject;

  @mustCallSuper
  void rositaLayout() {}

  void callRositaLayout() {
    RendererBinding.instance.addPostFrameCallback((_) {
      if (hasHtmlElement) {
        rositaLayout();
      }
    });
  }
}
