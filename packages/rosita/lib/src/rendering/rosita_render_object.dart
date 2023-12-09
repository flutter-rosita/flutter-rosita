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
    assert(() {
      htmlElement.setAttribute('rosita-debug-object', describeIdentity(this));
      return true;
    }());

    html.HtmlElement? parentHtmlElement;
    html.HtmlElement? afterHtmlElement;

    RenderObject? parentElement = parent;
    ParentData? parentData = this.parentData;

    while (parentElement != null) {
      if (parentElement is RositaRenderMixin && (parentElement as RositaRenderMixin).hasHtmlElement) {
        parentHtmlElement = (parentElement as RositaRenderMixin).htmlElement;

        if (parentData is ContainerParentDataMixin) {
          while (afterHtmlElement == null && parentData is ContainerParentDataMixin) {
            final afterElement = parentData.nextSibling;

            parentData = afterElement?.parentData;

            if (afterElement is RositaRenderMixin) {
              if ((afterElement as RositaRenderMixin).hasHtmlElement) {
                afterHtmlElement = (afterElement as RositaRenderMixin).htmlElement;
              } else {
                afterHtmlElement =
                    ((afterElement as RositaRenderMixin).findFirstChildWithHtmlElement() as RositaRenderMixin?)
                        ?.htmlElement;
              }

              while (afterHtmlElement != null && !identical(parentHtmlElement, afterHtmlElement.parentNode)) {
                afterHtmlElement = afterHtmlElement.parentNode as html.HtmlElement?;
              }
            }
          }
        }
        break;
      }

      parentData = parentElement.parentData;
      parentElement = parentElement.parent;
    }

    if (parentHtmlElement != null) {
      parentHtmlElement.insertBefore(htmlElement, afterHtmlElement);
    } else {
      throw Exception('Parent HtmlElement not found for: $this');
    }
  }

  @mustCallSuper
  void rositaDetach() {
    final parent = this.parent as RositaRenderMixin?;

    if (parent != null && parent._rositaNeedsDetach && parent.hasHtmlElement) {
      _htmlElement = null;
      return;
    }

    _htmlElement?.remove();
    _htmlElement = null;
  }

  @mustCallSuper
  void rositaLayout() {
    if (_rositaFirstLayout) {
      _rositaFirstLayout = false;
      rositaMarkNeedsPaint();
    }
  }

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

      for (final node in dirtyNodes.reversed) {
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

        if (node.hasHtmlElement) {
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

        if (node.hasHtmlElement) {
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
