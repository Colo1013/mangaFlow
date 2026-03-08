import 'package:flutter/material.dart';
import 'dart:ui';

class AppSizeExtension extends ThemeExtension<AppSizeExtension> {
  final double small;
  final double medium;
  final double big;
  final double smallradius;
  final double bigradius;

  const AppSizeExtension({
    required this.small,
    required this.medium,
    required this.big,
    required this.smallradius,
    required this.bigradius,
  });

  @override
  copyWith({
    double? small,
    double? medium,
    double? big,
    double? smallradius,
    double? bigradius,
  }) {
    return AppSizeExtension(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      big: big ?? this.big,
      smallradius: smallradius ?? this.smallradius,
      bigradius: bigradius ?? this.bigradius,
    );
  }

  @override
  AppSizeExtension lerp(ThemeExtension<AppSizeExtension>? other, double t) {
    if (other is! AppSizeExtension) {
      return this;
    }
    return AppSizeExtension(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      big: lerpDouble(big, other.big, t)!,
      smallradius: lerpDouble(smallradius, other.smallradius, t)!,
      bigradius: lerpDouble(bigradius, other.bigradius, t)!,
    );
  }
}
