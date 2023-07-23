import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

abstract class RositaRenderBox extends RenderBox {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  html.HtmlElement get htmlElement;

  html.HtmlElement? createRositaElement();

  void rositaAttach();

  @mustCallSuper
  void rositaDetach();

  @mustCallSuper
  void rositaLayout();

  void rositaPaint();
}