part of '../web_rendering.dart';

class RenderRositaImage extends RositaRenderBox {
  RenderRositaImage({
    String? src,
    BorderRadiusGeometry? borderRadius,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    VoidCallback? onLoad,
    VoidCallback? onError,
  })  : _src = src,
        _borderRadius = borderRadius,
        _fit = fit,
        _alignment = alignment,
        _onLoad = onLoad,
        _onError = onError;

  web.HTMLImageElement get imageElement => htmlElement as web.HTMLImageElement;

  @override
  web.HTMLElement? createRositaElement() {
    final imageElement = web.HTMLImageElement()
      ..loading = 'lazy'
      ..decoding = 'async';
    final style = imageElement.style;
    final src = this.src;

    imageElement.src = src ?? '';

    RositaRadiusUtils.applyBorderRadius(style, borderRadius);
    RositaBoxFitUtils.applyBoxFitToObjectFit(style, fit);
    RositaBoxFitUtils.applyAlignmentToObjectPosition(style, alignment);

    _setListenerOnLoad(imageElement, onLoad);
    _setListenerOnError(imageElement, onError);

    return imageElement;
  }

  String? get src => _src;
  String? _src;

  set src(String? value) {
    if (value == _src) {
      return;
    }
    _src = value;
    imageElement.src = value ?? '';
  }

  BorderRadiusGeometry? get borderRadius => _borderRadius;
  BorderRadiusGeometry? _borderRadius;

  set borderRadius(BorderRadiusGeometry? value) {
    if (value == _borderRadius) {
      return;
    }
    _borderRadius = value;
    RositaRadiusUtils.applyBorderRadius(imageElement.style, value);
  }

  BoxFit? get fit => _fit;
  BoxFit? _fit;

  set fit(BoxFit? value) {
    if (value == _fit) {
      return;
    }
    _fit = value;
    RositaBoxFitUtils.applyBoxFitToObjectFit(imageElement.style, value);
  }

  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;

  set alignment(AlignmentGeometry? value) {
    if (value == _alignment) {
      return;
    }
    _alignment = value;
    RositaBoxFitUtils.applyAlignmentToObjectPosition(imageElement.style, value);
  }

  VoidCallback? get onLoad => _onLoad;
  VoidCallback? _onLoad;

  set onLoad(VoidCallback? value) {
    if (identical(_onLoad, value)) {
      return;
    }
    _onLoad = value;

    _setListenerOnLoad(imageElement, value);
  }

  StreamSubscription? _onLoadStreamSubscription;

  void _setListenerOnLoad(web.HTMLImageElement imageElement, VoidCallback? callback) {
    if (callback == null) {
      _onLoadStreamSubscription?.cancel();
      _onLoadStreamSubscription = null;
    } else {
      _onLoadStreamSubscription ??= imageElement.onLoad.listen((event) {
        _onLoad?.call();
      });
    }
  }

  VoidCallback? get onError => _onError;
  VoidCallback? _onError;

  set onError(VoidCallback? value) {
    if (identical(_onError, value)) {
      return;
    }
    _onError = value;

    _setListenerOnError(imageElement, value);
  }

  StreamSubscription? _onErrorStreamSubscription;

  void _setListenerOnError(web.HTMLImageElement imageElement, VoidCallback? callback) {
    if (callback == null) {
      _onErrorStreamSubscription?.cancel();
      _onErrorStreamSubscription = null;
    } else {
      _onErrorStreamSubscription ??= imageElement.onError.listen((event) {
        _onError?.call();
      });
    }
  }

  @override
  void performLayout() {
    final biggestSize = constraints.biggest;

    size = biggestSize.isFinite
        ? biggestSize
        : Size(
            biggestSize.width == double.infinity ? biggestSize.height : biggestSize.width,
            biggestSize.height == double.infinity ? biggestSize.width : biggestSize.height,
          );
  }

  @override
  void rositaPaint() {}

  @override
  void rositaDetach() {
    _onLoadStreamSubscription?.cancel();
    _onLoadStreamSubscription = null;

    _onErrorStreamSubscription?.cancel();
    _onErrorStreamSubscription = null;
  }
}
