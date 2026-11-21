import 'package:material_ui/material_ui.dart';

// Cùng bảng màu với web/style.css.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final accent = dark ? const Color(0xFF7FA0FF) : const Color(0xFF3B5BFD);
  final bg = dark ? const Color(0xFF14161A) : Colors.white;
  final fg = dark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
  final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: brightness).copyWith(
    primary: accent,
    surface: bg,
    onSurface: fg,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    appBarTheme: AppBarTheme(backgroundColor: bg, foregroundColor: fg, scrolledUnderElevation: 1),
    dividerTheme: DividerThemeData(color: dark ? const Color(0xFF2A2D33) : const Color(0xFFE2E2E2), space: 1),
  );
}

/// Màu tô đoạn đang được đọc to.
Color highlightColor(BuildContext context) =>
    Theme.of(context).colorScheme.primary.withValues(alpha: 0.14);

Color mutedColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? const Color(0xFF9A9A9A) : const Color(0xFF666666);
