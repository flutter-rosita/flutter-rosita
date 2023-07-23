// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderImageMixin on RositaRenderMixin, RositaImageProviderProxyMixin {
  @override
  RenderImage get target => this as RenderImage;

  html.ImageElement? _imageElement;

  html.ImageElement get imageElement {
    _imageElement ??= html.ImageElement();

    final imageElement = _imageElement!;

    imageElement.style.width = '100%';
    imageElement.style.height = '100%';

    htmlElement.append(imageElement);

    return imageElement;
  }

  @override
  void rositaPaint() {
    final image = target.rositaImageProvider;

    if (image is NetworkImage) {
      imageElement.style.opacity = '${target.opacity}';
      imageElement.src = image.url;
    }
  }
}

mixin RositaImageProviderProxyMixin {
  ImageProvider? get rositaImageProvider;
}
