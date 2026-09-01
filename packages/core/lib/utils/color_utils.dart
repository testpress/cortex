import 'dart:ui';

/// Utility methods for parsing and manipulating colors.
class ColorUtils {
  ColorUtils._();

  /// Parses a hex color string into a Flutter [Color].
  ///
  /// Supports formats like:
  /// - `#RGB` or `RGB`
  /// - `#RRGGBB` or `RRGGBB`
  /// - `#AARRGGBB` or `AARRGGBB`
  ///
  /// Returns [defaultColor] if string is null, empty, or cannot be parsed.
  static Color parseHexColor(
    String? hexColor, {
    Color defaultColor = const Color(0xFF6B7280),
  }) {
    if (hexColor == null) return defaultColor;

    var hex = hexColor.replaceAll('#', '').trim();
    if (hex.isEmpty) return defaultColor;

    // Support 3-character shorthand RGB -> RRGGBB
    if (hex.length == 3) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    }

    // Support 6-character RRGGBB -> FFRRGGBB
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length != 8) return defaultColor;

    final val = int.tryParse(hex, radix: 16);
    if (val == null) return defaultColor;

    return Color(val);
  }
}
