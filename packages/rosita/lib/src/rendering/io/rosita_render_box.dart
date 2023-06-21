part of '../io_rendering.dart';

abstract class RositaRenderBox extends RenderBox {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

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

  void rositaAttach();

  void rositaDetach();

  @mustCallSuper
  void rositaLayout();

  void rositaPaint();
}
