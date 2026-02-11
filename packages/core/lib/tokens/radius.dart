import 'package:flutter/widgets.dart';

/// Border radius tokens for consistent corner rounding.
///
/// These values create a cohesive visual language for rounded corners.
/// Smaller radii for compact elements, larger for prominent surfaces.
class AppRadius {
  AppRadius._();

  static const double none = 0.0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 9999.0; // Fully rounded (pill shape)

  // Common use cases
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}
