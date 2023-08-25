// ignore_for_file: public_member_api_docs, always_specify_types

import 'package:flutter/rendering.dart';
import 'package:flutter/rosita.dart';
import 'package:universal_html/html.dart' as html;

mixin RositaRenderDecoratedBoxMixin on RositaRenderMixin {
  @override
  RenderDecoratedBox get target => this as RenderDecoratedBox;

  html.HtmlElement? _foregroundHtmlElement;

  html.HtmlElement get foregroundHtmlElement {
    if (_foregroundHtmlElement != null) {
      return _foregroundHtmlElement!;
    }

    final foregroundHtmlElement = html.DivElement();

    foregroundHtmlElement.style
      ..width = '100%'
      ..height = '100%'
      ..left = '0px'
      ..top = '0px';

    _foregroundHtmlElement = foregroundHtmlElement;

    htmlElement.append(foregroundHtmlElement);

    return foregroundHtmlElement;
  }

  @override
  void rositaDetach() {
    _foregroundHtmlElement?.remove();
    _foregroundHtmlElement = null;
    super.rositaDetach();
  }

  @override
  void rositaPaint() {
    final decoration = target.decoration;
    final html.HtmlElement targetHtmlElement = switch (target.position) {
      DecorationPosition.background => htmlElement,
      DecorationPosition.foreground => foregroundHtmlElement,
    };

    if (decoration is BoxDecoration) {
      targetHtmlElement.style.background = decoration.color.toStyleString();

      if (decoration.borderRadius != null) {
        RositaRadiusUtils.applyBorderRadius(targetHtmlElement, decoration.borderRadius);
      } else {
        targetHtmlElement.style.borderRadius = decoration.shape == BoxShape.circle ? '100%' : '';
      }

      final image = decoration.image;

      if (image != null) {
        targetHtmlElement.style.backgroundImage = 'url(${RositaImageUtils.buildImageProviderPath(image.image)})';
        RositaBoxFitUtils.applyBoxFitToBackgroundSize(targetHtmlElement, image.fit);
        RositaBoxFitUtils.applyAlignmentToBackgroundPosition(targetHtmlElement, image.alignment);
      }

      final border = decoration.border;

      if (border != null) {
        RositaBorderUtils.applyBorderStyle(targetHtmlElement, border);
      }
    }
  }
}
