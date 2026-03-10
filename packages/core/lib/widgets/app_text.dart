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

  const AppText.labelBold(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.labelBold;

  const AppText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.labelSmall;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.caption;

  const AppText.cardTitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.cardTitle;

  const AppText.cardSubtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.cardSubtitle;

  const AppText.cardCaption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _variant = _AppTextVariant.cardCaption;

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
    // Determine base style from variant or default to body
    final TextStyle baseStyle;
    if (_variant != null) {
      baseStyle = switch (_variant) {
        _AppTextVariant.display => design.typography.display,
        _AppTextVariant.headline => design.typography.headline,
        _AppTextVariant.title => design.typography.title,
        _AppTextVariant.subtitle => design.typography.subtitle,
        _AppTextVariant.body => design.typography.body,
        _AppTextVariant.bodySmall => design.typography.bodySmall,
        _AppTextVariant.label => design.typography.label,
        _AppTextVariant.labelBold => design.typography.labelBold,
        _AppTextVariant.labelSmall => design.typography.labelSmall,
        _AppTextVariant.caption => design.typography.caption,
        _AppTextVariant.cardTitle => design.typography.cardTitle,
        _AppTextVariant.cardSubtitle => design.typography.cardSubtitle,
        _AppTextVariant.cardCaption => design.typography.cardCaption,
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
      baseStyle = design.typography.body;
    }

    // Merge the provided style and color onto the base theme style
    final effectiveStyle = baseStyle.merge(style).copyWith(color: color);

    return Text(
      text,
      style: effectiveStyle,
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
  labelBold,
  labelSmall,
  caption,
  cardTitle,
  cardSubtitle,
  cardCaption,
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
