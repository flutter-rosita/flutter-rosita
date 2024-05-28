// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:web/web.dart' as web;

mixin RositaRenderImageMixin on RositaRenderMixin, RositaImageProviderProxyMixin {
  @override
  RenderImage get target => this as RenderImage;

  web.HTMLImageElement get imageElement => htmlElement as web.HTMLImageElement;

  @override
  web.HTMLElement? createRositaElement() => web.HTMLImageElement();

  String? _blobUrl;

  @override
  void rositaDetach() {
    if (_blobUrl != null) {
      RositaImageUtils.revokeBlobObjectUrl(_blobUrl!);
      _blobUrl = null;
    }
  }

  @override
  void rositaPaint() {
    final style = htmlElement.style;
    final target = this.target;
    final image = target.rositaImageProvider;
    final imageData = target.image;

    if (image != null) {
      if (image is MemoryImage) {
        RositaImageUtils.buildMemoryImageBlobPath(image).then((value) {
          if (value != null) {
            imageElement.src = _blobUrl = value;
          }
        });
      } else {
        imageElement.src = _blobUrl = RositaImageUtils.buildImageProviderPath(image);
      }
    } else if (imageData != null) {
      RositaImageUtils.buildImageBlobPath(imageData).then((value) {
        if (value != null) {
          imageElement.src = _blobUrl = value;
        }
      });
    }

    RositaOpacityUtils.applyOpacity(style, target.opacity?.value);
  }
}

mixin RositaImageProviderProxyMixin {
  ImageProvider? get rositaImageProvider;
}
