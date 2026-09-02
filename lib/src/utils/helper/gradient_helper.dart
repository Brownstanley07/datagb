import 'dart:math';
import 'package:flutter/material.dart';

class GradientHelper {
  static const List<Color> _palette = [
    // 🔵 Blues
    Color(0xFF3B82F6),
    Color(0xFF2563EB),
    Color(0xFF0EA5E9),
    Color(0xFF38BDF8),
    Color(0xFF1D4ED8),

    // 🟣 Purples
    Color(0xFFA855F7),
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
    Color(0xFFC084FC),
    Color(0xFF6D28D9),

    // 🟠 Warm Oranges / peach
    Color(0xFFFF8A4C),
    Color(0xFFFF6B6B),
    Color(0xFFFFB76B),
    Color(0xFFFF9F43),
    Color(0xFFFF7F50),

    // 🟡 Gold / Yellow Vibrants
    Color(0xFFFACC15),
    Color(0xFFFBBF24),
    Color(0xFFFFD93D),
    Color(0xFFFFC62A),
    Color(0xFFF5CD79),

    // 🟢 Greens / Emerald
    Color(0xFF10B981),
    Color(0xFF34D399),
    Color(0xFF2BD47D),
    Color(0xFF16A34A),
    Color(0xFF22C55E),

    // 🔥 Red / Pink / Rose
    Color(0xFFEF4444),
    Color(0xFFF43F5E),
    Color(0xFFFB7185),
    Color(0xFFE11D48),
    Color(0xFFD946EF),

    // 🌊 Aqua / Cyan / Teal
    Color(0xFF06B6D4),
    Color(0xFF14B8A6),
    Color(0xFF2DD4BF),
    Color(0xFF0D9488),
    Color(0xFF67E8F9),
  ];

  static List<Color> gradientFromString(String? seed, {bool reversed = false}) {
    if (seed == null || seed.isEmpty) {
      return _randomGradient();
    }

    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = (hash * 31 + seed.codeUnitAt(i)) & 0x7fffffff;
    }

    final idx1 = hash % _palette.length;
    final idx2 = (hash ~/ _palette.length + idx1 + 3) % _palette.length;

    final color1 = _palette[idx1];
    final color2 = _palette[idx2];

    return reversed ? [color2, color1] : [color1, color2];
  }

  static List<Color> _randomGradient() {
    final rand = Random();
    final idx1 = rand.nextInt(_palette.length);
    int idx2 = rand.nextInt(_palette.length);
    while (idx2 == idx1) {
      idx2 = rand.nextInt(_palette.length);
    }
    return [_palette[idx1], _palette[idx2]];
  }
}

final List<Color> kycTileColors = [
  const Color(0xFFEFF4FF),
  const Color(0xFFFFF6DE),
  const Color(0xFFFFE8E8),
  const Color(0xFFE9FFE8),
  const Color(0xFFE8F7FF),
];
