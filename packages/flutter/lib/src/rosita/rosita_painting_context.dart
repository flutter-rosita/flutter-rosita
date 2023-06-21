// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';

class RositaContainerLayer extends ContainerLayer {}

class RositaPaintingContext extends PaintingContext {
  RositaPaintingContext(this.canvas) : super(RositaContainerLayer(), Rect.zero);

  @override
  final RositaCanvas canvas;
}
