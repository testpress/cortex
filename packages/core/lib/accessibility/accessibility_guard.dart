import 'dart:math';
import 'package:flutter/widgets.dart';

/// Runtime accessibility validation helpers.
///
/// Use these guards during development to catch accessibility violations early.
/// These are NOT replacements for proper testing, but help catch obvious issues.
class AccessibilityGuard {
  AccessibilityGuard._();

  /// Validates that a tap target meets minimum size requirements.
  ///
  /// WCAG recommends 44×44dp, but Android/iOS use 48dp as standard.
  /// This guard warns if a target is too small.
  ///
  /// Returns true if valid, false otherwise.
  static bool validateTapTargetSize(Size size, {double minSize = 48.0}) {
    final isValid = size.width >= minSize && size.height >= minSize;

    if (!isValid) {
      debugPrint(
        'AccessibilityGuard: Tap target too small! '
        'Size: ${size.width}×${size.height}, '
        'Minimum: $minSize×$minSize',
      );
    }

    return isValid;
  }

  /// Validates that text has sufficient contrast ratio.
  ///
  /// This is a placeholder for future contrast checking.
  /// Actual implementation would require color luminance calculations.
  static bool validateContrast(Color foreground, Color background) {
    final l1 = _luminance(foreground);
    final l2 = _luminance(background);

    final ratio = (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);

    // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
    final isValid = ratio >= 4.5;

    if (!isValid) {
      debugPrint(
        'AccessibilityGuard: Insufficient contrast ratio! '
        'Ratio: ${ratio.toStringAsFixed(2)}:1, '
        'Minimum requirement: 4.5:1',
      );
    }

    return isValid;
  }

  /// Calculate relative luminance (WCAG formula)
  static double _luminance(Color color) {
    // Ported from DesignColors
    double r = color.r;
    double g = color.g;
    double b = color.b;

    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Checks if animations should be disabled based on user preferences.
  ///
  /// Use this in development to ensure motion preferences are respected.
  static bool shouldDisableAnimations(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }
}
