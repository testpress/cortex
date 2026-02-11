import 'dart:ui';
import 'package:flutter/widgets.dart';

/// Runtime design configuration.
///
/// Immutable configuration object holding all design tokens. This becomes
/// the single source of truth for colors, spacing, typography, motion, and
/// radius values throughout the application.
///
/// Why this exists:
/// Static token classes (AppColors, AppSpacing, etc.) prevent runtime
/// customization needed for white-label branding and AI-adaptive UX.
/// This runtime layer enables design governance without coupling to
/// Material or Cupertino themes.
@immutable
class DesignConfig {
  const DesignConfig({
    required this.colors,
    required this.spacing,
    required this.typography,
    required this.motion,
    required this.radius,
  });

  final DesignColors colors;
  final DesignSpacing spacing;
  final DesignTypography typography;
  final DesignMotion motion;
  final DesignRadius radius;

  /// Default configuration matching current static tokens.
  ///
  /// This factory ensures zero visual changes during migration.
  /// Future work can introduce custom configs for branding.
  factory DesignConfig.defaults({BuildContext? context}) {
    return DesignConfig(
      colors: DesignColors.defaults(),
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(),
      motion: DesignMotion.defaults(context: context),
      radius: DesignRadius.defaults(),
    );
  }

  DesignConfig copyWith({
    DesignColors? colors,
    DesignSpacing? spacing,
    DesignTypography? typography,
    DesignMotion? motion,
    DesignRadius? radius,
  }) {
    return DesignConfig(
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      radius: radius ?? this.radius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignConfig &&
        other.colors == colors &&
        other.spacing == spacing &&
        other.typography == typography &&
        other.motion == motion &&
        other.radius == radius;
  }

  @override
  int get hashCode {
    return Object.hash(colors, spacing, typography, motion, radius);
  }
}

/// Color token group.
///
/// Mirrors AppColors structure for seamless migration.
@immutable
class DesignColors {
  const DesignColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.border,
    required this.divider,
    required this.success,
    required this.onSuccess,
    required this.error,
    required this.onError,
    required this.warning,
    required this.onWarning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.progressBackground,
    required this.progressForeground,
  });

  // Primary brand colors
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  // Surface colors
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;

  // Border and divider
  final Color border;
  final Color divider;

  // Semantic colors
  final Color success;
  final Color onSuccess;
  final Color error;
  final Color onError;
  final Color warning;
  final Color onWarning;

  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;

  // Progress indicator
  final Color progressBackground;
  final Color progressForeground;

  factory DesignColors.defaults() {
    return const DesignColors(
      primary: Color(0xFF6366F1),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF1E1B4B),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1F2937),
      surfaceVariant: Color(0xFFF9FAFB),
      onSurfaceVariant: Color(0xFF6B7280),
      border: Color(0xFFE5E7EB),
      divider: Color(0xFFF3F4F6),
      success: Color(0xFF10B981),
      onSuccess: Color(0xFFFFFFFF),
      error: Color(0xFFEF4444),
      onError: Color(0xFFFFFFFF),
      warning: Color(0xFFF59E0B),
      onWarning: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF111827),
      textSecondary: Color(0xFF6B7280),
      textTertiary: Color(0xFF9CA3AF),
      textInverse: Color(0xFFFFFFFF),
      progressBackground: Color(0xFFE5E7EB),
      progressForeground: Color(0xFF6366F1),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignColors &&
        other.primary == primary &&
        other.onPrimary == onPrimary &&
        other.primaryContainer == primaryContainer &&
        other.onPrimaryContainer == onPrimaryContainer &&
        other.surface == surface &&
        other.onSurface == onSurface &&
        other.surfaceVariant == surfaceVariant &&
        other.onSurfaceVariant == onSurfaceVariant &&
        other.border == border &&
        other.divider == divider &&
        other.success == success &&
        other.onSuccess == onSuccess &&
        other.error == error &&
        other.onError == onError &&
        other.warning == warning &&
        other.onWarning == onWarning &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary &&
        other.textTertiary == textTertiary &&
        other.textInverse == textInverse &&
        other.progressBackground == progressBackground &&
        other.progressForeground == progressForeground;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      primary,
      onPrimary,
      primaryContainer,
      onPrimaryContainer,
      surface,
      onSurface,
      surfaceVariant,
      onSurfaceVariant,
      border,
      divider,
      success,
      onSuccess,
      error,
      onError,
      warning,
      onWarning,
      textPrimary,
      textSecondary,
      textTertiary,
      textInverse,
      progressBackground,
      progressForeground,
    ]);
  }
}

/// Spacing token group.
///
/// Mirrors AppSpacing structure for seamless migration.
@immutable
class DesignSpacing {
  const DesignSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.cardPadding,
    required this.screenPadding,
    required this.sectionGap,
    required this.itemGap,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  // Common use cases
  final double cardPadding;
  final double screenPadding;
  final double sectionGap;
  final double itemGap;

  factory DesignSpacing.defaults() {
    return const DesignSpacing(
      xs: 4.0,
      sm: 8.0,
      md: 16.0,
      lg: 24.0,
      xl: 32.0,
      xxl: 48.0,
      xxxl: 64.0,
      cardPadding: 16.0,
      screenPadding: 24.0,
      sectionGap: 32.0,
      itemGap: 16.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignSpacing &&
        other.xs == xs &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl &&
        other.xxl == xxl &&
        other.xxxl == xxxl &&
        other.cardPadding == cardPadding &&
        other.screenPadding == screenPadding &&
        other.sectionGap == sectionGap &&
        other.itemGap == itemGap;
  }

  @override
  int get hashCode {
    return Object.hash(
      xs,
      sm,
      md,
      lg,
      xl,
      xxl,
      Object.hash(xxxl, cardPadding, screenPadding, sectionGap, itemGap),
    );
  }
}

/// Typography token group.
///
/// Mirrors AppTypography structure for seamless migration.
@immutable
class DesignTypography {
  const DesignTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.labelSmall,
    required this.caption,
  });

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle labelSmall;
  final TextStyle caption;

  factory DesignTypography.defaults() {
    return const DesignTypography(
      display: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      headline: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      title: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
      subtitle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      body: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      label: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignTypography &&
        other.display == display &&
        other.headline == headline &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.body == body &&
        other.bodySmall == bodySmall &&
        other.label == label &&
        other.labelSmall == labelSmall &&
        other.caption == caption;
  }

  @override
  int get hashCode {
    return Object.hash(
      display,
      headline,
      title,
      subtitle,
      body,
      bodySmall,
      Object.hash(label, labelSmall, caption),
    );
  }
}

/// Motion token group.
///
/// Mirrors AppMotion structure plus accessibility-aware shouldAnimate flag.
@immutable
class DesignMotion {
  const DesignMotion({
    required this.shouldAnimate,
    required this.fast,
    required this.normal,
    required this.slow,
    required this.verySlow,
    required this.easeIn,
    required this.easeOut,
    required this.easeInOut,
    required this.emphasized,
    required this.spring,
  });

  /// Whether animations should be enabled.
  ///
  /// Computed from MediaQuery.disableAnimations at provider initialization.
  /// MotionPreferences will read this instead of querying MediaQuery directly.
  final bool shouldAnimate;

  // Durations
  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Duration verySlow;

  // Curves
  final Curve easeIn;
  final Curve easeOut;
  final Curve easeInOut;
  final Curve emphasized;
  final Curve spring;

  factory DesignMotion.defaults({BuildContext? context}) {
    final shouldAnimate = context == null
        ? true
        : !MediaQuery.disableAnimationsOf(context);

    return DesignMotion(
      shouldAnimate: shouldAnimate,
      fast: const Duration(milliseconds: 150),
      normal: const Duration(milliseconds: 250),
      slow: const Duration(milliseconds: 400),
      verySlow: const Duration(milliseconds: 600),
      easeIn: Curves.easeIn,
      easeOut: Curves.easeOut,
      easeInOut: Curves.easeInOut,
      emphasized: Curves.easeInOutCubic,
      spring: Curves.easeOutCubic,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignMotion &&
        other.shouldAnimate == shouldAnimate &&
        other.fast == fast &&
        other.normal == normal &&
        other.slow == slow &&
        other.verySlow == verySlow &&
        other.easeIn == easeIn &&
        other.easeOut == easeOut &&
        other.easeInOut == easeInOut &&
        other.emphasized == emphasized &&
        other.spring == spring;
  }

  @override
  int get hashCode {
    return Object.hash(
      shouldAnimate,
      fast,
      normal,
      slow,
      verySlow,
      easeIn,
      Object.hash(easeOut, easeInOut, emphasized, spring),
    );
  }
}

/// Radius token group.
///
/// Mirrors AppRadius structure for seamless migration.
@immutable
class DesignRadius {
  const DesignRadius({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.full,
    required this.button,
    required this.card,
    required this.dialog,
    required this.pill,
  });

  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double full;

  // Common use cases
  final BorderRadius button;
  final BorderRadius card;
  final BorderRadius dialog;
  final BorderRadius pill;

  factory DesignRadius.defaults() {
    return const DesignRadius(
      none: 0.0,
      sm: 4.0,
      md: 8.0,
      lg: 12.0,
      xl: 16.0,
      xxl: 24.0,
      full: 9999.0,
      button: BorderRadius.all(Radius.circular(8.0)),
      card: BorderRadius.all(Radius.circular(12.0)),
      dialog: BorderRadius.all(Radius.circular(16.0)),
      pill: BorderRadius.all(Radius.circular(9999.0)),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignRadius &&
        other.none == none &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl &&
        other.xxl == xxl &&
        other.full == full &&
        other.button == button &&
        other.card == card &&
        other.dialog == dialog &&
        other.pill == pill;
  }

  @override
  int get hashCode {
    return Object.hash(
      none,
      sm,
      md,
      lg,
      xl,
      xxl,
      Object.hash(full, button, card, dialog, pill),
    );
  }
}
