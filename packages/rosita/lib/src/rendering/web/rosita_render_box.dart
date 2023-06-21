part of '../web_rendering.dart';

abstract class RositaRenderBox extends RenderBox {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  web.HTMLElement get htmlElement;

  web.HTMLElement? createRositaElement();

  void rositaAttach();

  void rositaDetach();

  @mustCallSuper
  void rositaLayout();

  void rositaPaint();
}

abstract class RositaRenderProxyBoxWithHitTestBehavior extends RenderProxyBoxWithHitTestBehavior {
  RositaRenderProxyBoxWithHitTestBehavior({super.behavior = HitTestBehavior.opaque});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  web.HTMLElement get htmlElement;

  web.HTMLElement? createRositaElement();

  void rositaAttach();

  void rositaDetach();

  @mustCallSuper
  void rositaLayout();

  void rositaPaint();

  JSAny get styleTransform;

  set styleTransform(JSAny value);

  Offset? get localOffset;
}
