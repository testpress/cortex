import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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
    required this.typographyScale,
    required this.motion,
    required this.radius,
    required this.shadows,
    required this.layout,
    required this.subjectPalette,
    required this.statusColors,
    required this.shortcutPalette,
    required this.study,
    this.isDark = false,
  });

  final DesignColors colors;
  final DesignSpacing spacing;
  final DesignTypography typography;
  final DesignTypographyScale typographyScale;
  final DesignMotion motion;
  final DesignRadius radius;
  final DesignShadows shadows;
  final DesignLayout layout;
  final DesignSubjectPalette subjectPalette;
  final DesignStatusColors statusColors;
  final DesignShortcutPalette shortcutPalette;
  final DesignStudyTheme study;
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
    final colors = DesignColors.light();
    final scale = DesignTypographyScale.defaults();
    return DesignConfig(
      colors: colors,
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(scale: scale, colors: colors),
      typographyScale: scale,
      motion: DesignMotion.defaults(context: context),
      radius: DesignRadius.defaults(),
      shadows: DesignShadows.light(),
      layout: DesignLayout.defaults(),
      subjectPalette: DesignSubjectPalette.light(),
      statusColors: DesignStatusColors.light(),
      shortcutPalette: DesignShortcutPalette.light(),
      study: DesignStudyTheme.light(),
      isDark: false,
    );
  }

  /// Dark mode configuration.
  factory DesignConfig.dark({BuildContext? context}) {
    final colors = DesignColors.dark();
    final scale = DesignTypographyScale.defaults();
    return DesignConfig(
      colors: colors,
      spacing: DesignSpacing.defaults(),
      typography: DesignTypography.defaults(scale: scale, colors: colors),
      typographyScale: scale,
      motion: DesignMotion.defaults(context: context),
      radius: DesignRadius.defaults(),
      shadows: DesignShadows.dark(),
      layout: DesignLayout.defaults(),
      subjectPalette: DesignSubjectPalette.dark(),
      statusColors: DesignStatusColors.dark(),
      shortcutPalette: DesignShortcutPalette.dark(),
      study: DesignStudyTheme.dark(),
      isDark: true,
    );
  }

  DesignConfig copyWith({
    DesignColors? colors,
    DesignSpacing? spacing,
    DesignTypography? typography,
    DesignTypographyScale? typographyScale,
    DesignMotion? motion,
    DesignRadius? radius,
    DesignShadows? shadows,
    DesignLayout? layout,
    DesignSubjectPalette? subjectPalette,
    DesignStatusColors? statusColors,
    DesignShortcutPalette? shortcutPalette,
    DesignStudyTheme? study,
    bool? isDark,
  }) {
    return DesignConfig(
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      typography: typography ?? this.typography,
      typographyScale: typographyScale ?? this.typographyScale,
      motion: motion ?? this.motion,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
      layout: layout ?? this.layout,
      subjectPalette: subjectPalette ?? this.subjectPalette,
      statusColors: statusColors ?? this.statusColors,
      shortcutPalette: shortcutPalette ?? this.shortcutPalette,
      study: study ?? this.study,
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
        other.typographyScale == typographyScale &&
        other.motion == motion &&
        other.radius == radius &&
        other.shadows == shadows &&
        other.layout == layout &&
        other.subjectPalette == subjectPalette &&
        other.statusColors == statusColors &&
        other.shortcutPalette == shortcutPalette &&
        other.study == study &&
        other.isDark == isDark;
  }

  @override
  int get hashCode {
    return Object.hash(
      colors,
      spacing,
      typography,
      typographyScale,
      motion,
      radius,
      shadows,
      layout,
      subjectPalette,
      statusColors,
      shortcutPalette,
      study,
      isDark,
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
    required this.canvas,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.accent4,
    required this.accent5,
    required this.accent6,
    required this.rank1,
    required this.rank2,
    required this.rank3,
    required this.rankDefault,
    required this.overlay,
    required this.shadow,
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

  // New tokens
  final Color canvas;
  final Color accent1; // Purple
  final Color accent2; // Blue
  final Color accent3; // Orange
  final Color accent4; // Green
  final Color accent5; // Rose
  final Color accent6; // Cyan

  final Color rank1;
  final Color rank2;
  final Color rank3;
  final Color rankDefault;

  // Overlay / Backdrop
  final Color overlay;

  // Elevation / Shadows
  final Color shadow;

  factory DesignColors.light() {
    return const DesignColors(
      primary: Color(0xFF6366F1),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF1E1B4B),
      surface: Color(
        0xFFE9EEF4,
      ), // Slate-150 (L~0.93) - mid-ground for restrained separation
      onSurface: Color(0xFF334155),
      surfaceVariant: Color(0xFFDEE5ED), // Slate-250 (approx)
      onSurfaceVariant: Color(0xFF475569),
      card: Color(0xFFFFFFFF),
      onCard: Color(0xFF0F172A),
      border: Color(0xFFDEE5ED),
      divider: Color(0xFFDEE5ED),
      success: Color(0xFF16A34A),
      onSuccess: Color(0xFFFFFFFF),
      error: Color(0xFFEF4444),
      onError: Color(0xFFFFFFFF),
      warning: Color(0xFFEA580C),
      onWarning: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF0F172A), // Slate-950 (L < 0.15)
      textSecondary: Color(
        0xFF64748B,
      ), // Slate-500 (Satisfies distance invariant for Slate-150)
      textTertiary: Color(0xFF94A3B8), // Slate-400
      textInverse: Color(0xFFFFFFFF),
      progressBackground: Color(0xFFDEE5ED),
      progressForeground: Color(0xFF6366F1),
      focus: Color(0x666366F1),
      canvas: Color(0xFFE9EEF4),
      accent1: Color(0xFF9333EA),
      accent2: Color(0xFF2563EB),
      accent3: Color(0xFFEA580C),
      accent4: Color(0xFF16A34A),
      accent5: Color(0xFFE11D48),
      accent6: Color(0xFF0891B2),
      rank1: Color(0xFFFBBF24),
      rank2: Color(0xFFCBD5E1),
      rank3: Color(0xFFFB923C),
      rankDefault: Color(0xFF94A3B8),
      overlay: Color(0x8A000000),
      shadow: Color(0x33000000),
    );
  }

  factory DesignColors.dark() {
    return const DesignColors(
      primary: Color(0xFF818CF8),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF1E1B4B), // Very dark indigo
      onPrimaryContainer: Color(0xFFE0E7FF),
      surface: Color(0xFF18181B), // Zinc-900 (Main UI Surface)
      onSurface: Color(0xFFFAFAFA),
      surfaceVariant: Color(0xFF27272A), // Zinc-800
      onSurfaceVariant: Color(0xFFA1A1AA), // Zinc-400
      card: Color(
        0xFF27272A,
      ), // Zinc-800 (Satisfies 1.15:1 ratio with Zinc-900 surface)
      onCard: Color(0xFFF4F4F5), // Zinc-100
      border: Color(0xFF3F3F46), // Zinc-700 for subtle definition
      divider: Color(0xFF27272A),
      success: Color(0xFF22C55E),
      onSuccess: Color(0xFFFFFFFF),
      error: Color(0xFFF87171),
      onError: Color(0xFF450A0A),
      warning: Color(0xFFF59E0B),
      onWarning: Color(0xFF78350F),
      textPrimary: Color(0xFFFAFAFA), // Zinc-50
      textSecondary: Color(0xFFD4D4D8), // Zinc-300
      textTertiary: Color(0xFFA1A1AA), // Zinc-400
      textInverse: Color(0xFF09090B),
      progressBackground: Color(0xFF27272A),
      progressForeground: Color(0xFF818CF8),
      focus: Color(0x99818CF8),
      canvas: Color(0xFF09090B), // Zinc-950 (Vantablack void)
      accent1: Color(0xFFA855F7),
      accent2: Color(0xFF3B82F6),
      accent3: Color(0xFFFB923C),
      accent4: Color(0xFF22C55E),
      accent5: Color(0xFFFB7185),
      accent6: Color(0xFF22D3EE),
      rank1: Color(0xFFFCD34D),
      rank2: Color(0xFFA1A1AA),
      rank3: Color(0xFFFDBA74),
      rankDefault: Color(0xFF71717A),
      overlay: Color(0x8A000000),
      shadow: Color(0x66000000),
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
    Color canvas = const Color(0xFFF8FAFC),
    Color accent1 = const Color(0xFF9333EA),
    Color accent2 = const Color(0xFF2563EB),
    Color accent3 = const Color(0xFFEA580C),
    Color accent4 = const Color(0xFF16A34A),
    Color accent5 = const Color(0xFFE11D48),
    Color accent6 = const Color(0xFF0891B2),
    Color rank1 = const Color(0xFFFBBF24),
    Color rank2 = const Color(0xFFCBD5E1),
    Color rank3 = const Color(0xFFFB923C),
    Color rankDefault = const Color(0xFF94A3B8),
    Color overlay = const Color(0x8A000000),
    Color shadow = const Color(0x33000000),
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
      canvas: canvas,
      accent1: accent1,
      accent2: accent2,
      accent3: accent3,
      accent4: accent4,
      accent5: accent5,
      accent6: accent6,
      rank1: rank1,
      rank2: rank2,
      rank3: rank3,
      rankDefault: rankDefault,
      overlay: overlay,
      shadow: shadow,
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
        other.progressForeground == progressForeground &&
        other.focus == focus &&
        other.canvas == canvas &&
        other.accent1 == accent1 &&
        other.accent2 == accent2 &&
        other.accent3 == accent3 &&
        other.accent4 == accent4 &&
        other.accent5 == accent5 &&
        other.accent6 == accent6 &&
        other.rank1 == rank1 &&
        other.rank2 == rank2 &&
        other.rank3 == rank3 &&
        other.rankDefault == rankDefault &&
        other.overlay == overlay &&
        other.shadow == shadow;
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
      focus,
      canvas,
      accent1,
      accent2,
      accent3,
      accent4,
      accent5,
      accent6,
      rank1,
      rank2,
      rank3,
      rankDefault,
      overlay,
      shadow,
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

// ─────────────────────────────────────────────────────────────────────────────
// Shortcut Palette
// ─────────────────────────────────────────────────────────────────────────────

/// A color pair for a shortcut (quick access) item.
@immutable
class ShortcutColors {
  const ShortcutColors({required this.background, required this.foreground});

  /// Icon container background color.
  final Color background;

  /// Icon color on [background].
  final Color foreground;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShortcutColors &&
        other.background == background &&
        other.foreground == foreground;
  }

  @override
  int get hashCode => Object.hash(background, foreground);
}

/// Indexed shortcut color palette.
@immutable
class DesignShortcutPalette {
  const DesignShortcutPalette(this._palettes);

  final List<ShortcutColors> _palettes;

  /// Returns the [ShortcutColors] at [i % _palettes.length].
  ShortcutColors atIndex(int i) => _palettes[i % _palettes.length];

  /// Number of distinct color slots in this palette.
  int get length => _palettes.length;

  factory DesignShortcutPalette.light() {
    return const DesignShortcutPalette([
      // 0 — Purple (accent1)
      ShortcutColors(
        background: Color(0xFFF3E8FF),
        foreground: Color(0xFF9333EA),
      ),
      // 1 — Blue (accent2)
      ShortcutColors(
        background: Color(0xFFEFF6FF),
        foreground: Color(0xFF2563EB),
      ),
      // 2 — Orange (accent3)
      ShortcutColors(
        background: Color(0xFFFFF7ED),
        foreground: Color(0xFFEA580C),
      ),
      // 3 — Green (accent4)
      ShortcutColors(
        background: Color(0xFFF0FDF4),
        foreground: Color(0xFF16A34A),
      ),
      // 4 — Rose (accent5)
      ShortcutColors(
        background: Color(0xFFFFF1F2),
        foreground: Color(0xFFE11D48),
      ),
      // 5 — Cyan (accent6)
      ShortcutColors(
        background: Color(0xFFECFEFF),
        foreground: Color(0xFF0891B2),
      ),
    ]);
  }

  factory DesignShortcutPalette.dark() {
    return const DesignShortcutPalette([
      // 0 — Purple
      ShortcutColors(
        background: Color(0xFF2E1065),
        foreground: Color(0xFFA855F7),
      ),
      // 1 — Blue
      ShortcutColors(
        background: Color(0xFF1E3A8A),
        foreground: Color(0xFF3B82F6),
      ),
      // 2 — Orange
      ShortcutColors(
        background: Color(0xFF431407),
        foreground: Color(0xFFFB923C),
      ),
      // 3 — Green
      ShortcutColors(
        background: Color(0xFF052E16),
        foreground: Color(0xFF22C55E),
      ),
      // 4 — Rose
      ShortcutColors(
        background: Color(0xFF4C0519),
        foreground: Color(0xFFFB7185),
      ),
      // 5 — Cyan
      ShortcutColors(
        background: Color(0xFF083344),
        foreground: Color(0xFF22D3EE),
      ),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DesignShortcutPalette) return false;
    if (_palettes.length != other._palettes.length) return false;
    for (int i = 0; i < _palettes.length; i++) {
      if (_palettes[i] != other._palettes[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_palettes);
}

/// Study-specific color tokens for different lesson types.
@immutable
class DesignStudyTheme {
  const DesignStudyTheme({
    required this.video,
    required this.pdf,
    required this.assessment,
    required this.test,
    required this.chapter,
  });

  final ShortcutColors video;
  final ShortcutColors pdf;
  final ShortcutColors assessment;
  final ShortcutColors test;
  final ShortcutColors chapter;

  factory DesignStudyTheme.light() {
    return const DesignStudyTheme(
      video: ShortcutColors(
        background: Color(0xFFF3E8FF),
        foreground: Color(0xFF9333EA),
      ),
      pdf: ShortcutColors(
        background: Color(0xFFEFF6FF),
        foreground: Color(0xFF2563EB),
      ),
      assessment: ShortcutColors(
        background: Color(0xFFF0FDF4),
        foreground: Color(0xFF16A34A),
      ),
      test: ShortcutColors(
        background: Color(0xFFFFF7ED),
        foreground: Color(0xFFEA580C),
      ),
      chapter: ShortcutColors(
        background: Color(0xFFEFF6FF),
        foreground: Color(0xFF2563EB),
      ),
    );
  }

  factory DesignStudyTheme.dark() {
    return const DesignStudyTheme(
      video: ShortcutColors(
        background: Color(0xFF2E1065),
        foreground: Color(0xFFA855F7),
      ),
      pdf: ShortcutColors(
        background: Color(0xFF1E3A8A),
        foreground: Color(0xFF3B82F6),
      ),
      assessment: ShortcutColors(
        background: Color(0xFF052E16),
        foreground: Color(0xFF22C55E),
      ),
      test: ShortcutColors(
        background: Color(0xFF431407),
        foreground: Color(0xFFFB923C),
      ),
      chapter: ShortcutColors(
        background: Color(0xFF1E3A8A),
        foreground: Color(0xFF3B82F6),
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignStudyTheme &&
        other.video == video &&
        other.pdf == pdf &&
        other.assessment == assessment &&
        other.test == test &&
        other.chapter == chapter;
  }

  @override
  int get hashCode => Object.hash(video, pdf, assessment, test, chapter);
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
      cardPadding: 24.0, // Aligned to 8pt set
      screenPadding: 24.0,
      sectionGap: 40.0, // Aligned to 8pt set (5x8)
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

/// Typography atomic scale tokens.
@immutable
class DesignTypographyScale {
  const DesignTypographyScale({
    required this.xs,
    required this.sm,
    required this.base,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.xl4,
    required this.xl5,
  });

  final TextStyle xs;
  final TextStyle sm;
  final TextStyle base;
  final TextStyle lg;
  final TextStyle xl;
  final TextStyle xl2;
  final TextStyle xl3;
  final TextStyle xl4;
  final TextStyle xl5;

  factory DesignTypographyScale.defaults() {
    // Plus Jakarta Sans: geometric humanist typeface designed for UI.
    // Excellent weight differentiation at w400/w600/w700, tight and clean
    // at small sizes, and highly legible inside dense LMS content cards.
    //
    // GoogleFonts.plusJakartaSans() registers the font family on the TextStyle.
    // Each atom then copyWith()s the size/height so the family is inherited
    // by every semantic role (display, headline, body, etc.) automatically.
    final f = GoogleFonts.plusJakartaSans;
    return DesignTypographyScale(
      // xs/sm carry body-adjacent height for readability in dense rows.
      xs: f(fontSize: 12, height: 1.2),
      sm: f(fontSize: 14, height: 1.4),
      // base atom is height-neutral so the body semantic role can
      // set 1.5 explicitly without the atom fighting it.
      base: f(fontSize: 16),
      // Heading atoms: no height baked in. Single-line headlines get
      // their visual rhythm from surrounding layout spacing, not from
      // TextStyle.height, which would add a phantom gap below each heading.
      lg: f(fontSize: 18),
      xl: f(fontSize: 20),
      xl2: f(fontSize: 24),
      xl3: f(fontSize: 30),
      xl4: f(fontSize: 36),
      xl5: f(fontSize: 48),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignTypographyScale &&
        other.xs == xs &&
        other.sm == sm &&
        other.base == base &&
        other.lg == lg &&
        other.xl == xl &&
        other.xl2 == xl2 &&
        other.xl3 == xl3 &&
        other.xl4 == xl4 &&
        other.xl5 == xl5;
  }

  @override
  int get hashCode {
    return Object.hash(xs, sm, base, lg, xl, xl2, xl3, xl4, xl5);
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
    required this.cardTitle,
    required this.cardSubtitle,
    required this.cardCaption,
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
  final TextStyle cardTitle;
  final TextStyle cardSubtitle;
  final TextStyle cardCaption;

  factory DesignTypography.defaults({
    DesignTypographyScale? scale,
    DesignColors? colors,
  }) {
    final s = scale ?? DesignTypographyScale.defaults();
    final c = colors ?? DesignColors.light();

    return DesignTypography(
      // display — commands the page. w700 establishes the top of the
      // weight hierarchy. Negative tracking is valid at 30px (tight
      // glyphs gain visual cohesion at large sizes). No forced height:
      // single-line display text should use layout spacing for rhythm.
      display: s.xl3.copyWith(
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
        letterSpacing: -0.5,
      ),
      // headline — section marker. w600 sits clearly below display.
      // Tracking halved: -0.25px at 20px is optically mild but still
      // adds subtle cohesion for section headings. No forced height.
      headline: s.xl.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
        letterSpacing: -0.25,
      ),
      // title — card/drawer heading. w600 matches headline weight but
      // smaller size creates natural differentiation. Negative tracking
      // removed: -0.25px at 18px compresses glyphs without benefit.
      title: s.lg.copyWith(fontWeight: FontWeight.w600, color: c.textPrimary),
      // subtitle — secondary/contextual label, NOT a heading. w400 and
      // no tracking. Negative tracking at 14px caused visible glyph
      // compression, especially in non-Latin scripts.
      subtitle: s.sm.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textSecondary,
        height: 1.4,
      ),
      // body — primary reading text. height: 1.5 gives a 24px line box
      // at 16px — the typographic gold standard for comfortable reading.
      body: s.base.copyWith(
        fontWeight: FontWeight.w400,
        color: c.textPrimary,
        height: 1.5,
      ),
      // bodySmall — dense info rows (metadata, table cells). height
      // explicitly set to decouple from future sm scale changes.
      bodySmall: s.sm.copyWith(
        fontWeight: FontWeight.w500,
        color: c.textPrimary,
        height: 1.4,
      ),
      // label — UI chrome: buttons, tags, nav items. height: 1.2
      // tightens the line box so labels align cleanly next to icons
      // without the extra leading that 1.4 would add.
      label: s.sm.copyWith(
        fontWeight: FontWeight.w500,
        color: c.textPrimary,
        height: 1.2,
      ),
      // labelSmall — ALL-CAPS section dividers, badge labels, micro UI.
      // w600 compensates for small size. height: 1.1 keeps rows tight.
      labelSmall: s.xs.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textSecondary,
        height: 1.1,
      ),
      // caption — timestamps, metadata, attribution. Positive tracking
      // at 0.4px is perceptible at 12px and slightly improves legibility
      // for dense lowercase text. height: 1.2 keeps caption rows compact.
      caption: s.xs.copyWith(
        fontWeight: FontWeight.w400,
        color: c.textSecondary,
        height: 1.4,
      ),
      // cardTitle — Standard title for cards (Course, Resume, etc).
      // base (14px) size balances visibility without dominating the card.
      cardTitle: s.sm.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
        height: 1.2,
      ),
      // cardSubtitle — Secondary info for cards (chapters, duration).
      cardSubtitle: s.xs.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textSecondary,
        height: 1.4,
      ),
      // cardCaption — Micro info inside cards (ratio labels).
      cardCaption: s.xs.copyWith(
        fontWeight: FontWeight.w400,
        color: c.textSecondary,
        height: 1.0,
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
        other.caption == caption &&
        other.cardTitle == cardTitle &&
        other.cardSubtitle == cardSubtitle &&
        other.cardCaption == cardCaption;
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
      Object.hash(cardTitle, cardSubtitle, cardCaption),
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
      button: BorderRadius.all(Radius.circular(12.0)), // baseRadius(8) * 1.5
      card: BorderRadius.all(Radius.circular(16.0)), // baseRadius(8) * 2
      dialog: BorderRadius.all(Radius.circular(12.0)), // baseRadius(8) * 1.5
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

/// Shadow token group.
@immutable
class DesignShadows {
  const DesignShadows({
    required this.surfaceSoft,
    required this.floating,
    required this.none,
  });

  /// Barely perceptible elevation shadow for cards and surfaces.
  /// Felt, not seen.
  final List<BoxShadow>? surfaceSoft;

  /// Prominent elevation shadow for floating components (mini-players, sheets).
  final List<BoxShadow>? floating;

  /// No shadow.
  final List<BoxShadow>? none;

  factory DesignShadows.light() {
    return DesignShadows(
      surfaceSoft: [
        BoxShadow(
          color: const Color(
            0xFF000000,
          ).withValues(alpha: 0.04), // 4% opacity invariant
          blurRadius: 40, // blur >= 40 invariant
          offset: const Offset(0, 8), // vertical-only offset invariant
        ),
      ],
      floating: [
        // Layer 1: Tight/Contact Area (Grounded Depth)
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        // Layer 2: Softer Ambient Area (Diffusion/Lift)
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          blurRadius: 40,
          offset: const Offset(0, 12),
        ),
      ],
      none: null,
    );
  }

  factory DesignShadows.dark() {
    return DesignShadows(
      surfaceSoft: [
        BoxShadow(
          color: const Color(
            0xFF000000,
          ).withValues(alpha: 0.04), // Invariant opacity across themes
          blurRadius: 40,
          offset: const Offset(0, 8),
        ),
      ],
      floating: [
        // Layer 1: Tight/Contact Area (Grounded Depth)
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        // Layer 2: Softer Ambient Area (Diffusion/Lift)
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          blurRadius: 40,
          offset: const Offset(0, 12),
        ),
      ],
      none: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignShadows &&
        _listEquals(other.surfaceSoft, surfaceSoft) &&
        _listEquals(other.floating, floating) &&
        other.none == none;
  }

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == b) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(surfaceSoft ?? []),
    Object.hashAll(floating ?? []),
    none,
  );
}

/// Layout token group.
@immutable
class DesignLayout {
  const DesignLayout({
    required this.drawerWidth,
    required this.maxDrawerWidth,
    required this.railWidth,
    required this.tabletBreakpoint,
  });

  final double drawerWidth;
  final double maxDrawerWidth;
  final double railWidth;
  final double tabletBreakpoint;

  factory DesignLayout.defaults() {
    return const DesignLayout(
      drawerWidth: 280.0,
      maxDrawerWidth: 400.0,
      railWidth: 80.0,
      tabletBreakpoint: 600.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignLayout &&
        other.drawerWidth == drawerWidth &&
        other.maxDrawerWidth == maxDrawerWidth &&
        other.railWidth == railWidth &&
        other.tabletBreakpoint == tabletBreakpoint;
  }

  @override
  int get hashCode =>
      Object.hash(drawerWidth, maxDrawerWidth, railWidth, tabletBreakpoint);
}
