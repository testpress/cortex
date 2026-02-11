import 'dart:ui';

/// Semantic color tokens for platform-neutral design.
///
/// These colors are intentionally not Material or Cupertino-specific.
/// They define a neutral palette that works identically across platforms.
class AppColors {
  AppColors._();

  // Primary brand colors
  static const primary = Color(0xFF6366F1); // Indigo
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFE0E7FF);
  static const onPrimaryContainer = Color(0xFF1E1B4B);

  // Surface colors
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1F2937);
  static const surfaceVariant = Color(0xFFF9FAFB);
  static const onSurfaceVariant = Color(0xFF6B7280);

  // Border and divider
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);

  // Semantic colors
  static const success = Color(0xFF10B981);
  static const onSuccess = Color(0xFFFFFFFF);
  static const error = Color(0xFFEF4444);
  static const onError = Color(0xFFFFFFFF);
  static const warning = Color(0xFFF59E0B);
  static const onWarning = Color(0xFFFFFFFF);

  // Text colors
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textInverse = Color(0xFFFFFFFF);

  // Progress indicator
  static const progressBackground = Color(0xFFE5E7EB);
  static const progressForeground = Color(0xFF6366F1);
}
