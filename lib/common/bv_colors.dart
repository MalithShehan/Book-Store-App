import 'package:flutter/material.dart';

class BVColors {
  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF141E35);
  static const Color surfaceElevated = Color(0xFF1A2545);
  static const Color cardDark = Color(0xFF111827);

  // ── Primary: Electric Violet ──────────────────────────────────────────────
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryLight = Color(0xFFB388FF);
  static const Color primaryDark = Color(0xFF512DA8);
  static const Color primaryGlow = Color(0x337C4DFF);

  // ── Secondary: Cyan Glow ──────────────────────────────────────────────────
  static const Color secondary = Color(0xFF00E5FF);
  static const Color secondaryLight = Color(0xFF80EEFF);
  static const Color secondaryDark = Color(0xFF00B2C6);
  static const Color secondaryGlow = Color(0x3300E5FF);

  // ── Accent: Gold ──────────────────────────────────────────────────────────
  static const Color gold = Color(0xFFFFD740);
  static const Color goldDark = Color(0xFFFFAB00);

  // ── Status Colors ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF69F0AE);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFD740);
  static const Color info = Color(0xFF40C4FF);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textMuted = Color(0xFF5A6A8A);
  static const Color textDisabled = Color(0xFF374151);

  // ── Glass / Overlay ───────────────────────────────────────────────────────
  static Color glass = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);
  static Color glassStrong = Colors.white.withValues(alpha: 0.10);
  static Color overlay = Colors.black.withValues(alpha: 0.60);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF00B2C6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD740), Color(0xFFFFAB00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF141E35)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient scrimGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xFF0A0E1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Category Colors ───────────────────────────────────────────────────────
  static const List<Color> categoryColors = [
    Color(0xFF7C4DFF),
    Color(0xFF00E5FF),
    Color(0xFFFF6B6B),
    Color(0xFF69F0AE),
    Color(0xFFFFD740),
    Color(0xFFFF80AB),
    Color(0xFF40C4FF),
    Color(0xFFFFAB40),
  ];
}
