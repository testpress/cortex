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
    // TODO: Implement WCAG contrast ratio calculation
    // For now, just return true to avoid breaking builds
    return true;
  }

  /// Checks if animations should be disabled based on user preferences.
  ///
  /// Use this in development to ensure motion preferences are respected.
  static bool shouldDisableAnimations(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }
}
