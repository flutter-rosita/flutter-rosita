// ignore_for_file: public_member_api_docs, avoid_print, always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rosita/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderMixin {
  html.HtmlElement? _htmlElement;

  html.HtmlElement get htmlElement =>
      rositaCastNullableToNonNullable ? _htmlElement as html.HtmlElement : _htmlElement!;

  bool get hasHtmlElement => _htmlElement != null;

  // RenderObject getters

  bool get attached;

  ParentData? get parentData;

  int get depth;

  RenderObject? get parent;

  PipelineOwner? get owner;

  // Call from RenderObject methods

  void rositaAttachToRenderObject() {
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

  void rositaDetachFromRenderObject() {
    rositaMarkNeedsDetach();
  }

  // Rosita

  html.HtmlElement? createRositaElement() => html.DivElement();

  RenderObject get target => this as RenderObject;

  bool _rositaNeedsAttach = true;

  bool _rositaNeedsDetach = false;

  bool _rositaNeedsLayout = true;

  bool _rositaNeedsPaint = true;

  bool _rositaFirstLayout = true;

  RositaPipelineOwnerMixin get rositaOwner => owner as RositaPipelineOwnerMixin;

  void rositaMarkNeedsAttach() {
    if (_rositaNeedsAttach) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsAttach = true;
      rositaOwner._rositaNodesNeedingAttach.add(this);
    }
  }

  void rositaMarkNeedsDetach() {
    if (_rositaNeedsDetach) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsDetach = true;
      rositaOwner._rositaNodesNeedingDetach.add(this);
    }
  }

  void rositaMarkNeedsLayout() {
    if (_rositaNeedsLayout) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsLayout = true;
      rositaOwner._rositaNodesNeedingLayout.add(this);

      if (_rositaFirstLayout && (this is! RenderBox || (this as RenderBox).hasSize)) {
        _rositaFirstLayout = false;
        rositaMarkNeedsPaint();
      }
    }
  }

  void rositaMarkNeedsPaint() {
    if (_rositaNeedsPaint) {
      return;
    }

    if (hasHtmlElement && attached) {
      _rositaNeedsPaint = true;
      rositaOwner._rositaNodesNeedingPaint.add(this);
    }
  }

  void rositaAttach() {
    RenderObject? parentElement = parent;

    ContainerParentDataMixin? containerParentDataMixin;

    if (target.parentData is ContainerParentDataMixin) {
      containerParentDataMixin = target.parentData! as ContainerParentDataMixin;
    }

    while (parentElement != null) {
      if (containerParentDataMixin == null && parentElement.parentData is ContainerParentDataMixin) {
        containerParentDataMixin = parentElement.parentData! as ContainerParentDataMixin;
      }

      if (parentElement is RositaRenderMixin && (parentElement as RositaRenderMixin).hasHtmlElement) {
        break;
      }
      parentElement = parentElement.parent;
    }

    final parentHtmlElement = parentElement is RositaRenderMixin && (parentElement as RositaRenderMixin).hasHtmlElement
        ? (parentElement as RositaRenderMixin).htmlElement
        : null;

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
  Set<RositaPipelineOwnerMixin> get rositaChildren;

  List<RositaRenderMixin> _rositaNodesNeedingAttach = <RositaRenderMixin>[];

  List<RositaRenderMixin> _rositaNodesNeedingDetach = <RositaRenderMixin>[];

  List<RositaRenderMixin> _rositaNodesNeedingLayout = <RositaRenderMixin>[];

  List<RositaRenderMixin> _rositaNodesNeedingPaint = <RositaRenderMixin>[];

  void rositaFlushAttach() {
    try {
      final List<RositaRenderMixin> dirtyNodes = _rositaNodesNeedingAttach;
      _rositaNodesNeedingAttach = <RositaRenderMixin>[];

      for (final node in dirtyNodes) {
        node._rositaNeedsAttach = false;

        if (node.hasHtmlElement) {
          node.rositaAttach();
        }
      }

      for (final child in rositaChildren) {
        child.rositaFlushAttach();
      }
    } finally {}
  }

  void rositaFlushDetach() {
    try {
      final List<RositaRenderMixin> dirtyNodes = _rositaNodesNeedingDetach;
      _rositaNodesNeedingDetach = <RositaRenderMixin>[];

      for (final node in dirtyNodes) {
        node._rositaNeedsDetach = false;

        if (node.hasHtmlElement && !node.attached) {
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
      final List<RositaRenderMixin> dirtyNodes = _rositaNodesNeedingLayout;
      _rositaNodesNeedingLayout = <RositaRenderMixin>[];

      for (final node in dirtyNodes..sort((RositaRenderMixin a, RositaRenderMixin b) => a.depth - b.depth)) {
        node._rositaNeedsLayout = false;

        if (node.hasHtmlElement && (node is! RenderBox || (node as RenderBox).hasSize)) {
          node.rositaLayout();
        }
      }

      for (final child in rositaChildren) {
        child.rositaFlushLayout();
      }
    } finally {}
  }

  void rositaFlushPaint() {
    try {
      final List<RositaRenderMixin> dirtyNodes = _rositaNodesNeedingPaint;
      _rositaNodesNeedingPaint = <RositaRenderMixin>[];

      for (final node in dirtyNodes) {
        node._rositaNeedsPaint = false;

        if (node.hasHtmlElement && (node is! RenderBox || (node as RenderBox).hasSize)) {
          node.rositaPaint();
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

  bool get rositaFlushNeeded =>
      _rositaNodesNeedingAttach.isNotEmpty ||
      _rositaNodesNeedingDetach.isNotEmpty ||
      _rositaNodesNeedingLayout.isNotEmpty ||
      _rositaNodesNeedingPaint.isNotEmpty;
}
