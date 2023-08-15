// ignore_for_file: public_member_api_docs, avoid_print, always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

import 'rosita_rect.dart';

mixin RositaRenderMixin on AbstractNode, RositaRectMixin {
  html.HtmlElement? _htmlElement;

  html.HtmlElement get htmlElement => _htmlElement!;

  bool get hasHtmlElement => _htmlElement != null;

  @override
  Rect buildHtmlRect() => parentHtmlRect;

  @override
  void attach(covariant Object owner) {
    super.attach(owner);

    _htmlElement = createRositaElement();

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

  html.HtmlElement? createRositaElement() => html.DivElement();

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
          if ((child as RositaRenderMixin).hasHtmlElement) {
            (child as RositaRenderMixin).rositaMarkNeedsLayout();
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
      if (containerParentDataMixin == null &&
          parentElement is RenderObject &&
          parentElement.parentData is ContainerParentDataMixin) {
        containerParentDataMixin = parentElement.parentData! as ContainerParentDataMixin;
      }

      if (parentElement is RositaRenderMixin && parentElement.hasHtmlElement) {
        break;
      }
      parentElement = parentElement.parent;
    }

    if (containerParentDataMixin != null) {
      while (containerParentDataMixin?.previousSibling != null) {
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

  RenderBox? findFirstChildWithHtmlElement() {
    late RenderObjectVisitor visitor;

    RenderBox? rositaObject;

    visitor = (RenderObject element) {
      if (rositaObject != null) {
        // End visitChildren
      } else if (element is RenderBox && (element as RositaRenderMixin).hasHtmlElement) {
        rositaObject = element;
      } else {
        element.visitChildren(visitor);
      }
    };

    target.visitChildren(visitor);

    return rositaObject;
  }
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
          (node as RositaRenderMixin)._rositaNeedsAttach = false;
          if ((node as RositaRenderMixin).hasHtmlElement) {
            (node as RositaRenderMixin).rositaAttach();
          }
        }
      }
      for (final child in rositaChildren) {
        (child as RositaPipelineOwnerMixin).rositaFlushAttach();
      }
    } finally {}
  }

  void rositaFlushDetach() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingDetach;
      _rositaNodesNeedingDetach = <RenderObject>[];

      for (final RenderObject node in dirtyNodes) {
        (node as RositaRenderMixin)._rositaNeedsDetach = false;
        if ((node as RositaRenderMixin).hasHtmlElement) {
          (node as RositaRenderMixin).rositaDetach();
        }
      }
      for (final child in rositaChildren) {
        (child as RositaPipelineOwnerMixin).rositaFlushDetach();
      }
    } finally {}
  }

  void rositaFlushLayout() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingLayout;
      _rositaNodesNeedingLayout = <RenderObject>[];

      for (final RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => a.depth - b.depth)) {
        if (node.owner == this) {
          final el = node as RositaRenderMixin;

          el._rositaNeedsLayout = false;

          if (el.hasHtmlElement && (el is! RenderBox || (el as RenderBox).hasSize)) {
            el.rositaLayout();
          }
        }
      }
      for (final child in rositaChildren) {
        (child as RositaPipelineOwnerMixin).rositaFlushLayout();
      }
    } finally {}
  }

  void rositaFlushPaint() {
    try {
      final List<RenderObject> dirtyNodes = _rositaNodesNeedingPaint;
      _rositaNodesNeedingPaint = <RenderObject>[];

      for (final RenderObject node in dirtyNodes) {
        if (node.owner == this) {
          final el = node as RositaRenderMixin;

          el._rositaNeedsPaint = false;

          if (el.hasHtmlElement && (el is! RenderBox || (el as RenderBox).hasSize)) {
            el.rositaPaint();
          }
        }
      }
      for (final child in rositaChildren) {
        (child as RositaPipelineOwnerMixin).rositaFlushPaint();
      }
    } finally {}
  }

  static void rositaDrawFrame(VoidCallback callback) {
    html.window.requestAnimationFrame((highResTime) {
      callback();
    });
  }

  bool get rositaFlushNeeded =>
      _rositaNodesNeedingAttach.isNotEmpty ||
      _rositaNodesNeedingDetach.isNotEmpty ||
      _rositaNodesNeedingLayout.isNotEmpty ||
      _rositaNodesNeedingPaint.isNotEmpty;
}
