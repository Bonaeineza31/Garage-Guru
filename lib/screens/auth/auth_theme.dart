import 'package:flutter/material.dart';

/// Colors and type tuned to the GarageGuru auth Figma frames (does not alter app-wide theme).
class AuthTheme {
  AuthTheme._();

  static const Color primary = Color(0xFF4DA8DA);
  static Color getHeaderTint(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0F172A) : const Color(0xFFE3F2FA);
  }
  static const Color fieldBorder = Color(0xFFE2E8F0);
  static const Color subtitle = Color(0xFF64748B);
  static const Color link = Color(0xFF4DA8DA);

  static const double fieldRadius = 8;

  static TextStyle title(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: -0.3,
        );
  }

  static TextStyle subtitleStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: isDark ? Colors.white70 : subtitle,
          height: 1.45,
          fontSize: 14,
        );
  }
}
