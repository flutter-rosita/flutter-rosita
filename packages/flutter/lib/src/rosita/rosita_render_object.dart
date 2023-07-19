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
      _rositaNeedsAttach = false;
      _rositaNeedsLayout = false;
      _rositaNeedsPaint = false;
      rositaMarkNeedsAttach();
      rositaMarkNeedsLayout();
      rositaMarkNeedsPaint();
    }
  }

  @override
  void detach() {
    rositaMarkNeedsDetach();
    super.detach();
  }

  void createRositaElement() {
    _htmlElement = html.DivElement();
  }

  RenderObject get target => this as RenderObject;

  bool _rositaNeedsAttach = true;

  bool _rositaNeedsDetach = false;

  bool _rositaNeedsLayout = true;

  bool _rositaNeedsPaint = true;

  void rositaMarkNeedsAttach() {
    if (_rositaNeedsAttach) {
      return;
    }

    final owner = this.owner;

    if (owner is RositaPipelineOwnerMixin) {
      if (hasHtmlElement) {
        _rositaNeedsAttach = true;
        owner._rositaNodesNeedingAttach.add(target);
      }
    }
  }

  void rositaMarkNeedsDetach() {
    if (_rositaNeedsDetach) {
      return;
    }

    final owner = this.owner;

    if (owner is RositaPipelineOwnerMixin) {
      if (hasHtmlElement) {
        _rositaNeedsDetach = true;
        owner._rositaNodesNeedingDetach.add(target);
      }
    }
  }

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

  void rositaAttach() {
    AbstractNode? parentElement = parent;

    int elementIndex = 0;

    ContainerParentDataMixin? containerParentDataMixin;

    if (target.parentData is ContainerParentDataMixin) {
      containerParentDataMixin = target.parentData! as ContainerParentDataMixin;
    }

    while (parentElement != null) {
      if (containerParentDataMixin == null && parentElement is RenderObject && parentElement.parentData is ContainerParentDataMixin) {
        containerParentDataMixin = parentElement.parentData! as ContainerParentDataMixin;
      }

      if (parentElement is RositaRenderMixin && parentElement.hasHtmlElement) {
        break;
      }
      parentElement = parentElement.parent;
    }

    if (containerParentDataMixin != null) {
      while(containerParentDataMixin?.previousSibling != null) {
        elementIndex++;
        containerParentDataMixin = containerParentDataMixin?.previousSibling?.parentData as ContainerParentDataMixin?;
      }
    }

    final parentHtmlElement =
        parentElement is RositaRenderMixin && parentElement.hasHtmlElement ? parentElement.htmlElement : null;

    assert(() {
      htmlElement.setAttribute('rosita-debug-object', '${describeIdentity(this)}/$elementIndex');
      return true;
    }());

    if (parentHtmlElement != null) {
      final children = parentHtmlElement.children;

      if (children.length - 1 < elementIndex) {
        parentHtmlElement.append(htmlElement);
      } else {
        final beforeElement = parentHtmlElement.children[elementIndex];
        parentHtmlElement.insertBefore(htmlElement, beforeElement);
      }
    } else {
      throw Exception('Parent HtmlElement not found for: $this');
    }
  }

  @mustCallSuper
  void rositaDetach() {
    _htmlElement?.remove();
    _htmlElement = null;
  }

  @mustCallSuper
  void rositaLayout() {}

  void rositaPaint() {}
}

mixin RositaPipelineOwnerMixin {
  Set<PipelineOwner> get rositaChildren;

  List<RenderObject> _rositaNodesNeedingAttach = <RenderObject>[];

  List<RenderObject> _rositaNodesNeedingDetach = <RenderObject>[];

  List<RenderObject> _rositaNodesNeedingLayout = <RenderObject>[];

  List<RenderObject> _rositaNodesNeedingPaint = <RenderObject>[];

  void rositaFlushAttach() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingAttach;
      _rositaNodesNeedingAttach = <RenderObject>[];

      for (final RenderObject node in dirtyNodes) {
        if (node.owner == this) {
          node._rositaNeedsAttach = false;
          if (node.hasHtmlElement) {
            node.rositaAttach();
          }
        }
      }
      for (final child in rositaChildren) {
        child.rositaFlushAttach();
      }
    } finally {}
  }

  void rositaFlushDetach() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingDetach;
      _rositaNodesNeedingDetach = <RenderObject>[];

      for (final RenderObject node in dirtyNodes) {
        node._rositaNeedsDetach = false;
        if (node.hasHtmlElement) {
          node.rositaDetach();
        }
      }
      for (final child in rositaChildren) {
        child.rositaFlushDetach();
      }
    } finally {}
  }

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
