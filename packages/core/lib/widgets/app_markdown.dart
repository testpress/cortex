import 'package:flutter/material.dart';
import 'package:flutter_smooth_markdown/flutter_smooth_markdown.dart';
import '../design/design_provider.dart';

/// Platform-neutral Markdown widget aligned with the design system.
///
/// Ensures consistent markdown rendering across the app by mapping the
/// central typography and layout spacing tokens to [SmoothMarkdown].
class AppMarkdown extends StatelessWidget {
  const AppMarkdown({
    super.key,
    required this.data,
    this.onTapLink,
    this.selectable = true,
  });

  final String data;
  final ValueChanged<String>? onTapLink;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final baseStyle = design.typography.body.copyWith(
      color: design.colors.textSecondary,
      fontSize: 14,
      height: 1.5,
    );

    return SmoothMarkdown(
      data: data,
      selectable: selectable,
      onTapLink: onTapLink,
      styleSheet: MarkdownStyleSheet.light().copyWith(
        textStyle: baseStyle,
        paragraphStyle: baseStyle,
        linkStyle: baseStyle.copyWith(color: design.colors.accent2),
        h1Style: design.typography.headline.copyWith(
          color: design.colors.textPrimary,
        ),
        h2Style: design.typography.title.copyWith(
          color: design.colors.textPrimary,
        ),
        h3Style: design.typography.body.copyWith(
          color: design.colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        listBulletStyle: baseStyle.copyWith(color: design.colors.textTertiary),
        blockSpacing: design.spacing.md,
        listIndent: design.spacing.lg,
        blockquotePadding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        codeBlockPadding: EdgeInsets.all(design.spacing.sm),
        tableCellPadding: EdgeInsets.all(design.spacing.sm),
        inlineCodeStyle: baseStyle.copyWith(
          backgroundColor: design.colors.divider.withValues(alpha: 0.1),
          fontFamily: 'monospace',
          fontSize: 13,
          color: design.colors.accent2,
        ),
        codeBlockDecoration: BoxDecoration(
          color: design.colors.divider.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(design.spacing.sm),
        ),
      ),
    );
  }
}
