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
  }) : style = null,
       _variant = _AppTextVariant.display;

  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.headline;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.title;

  const AppText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.subtitle;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.body;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.bodySmall;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.label;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variant = _AppTextVariant.caption;

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
      };
    } else {
      effectiveStyle = design.typography.body;
    }

    return Text(
      text,
      style: effectiveStyle.copyWith(color: color ?? design.colors.textPrimary),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      // Respect system font scaling for accessibility
      textScaler: TextScaler.linear(MediaQuery.textScaleFactorOf(context)),
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
}
