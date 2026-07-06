import 'package:flutter/material.dart';

class Tcolor {
  // ── Dark backgrounds ──────────────────────────────────────────────────────
  static Color get background => const Color(0xFF0D1B2A);
  static Color get cardDark => const Color(0xFF1A2E3B);

  // ── Primary teal ──────────────────────────────────────────────────────────
  static Color get primary => const Color(0xFF027476);
  static Color get primaryLight => const Color(0xFF00BFA5);

  // Keep old spelling for backward compat
  static Color get primartLight => const Color(0xFF00BFA5);

  // ── Gold accent ───────────────────────────────────────────────────────────
  static Color get accent => const Color(0xFFF5A623);

  // ── Text ──────────────────────────────────────────────────────────────────
  static Color get textLight => const Color(0xFFE8F4F8);
  static Color get textMuted => const Color(0xFF8BA3B0);
  static Color get text => const Color(0xFFE8F4F8);
  static Color get subTitle => const Color(0xFF8BA3B0);

  // ── Input fields ──────────────────────────────────────────────────────────
  static Color get textBox => Colors.white.withValues(alpha: 0.08);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static List<Color> get primaryGradient => [
        const Color(0xFF027476),
        const Color(0xFF00BFA5),
      ];

  static List<Color> get backgroundGradient => [
        const Color(0xFF0D1B2A),
        const Color(0xFF0A3D4A),
      ];

  static List<Color> get button => [
        const Color(0xFF027476),
        const Color(0xFF00BFA5),
      ];

  static List<Color> get list => [
        const Color(0xFF027476),
        const Color(0xFF00BFA5),
        const Color(0xFF1A2E3B),
        const Color(0xFF1A2E3B),
        const Color(0xFF1A2E3B),
      ];
}
