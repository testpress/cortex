/// Semantic spacing tokens for consistent layout.
///
/// These values form a harmonious scale based on multiples of 4.
/// Using a consistent spacing system ensures visual rhythm and
/// makes the UI feel cohesive across all screens.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Common use cases
  static const double cardPadding = md;
  static const double screenPadding = lg;
  static const double sectionGap = xl;
  static const double itemGap = md;
}
