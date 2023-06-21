import 'package:flutter/widgets.dart';

typedef ContinuableElementVisitor = bool Function(Element element);

mixin RositaElementMixin {
  void rositaVisitChildren(Element element, ContinuableElementVisitor visitor) {
    Element? target = element;

    while (target != null) {
      if (visitor(target)) {
        switch (target) {
          case RositaSingleChildElementMixin():
            target = (target as RositaSingleChildElementMixin).rositaChild;
          case LeafRenderObjectElement():
            target = null;
          default:
            target.visitChildren((element) => rositaVisitChildren(element, visitor));
            target = null;
        }
      } else {
        break;
      }
    }
  }
}

mixin RositaSingleChildElementMixin {
  Element? get rositaChild;
}
