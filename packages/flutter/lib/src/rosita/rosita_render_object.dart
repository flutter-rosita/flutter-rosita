// ignore_for_file: public_member_api_docs, avoid_print, always_specify_types

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

      _rositaNeedsLayout = false;
      _rositaNeedsPaint = false;
      rositaMarkNeedsLayout();
      rositaMarkNeedsPaint();
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

  bool _rositaNeedsLayout = true;

  bool _rositaNeedsPaint = true;

  void rositaMarkNeedsLayout() {
    if (_rositaNeedsLayout) {
      return;
    }

    final owner = this.owner;

    if (owner is RositaPipelineOwnerMixin) {
      if (hasHtmlElement) {
        _rositaNeedsLayout = true;
        owner._rositaNodesNeedingLayout.add(target);
      } else {
        late RenderObjectVisitor visitor;
        visitor = (RenderObject child) {
          if (child.hasHtmlElement) {
            child.rositaMarkNeedsLayout();
          } else {
            child.visitChildren(visitor);
          }
        };
        target.visitChildren(visitor);
      }
    }
  }

  void rositaMarkNeedsPaint() {
    if (_rositaNeedsPaint) {
      return;
    }

    final owner = this.owner;

    if (owner is RositaPipelineOwnerMixin) {
      if (hasHtmlElement) {
        _rositaNeedsPaint = true;
        owner._rositaNodesNeedingPaint.add(target);
      }
    }
  }

  @mustCallSuper
  void rositaLayout() {}

  void rositaPaint() {}
}

mixin RositaPipelineOwnerMixin {
  Set<PipelineOwner> get rositaChildren;

  List<RenderObject> _rositaNodesNeedingLayout = <RenderObject>[];

  List<RenderObject> _rositaNodesNeedingPaint = <RenderObject>[];

  void rositaFlushLayout() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingLayout;
      _rositaNodesNeedingLayout = <RenderObject>[];

      for (final RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => b.depth - a.depth)) {
        if (node.owner == this) {
          node._rositaNeedsLayout = false;
          if (node.hasHtmlElement) {
            node.rositaLayout();
          }
        }
      }
      for (final child in rositaChildren) {
        child.rositaFlushLayout();
      }
    } finally {}
  }

  void rositaFlushPaint() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingPaint;
      _rositaNodesNeedingPaint = <RenderObject>[];

      for (final RenderObject node in dirtyNodes) {
        if (node.owner == this) {
          node._rositaNeedsPaint = false;
          if (node.hasHtmlElement) {
            node.rositaPaint();
          }
        }
      }
      for (final child in rositaChildren) {
        child.rositaFlushPaint();
      }
    } finally {}
  }

  static void rositaDrawFrame(VoidCallback callback) {
    html.window.requestAnimationFrame((highResTime) {
      callback();
    });
  }
}
