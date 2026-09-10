import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.heroGradientStart,
    required this.heroGradientEnd,
  });

  final Color heroGradientStart;
  final Color heroGradientEnd;

  @override
  AppColors copyWith({Color? heroGradientStart, Color? heroGradientEnd}) {
    return AppColors(
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      heroGradientStart: Color.lerp(
        heroGradientStart,
        other.heroGradientStart,
        t,
      )!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
    );
  }

  static const light = AppColors(
    heroGradientStart: Color(0xFFA8D8EA),
    heroGradientEnd: Color(0xFF3D5AF1),
  );

  static const dark = AppColors(
    heroGradientStart: Color(0xFF1E3A8A),
    heroGradientEnd: Color(0xFF0F172A),
  );
}
