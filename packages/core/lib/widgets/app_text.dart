import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

/// Platform-neutral text widget with semantic variants.
///
/// Replaces Material's Text widget with predefined styles from our
/// typography tokens. Ensures consistent text rendering across platforms.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = null;

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final _AppTextVariant? _variant;

  // Semantic constructors
  const AppText.display(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.display;

  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.headline;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.title;

  const AppText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.subtitle;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.body;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.bodySmall;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.label;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.caption;

  const AppText.xs(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xs;

  const AppText.sm(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.sm;

  const AppText.base(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.base;

  const AppText.lg(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.lg;

  const AppText.xl(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xl;

  const AppText.xl2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xl2;

  const AppText.xl3(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xl3;

  const AppText.xl4(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xl4;

  const AppText.xl5(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.xl5;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Determine effective style based on variant or explicit style
    final TextStyle effectiveStyle;
    if (style != null) {
      effectiveStyle = style!;
    } else if (_variant != null) {
      effectiveStyle = switch (_variant) {
        _AppTextVariant.display => design.typography.display,
        _AppTextVariant.headline => design.typography.headline,
        _AppTextVariant.title => design.typography.title,
        _AppTextVariant.subtitle => design.typography.subtitle,
        _AppTextVariant.body => design.typography.body,
        _AppTextVariant.bodySmall => design.typography.bodySmall,
        _AppTextVariant.label => design.typography.label,
        _AppTextVariant.caption => design.typography.caption,
        // Scale roles
        _AppTextVariant.xs => design.typographyScale.xs,
        _AppTextVariant.sm => design.typographyScale.sm,
        _AppTextVariant.base => design.typographyScale.base,
        _AppTextVariant.lg => design.typographyScale.lg,
        _AppTextVariant.xl => design.typographyScale.xl,
        _AppTextVariant.xl2 => design.typographyScale.xl2,
        _AppTextVariant.xl3 => design.typographyScale.xl3,
        _AppTextVariant.xl4 => design.typographyScale.xl4,
        _AppTextVariant.xl5 => design.typographyScale.xl5,
      };
    } else {
      effectiveStyle = design.typography.body;
    }

    return Text(
      text,
      style: effectiveStyle.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      // Respect system font scaling for accessibility
      textScaler: MediaQuery.textScalerOf(context),
    );
  }
}

enum _AppTextVariant {
  display,
  headline,
  title,
  subtitle,
  body,
  bodySmall,
  label,
  caption,
  xs,
  sm,
  base,
  lg,
  xl,
  xl2,
  xl3,
  xl4,
  xl5,
}
