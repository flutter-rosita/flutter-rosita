// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:rosita/rosita.dart';

class RositaImage extends LeafRenderObjectWidget {
  const RositaImage.asset(
    String name, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
    this.onLoad,
    this.onError,
    String? package,
  }) : src = package == null ? 'assets/$name' : 'assets/packages/$package/$name';

  const RositaImage.network(
    String url, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
    this.onLoad,
    this.onError,
  }) : src = url;

  final String src;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final VoidCallback? onLoad;
  final VoidCallback? onError;

  @override
  RenderRositaImage createRenderObject(BuildContext context) {
    return RenderRositaImage(
      src: src,
      borderRadius: borderRadius,
      fit: fit,
      alignment: alignment,
      onLoad: onLoad,
      onError: onError,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRositaImage renderObject) {
    renderObject
      ..src = src
      ..borderRadius = borderRadius
      ..fit = fit
      ..alignment = alignment
      ..onLoad = onLoad
      ..onError = onError;
  }
}
