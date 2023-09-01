import 'package:flutter/widgets.dart';

mixin RositaElementMixin {
  void rositaVisitChildren(Element element, ElementVisitor visitor) {
    Element? target = element;

    while (target != null) {
      visitor(target);

      switch (target) {
        case RositaSingleChildElementMixin():
          target = (target as RositaSingleChildElementMixin).rositaChild;
        case LeafRenderObjectElement():
          target = null;
        default:
          target.visitChildren((element) => rositaVisitChildren(element, visitor));
          target = null;
      }
    }
  }

  void rositaVisitChildrenFromLeaf(Element element, ElementVisitor visitor, {List<Element>? elements}) {
    final list = elements ?? <Element>[];
    Element? target = element;

    while (target != null) {
      list.add(target);

      switch (target) {
        case RositaSingleChildElementMixin():
          target = (target as RositaSingleChildElementMixin).rositaChild;
        case LeafRenderObjectElement():
          target = null;
        default:
          target.visitChildren((element) => rositaVisitChildrenFromLeaf(element, visitor, elements: list));
          target = null;
      }
    }

    if (elements == null) {
      for (int i = list.length - 1; i >= 0; i--) {
        visitor(list[i]);
      }
    }
  }
}

mixin RositaSingleChildElementMixin {
  Element? get rositaChild;
}
