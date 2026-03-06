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
      small: lerpDouble(this.small, other.small, t)!,
      medium: lerpDouble(this.medium, other.medium, t)!,
      big: lerpDouble(this.big, other.big, t)!,
      smallradius: lerpDouble(this.smallradius, other.smallradius, t)!,
      bigradius: lerpDouble(this.bigradius, other.bigradius, t)!,
    );
  }
}
