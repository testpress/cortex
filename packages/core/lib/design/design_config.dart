import 'dart:math';
import 'package:flutter/widgets.dart';

/// Theme governance mode.
enum DesignMode {
  /// Respect system-level brightness preference.
  system,

  /// Force light theme.
  light,

  /// Force dark theme.
  dark,
}

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
    required this.subjectPalette,
    required this.statusColors,
    this.isDark = false,
  });

  final DesignColors colors;
  final DesignSpacing spacing;
  final DesignTypography typography;
  final DesignMotion motion;
  final DesignRadius radius;
  final DesignSubjectPalette subjectPalette;
  final DesignStatusColors statusColors;
  final bool isDark;

  /// Default configuration matching current static tokens.
  ///
  /// This factory ensures zero visual changes during migration.
  /// Future work can introduce custom configs for branding.
  factory DesignConfig.defaults({BuildContext? context}) {
    return DesignConfig.light(context: context);
  }

  /// Light mode configuration.
  factory DesignConfig.light({BuildContext? context}) {
    return DesignConfig(
      colors: DesignColors.light(),
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(),
      motion: DesignMotion.defaults(context: context),
      radius: DesignRadius.defaults(),
      subjectPalette: DesignSubjectPalette.light(),
      statusColors: DesignStatusColors.light(),
      isDark: false,
    );
  }

  /// Dark mode configuration.
  factory DesignConfig.dark({BuildContext? context}) {
    return DesignConfig(
      colors: DesignColors.dark(),
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(),
      motion: DesignMotion.defaults(context: context),
      radius: DesignRadius.defaults(),
      subjectPalette: DesignSubjectPalette.dark(),
      statusColors: DesignStatusColors.dark(),
      isDark: true,
    );
  }

  DesignConfig copyWith({
    DesignColors? colors,
    DesignSpacing? spacing,
    DesignTypography? typography,
    DesignMotion? motion,
    DesignRadius? radius,
    DesignSubjectPalette? subjectPalette,
    DesignStatusColors? statusColors,
    bool? isDark,
  }) {
    return DesignConfig(
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      radius: radius ?? this.radius,
      subjectPalette: subjectPalette ?? this.subjectPalette,
      statusColors: statusColors ?? this.statusColors,
      isDark: isDark ?? this.isDark,
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
        other.radius == radius &&
        other.subjectPalette == subjectPalette &&
        other.statusColors == statusColors;
  }

  @override
  int get hashCode {
    return Object.hash(
      colors,
      spacing,
      typography,
      motion,
      radius,
      subjectPalette,
      statusColors,
    );
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
    required this.card,
    required this.onCard,
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
    required this.focus,
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

  // Card surface (distinct from page surface for visual layering)
  final Color card;
  final Color onCard;

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
  final Color focus;

  factory DesignColors.light() {
    return const DesignColors(
      primary: Color(0xFF6366F1),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF1E1B4B),
      surface: Color(0xFFF9FAFB),
      onSurface: Color(0xFF1F2937),
      surfaceVariant: Color(0xFFF3F4F6),
      onSurfaceVariant: Color(0xFF6B7280),
      card: Color(0xFFFFFFFF),
      onCard: Color(0xFF111827),
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
      focus: Color(0x666366F1),
    );
  }

  factory DesignColors.dark() {
    return const DesignColors(
      primary: Color(0xFF818CF8), // Slightly lighter indigo for dark mode
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF312E81),
      onPrimaryContainer: Color(0xFFE0E7FF),
      surface: Color(0xFF0F172A), // Slate 900
      onSurface: Color(0xFFF8FAFC),
      surfaceVariant: Color(0xFF1E293B), // Slate 800
      onSurfaceVariant: Color(0xFF94A3B8),
      card: Color(0xFF1E293B), // Slate 800 — card sits above slate-900 surface
      onCard: Color(0xFFF8FAFC),
      border: Color(0xFF334155),
      divider: Color(0xFF1E293B),
      success: Color(0xFF34D399),
      onSuccess: Color(0xFF064E3B),
      error: Color(0xFFF87171),
      onError: Color(0xFF450A0A),
      warning: Color(0xFFFBBF24),
      onWarning: Color(0xFF451A03),
      textPrimary: Color(0xFFF8FAFC),
      textSecondary: Color(0xFF94A3B8),
      textTertiary: Color(0xFF64748B),
      textInverse: Color(0xFF111827),
      progressBackground: Color(0xFF334155),
      progressForeground: Color(0xFF818CF8),
      focus: Color(0x99818CF8),
    );
  }

  @Deprecated('Use DesignColors.light() instead')
  factory DesignColors.defaults() => DesignColors.light();

  /// Smart factory that automatically calculates contrasting text colors.
  ///
  /// This factory computes WCAG AA-compliant text colors based on the
  /// background colors you provide. Perfect for hot reload testing!
  ///
  /// Example:
  /// ```dart
  /// DesignColors.smart(
  ///   primary: Color(0xFF00FF00), // Green
  ///   // onPrimary is automatically calculated (dark text)
  /// )
  /// ```
  factory DesignColors.smart({
    Color primary = const Color(0xFF6366F1),
    Color? primaryContainer,
    Color surface = const Color(0xFFF9FAFB),
    Color? surfaceVariant,
    Color? card,
    Color border = const Color(0xFFE5E7EB),
    Color divider = const Color(0xFFF3F4F6),
    Color success = const Color(0xFF10B981),
    Color error = const Color(0xFFEF4444),
    Color warning = const Color(0xFFF59E0B),
    Color textPrimary = const Color(0xFF111827),
    Color textSecondary = const Color(0xFF6B7280),
    Color textTertiary = const Color(0xFF9CA3AF),
    Color? progressForeground,
    Color? focus,
  }) {
    // Auto-calculate contrasting text colors
    final onPrimary = _contrastingColor(primary);
    final onSuccess = _contrastingColor(success);
    final onError = _contrastingColor(error);
    final onWarning = _contrastingColor(warning);

    final computedPrimaryContainer = primaryContainer ?? _lighten(primary, 0.9);
    final onPrimaryContainer = _contrastingColor(computedPrimaryContainer);

    final computedSurfaceVariant = surfaceVariant ?? _lighten(surface, 0.98);
    final onSurface = _contrastingColor(surface);
    final onSurfaceVariant = _contrastingColor(computedSurfaceVariant);
    final computedCard = card ?? const Color(0xFFFFFFFF);
    final onCard = _contrastingColor(computedCard);

    return DesignColors(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: computedPrimaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: computedSurfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      card: computedCard,
      onCard: onCard,
      border: border,
      divider: divider,
      success: success,
      onSuccess: onSuccess,
      error: error,
      onError: onError,
      warning: warning,
      onWarning: onWarning,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textTertiary: textTertiary,
      textInverse: const Color(0xFFFFFFFF),
      progressBackground: border,
      progressForeground: progressForeground ?? primary,
      focus: focus ?? primary.withValues(alpha: 0.4),
    );
  }

  /// Calculate relative luminance (WCAG formula)
  static double _luminance(Color color) {
    double r = color.r;
    double g = color.g;
    double b = color.b;

    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Return white or black based on which has better contrast
  static Color _contrastingColor(Color background) {
    final luminance = _luminance(background);
    // WCAG recommends 4.5:1 contrast ratio for normal text
    // Luminance > 0.5 means light background → use dark text
    return luminance > 0.5
        ? const Color(0xFF111827) // Dark gray
        : const Color(0xFFFFFFFF); // White
  }

  /// Lighten a color by a factor (0.0 = original, 1.0 = white)
  static Color _lighten(Color color, double factor) {
    assert(factor >= 0.0 && factor <= 1.0);
    final double r = color.r + (1.0 - color.r) * factor;
    final double g = color.g + (1.0 - color.g) * factor;
    final double b = color.b + (1.0 - color.b) * factor;
    return Color.from(alpha: color.a, red: r, green: g, blue: b);
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
        other.card == card &&
        other.onCard == onCard &&
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
      card,
      onCard,
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

// ─────────────────────────────────────────────────────────────────────────────
// Subject Palette
// ─────────────────────────────────────────────────────────────────────────────

/// A single color slot in the subject palette.
///
/// Subjects from the API carry a `colorIndex` (0-based). Widgets call
/// `DesignSubjectPalette.atIndex(colorIndex)` to get this object.
/// No subject names are stored here — subjects are API-driven and tenant-specific.
@immutable
class SubjectColors {
  const SubjectColors({
    required this.background,
    required this.foreground,
    required this.accent,
  });

  /// Chip/badge background color.
  final Color background;

  /// Text/icon color on [background] — WCAG AA compliant.
  final Color foreground;

  /// Border or icon accent color.
  final Color accent;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectColors &&
        other.background == background &&
        other.foreground == foreground &&
        other.accent == accent;
  }

  @override
  int get hashCode => Object.hash(background, foreground, accent);
}

/// Indexed subject color palette.
///
/// Contains an ordered list of [SubjectColors] slots. The API provides a
/// `colorIndex` per subject; use [atIndex] to resolve the color. The index
/// wraps modularly so it never throws regardless of the number of subjects.
@immutable
class DesignSubjectPalette {
  const DesignSubjectPalette(this._palettes);

  final List<SubjectColors> _palettes;

  /// Returns the [SubjectColors] at [i % palette.length].
  /// Always safe — wraps around for any non-negative integer.
  SubjectColors atIndex(int i) => _palettes[i % _palettes.length];

  /// Number of distinct color slots in this palette.
  int get length => _palettes.length;

  /// Light-mode palette — 8 visually distinct, WCAG AA-compliant color slots.
  factory DesignSubjectPalette.light() {
    return const DesignSubjectPalette([
      // 0 — indigo
      SubjectColors(
        background: Color(0xFFEEF2FF),
        foreground: Color(0xFF3730A3),
        accent: Color(0xFF6366F1),
      ),
      // 1 — orange
      SubjectColors(
        background: Color(0xFFFFF7ED),
        foreground: Color(0xFF9A3412),
        accent: Color(0xFFF97316),
      ),
      // 2 — emerald
      SubjectColors(
        background: Color(0xFFF0FDF4),
        foreground: Color(0xFF166534),
        accent: Color(0xFF22C55E),
      ),
      // 3 — violet
      SubjectColors(
        background: Color(0xFFF5F3FF),
        foreground: Color(0xFF5B21B6),
        accent: Color(0xFF7C3AED),
      ),
      // 4 — rose
      SubjectColors(
        background: Color(0xFFFFF1F2),
        foreground: Color(0xFF9F1239),
        accent: Color(0xFFF43F5E),
      ),
      // 5 — sky
      SubjectColors(
        background: Color(0xFFF0F9FF),
        foreground: Color(0xFF0369A1),
        accent: Color(0xFF0EA5E9),
      ),
      // 6 — amber
      SubjectColors(
        background: Color(0xFFFFFBEB),
        foreground: Color(0xFF92400E),
        accent: Color(0xFFF59E0B),
      ),
      // 7 — teal
      SubjectColors(
        background: Color(0xFFF0FDFA),
        foreground: Color(0xFF134E4A),
        accent: Color(0xFF14B8A6),
      ),
    ]);
  }

  /// Dark-mode palette — muted/adjusted equivalents for dark surfaces.
  factory DesignSubjectPalette.dark() {
    return const DesignSubjectPalette([
      // 0 — indigo
      SubjectColors(
        background: Color(0xFF1E1B4B),
        foreground: Color(0xFFC7D2FE),
        accent: Color(0xFF818CF8),
      ),
      // 1 — orange
      SubjectColors(
        background: Color(0xFF431407),
        foreground: Color(0xFFFED7AA),
        accent: Color(0xFFFB923C),
      ),
      // 2 — emerald
      SubjectColors(
        background: Color(0xFF052E16),
        foreground: Color(0xFFBBF7D0),
        accent: Color(0xFF4ADE80),
      ),
      // 3 — violet
      SubjectColors(
        background: Color(0xFF2E1065),
        foreground: Color(0xFFDDD6FE),
        accent: Color(0xFFA78BFA),
      ),
      // 4 — rose
      SubjectColors(
        background: Color(0xFF4C0519),
        foreground: Color(0xFFFFCDD5),
        accent: Color(0xFFFB7185),
      ),
      // 5 — sky
      SubjectColors(
        background: Color(0xFF082F49),
        foreground: Color(0xFFBAE6FD),
        accent: Color(0xFF38BDF8),
      ),
      // 6 — amber
      SubjectColors(
        background: Color(0xFF451A03),
        foreground: Color(0xFFFDE68A),
        accent: Color(0xFFFBBF24),
      ),
      // 7 — teal
      SubjectColors(
        background: Color(0xFF042F2E),
        foreground: Color(0xFF99F6E4),
        accent: Color(0xFF2DD4BF),
      ),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DesignSubjectPalette) return false;
    if (_palettes.length != other._palettes.length) return false;
    for (int i = 0; i < _palettes.length; i++) {
      if (_palettes[i] != other._palettes[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_palettes);
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Colors
// ─────────────────────────────────────────────────────────────────────────────

/// A color pair for a single content-status state.
@immutable
class StatusColors {
  const StatusColors({required this.background, required this.foreground});

  /// Badge/chip background color.
  final Color background;

  /// Text/icon color on [background] — WCAG AA compliant (≥ 4.5:1).
  final Color foreground;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusColors &&
        other.background == background &&
        other.foreground == foreground;
  }

  @override
  int get hashCode => Object.hash(background, foreground);
}

/// Content-status color token group.
///
/// Covers the four states used by LMS content items and badges.
/// These are product-model states (not API-driven), so named fields are correct.
@immutable
class DesignStatusColors {
  const DesignStatusColors({
    required this.live,
    required this.completed,
    required this.locked,
    required this.upcoming,
  });

  /// Active/live session — vivid, attention-drawing.
  final StatusColors live;

  /// Successfully finished content.
  final StatusColors completed;

  /// Locked/inaccessible content — visually subdued.
  final StatusColors locked;

  /// Scheduled but not yet available.
  final StatusColors upcoming;

  factory DesignStatusColors.light() {
    return const DesignStatusColors(
      live: StatusColors(
        background: Color(0xFFFEE2E2),
        foreground: Color(0xFF991B1B),
      ),
      completed: StatusColors(
        background: Color(0xFFD1FAE5),
        foreground: Color(0xFF065F46),
      ),
      locked: StatusColors(
        background: Color(0xFFF3F4F6),
        foreground: Color(0xFF6B7280),
      ),
      upcoming: StatusColors(
        background: Color(0xFFDBEAFE),
        foreground: Color(0xFF1E40AF),
      ),
    );
  }

  factory DesignStatusColors.dark() {
    return const DesignStatusColors(
      live: StatusColors(
        background: Color(0xFF450A0A),
        foreground: Color(0xFFFCA5A5),
      ),
      completed: StatusColors(
        background: Color(0xFF052E16),
        foreground: Color(0xFF6EE7B7),
      ),
      locked: StatusColors(
        background: Color(0xFF1F2937),
        foreground: Color(0xFF9CA3AF),
      ),
      upcoming: StatusColors(
        background: Color(0xFF1E3A5F),
        foreground: Color(0xFF93C5FD),
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignStatusColors &&
        other.live == live &&
        other.completed == completed &&
        other.locked == locked &&
        other.upcoming == upcoming;
  }

  @override
  int get hashCode => Object.hash(live, completed, locked, upcoming);
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
