import 'dart:ui';

abstract class RositaImageFilter implements ImageFilter {
  factory RositaImageFilter.blur(double radius) => RositaBlurImageFilter(radius);
}

class RositaBlurImageFilter implements RositaImageFilter {
  RositaBlurImageFilter(this.radius);

  final double radius;

  @override
  String toString() => 'RositaImageFilter.blur($radius)';

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RositaBlurImageFilter && other.radius == radius;
  }

  @override
  int get hashCode => radius.hashCode;
}
