import 'dart:ui';

import 'package:flutter/foundation.dart';

mixin RositaRectMixin on AbstractNode {
  Rect get parentHtmlRect => (parent as RositaRectMixin).htmlRect;

  Rect? _htmlRect;
  
  Rect get htmlRect => _htmlRect ??= buildHtmlRect();
  
  bool get hasHtmlRect => _htmlRect != null;

  Rect buildHtmlRect();

  void markDirtyHtmlRect() => _htmlRect = null;
}
