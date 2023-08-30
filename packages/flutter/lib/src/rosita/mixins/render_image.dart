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

    htmlElement.append(imageElement);

    return imageElement;
  }

  @override
  void rositaPaint() {
    final style = htmlElement.style;
    final target = this.target;
    final image = target.rositaImageProvider;
    final imageData = target.image;

    if (image != null) {
      imageElement.src = RositaImageUtils.buildImageProviderPath(image);
    } else if (imageData != null) {
      RositaImageUtils.buildImageBlobPath(imageData).then((value) {
        if (value != null) {
          imageElement.src = value;
        }
      });
    }

    RositaOpacityUtils.applyOpacity(style, target.opacity?.value);
  }
}

mixin RositaImageProviderProxyMixin {
  ImageProvider? get rositaImageProvider;
}
