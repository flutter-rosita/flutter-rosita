// ignore_for_file: public_member_api_docs, avoid_print, always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

import 'rosita_rect.dart';

mixin RositaRenderMixin on AbstractNode, RositaRectMixin {
  html.HtmlElement? _htmlElement;

  html.HtmlElement get htmlElement => _htmlElement as html.HtmlElement;

  bool get hasHtmlElement => _htmlElement != null;

  @override
  Rect buildHtmlRect() => parentHtmlRect;

  @override
  void attach(covariant Object owner) {
    super.attach(owner);

    if (hasHtmlElement) {
      _rositaNeedsAttach = false;
      rositaMarkNeedsAttach();
    } else {
      final htmlElement = createRositaElement();

      if (htmlElement != null) {
        _htmlElement = htmlElement;
        _rositaNeedsAttach = false;
        _rositaNeedsLayout = false;
        _rositaNeedsPaint = false;
        rositaMarkNeedsAttach();
        rositaMarkNeedsLayout();
        rositaMarkNeedsPaint();
      }
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

    if (hasHtmlElement && attached) {
      _rositaNeedsAttach = true;
      (owner as RositaPipelineOwnerMixin)._rositaNodesNeedingAttach.add(this as RenderObject);
    }
  }

  void rositaMarkNeedsDetach() {
    if (_rositaNeedsDetach) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsDetach = true;
      (owner as RositaPipelineOwnerMixin)._rositaNodesNeedingDetach.add(this as RenderObject);
    }
  }

  void rositaMarkNeedsLayout() {
    if (_rositaNeedsLayout) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsLayout = true;
      (owner as RositaPipelineOwnerMixin)._rositaNodesNeedingLayout.add(this as RenderObject);
    }
  }

  void rositaMarkNeedsPaint() {
    if (_rositaNeedsPaint) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsPaint = true;
      (owner as RositaPipelineOwnerMixin)._rositaNodesNeedingPaint.add(this as RenderObject);
    }
  }

  void rositaAttach() {
    AbstractNode? parentElement = parent;

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

    final parentHtmlElement =
        parentElement is RositaRenderMixin && parentElement.hasHtmlElement ? parentElement.htmlElement : null;

    assert(() {
      htmlElement.setAttribute('rosita-debug-object', describeIdentity(this));
      return true;
    }());

    if (parentHtmlElement != null) {
      if (containerParentDataMixin != null && containerParentDataMixin.nextSibling != null) {
        final afterElement = containerParentDataMixin.nextSibling as RositaRenderMixin;
        final afterHtmlElement = (afterElement.hasHtmlElement
                ? afterElement
                : (afterElement.findFirstChildWithHtmlElement() as RositaRenderMixin?))
            ?.htmlElement;

        if (afterHtmlElement != null && identical(parentHtmlElement, afterHtmlElement.parent)) {
          parentHtmlElement.insertBefore(htmlElement, afterHtmlElement);
          return;
        }
      }

      parentHtmlElement.append(htmlElement);
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
        if ((node as RositaRenderMixin).hasHtmlElement && !node.attached) {
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
