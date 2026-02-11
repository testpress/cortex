import 'package:flutter/widgets.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

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
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  // Semantic constructors
  const AppText.display(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.display;

  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.headline;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.title;

  const AppText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.subtitle;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.body;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.bodySmall;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.label;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = AppTypography.caption;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? AppTypography.body).copyWith(
        color: color ?? AppColors.textPrimary,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      // Respect system font scaling for accessibility
      textScaler: TextScaler.linear(MediaQuery.textScaleFactorOf(context)),
    );
  }
}
