import 'package:flutter/material.dart';
import 'package:rosita/rosita.dart';

class RositaFadeImage extends StatefulWidget {
  const RositaFadeImage.asset(
    String name, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    required this.fadeInDuration,
    required this.fadeInCurve,
    String? package,
  }) : src = package == null ? 'assets/$name' : 'assets/packages/$package/$name';

  const RositaFadeImage.network(
    String url, {
    super.key,
    this.borderRadius,
    this.fit,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    required this.fadeInDuration,
    required this.fadeInCurve,
  }) : src = url;

  final String src;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final Widget? errorWidget;
  final Widget? placeholder;

  @override
  State<RositaFadeImage> createState() => _RositaFadeImageState();
}

class _RositaFadeImageState extends State<RositaFadeImage> {
  bool _isLoaded = false;
  bool _hasError = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _initImage(widget.src);
  }

  @override
  void didUpdateWidget(RositaFadeImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.src != widget.src) {
      _initImage(widget.src);
    }
  }

  void _initImage(String src) {
    final complete = RositaImageUtils.imageIsComplete(src);

    _hasError = false;

    if (complete) {
      _isLoaded = true;
      _isCompleted = true;
    } else {
      _isLoaded = false;
      _isCompleted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorWidget = widget.errorWidget;
    final placeholder = widget.placeholder;

    final hasPlaceholder = errorWidget != null || placeholder != null;

    final image = RositaImage.network(
      widget.src,
      borderRadius: widget.borderRadius,
      fit: widget.fit,
      alignment: widget.alignment,
      onLoad: hasPlaceholder
          ? () {
              _isCompleted = true;
              setState(() {});
            }
          : null,
      onError: hasPlaceholder
          ? () {
              _isCompleted = true;
              _hasError = true;
              setState(() {});
            }
          : null,
    );

    if (_isLoaded && !_hasError || !hasPlaceholder) {
      return image;
    }

    final child = _fade(
      _hasError ? (errorWidget ?? const SizedBox.shrink()) : image,
      _isCompleted,
    );

    if (placeholder == null) {
      return child;
    }

    return _stack(placeholder, child);
  }

  Widget _stack(Widget placeholder, Widget image) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        placeholder,
        image,
      ],
    );
  }

  Widget _fade(Widget image, bool visible) {
    return RositaAnimatedOpacity(
      opacity: visible ? 1.0 : 0,
      duration: widget.fadeInDuration,
      curve: widget.fadeInCurve,
      child: image,
      onEnd: () {
        _isLoaded = true;
        setState(() {});
      },
    );
  }
}
