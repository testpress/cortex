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
      fontSize: 14,
      height: 1.5,
    );

    return SmoothMarkdown(
      data: data,
      selectable: selectable,
      onTapLink: onTapLink,
      styleSheet: MarkdownStyleSheet.light(baseStyle: baseStyle).copyWith(
        textStyle: baseStyle,
        paragraphStyle: baseStyle,
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
        h4Style: design.typography.body.copyWith(
          color: design.colors.textPrimary,
        ),
        h5Style: baseStyle.copyWith(color: design.colors.textPrimary),
        h6Style: baseStyle.copyWith(color: design.colors.textTertiary),
        boldStyle: baseStyle.copyWith(
          fontWeight: FontWeight.w700,
          color: design.colors.textPrimary,
        ),
        italicStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
        linkStyle: baseStyle.copyWith(
          color: design.colors.accent2,
          decoration: TextDecoration.none,
        ),
        listBulletStyle: baseStyle.copyWith(color: design.colors.textTertiary),
        blockSpacing: design.spacing.md,
        listIndent: design.spacing.lg,
        blockquoteDecoration: BoxDecoration(
          color: design.colors.primary.withValues(alpha: 0.06),
          border: Border(
            left: BorderSide(color: design.colors.primary, width: 3.0),
          ),
        ),
        blockquotePadding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        blockquoteStyle: baseStyle.copyWith(
          color: design.colors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        inlineCodeStyle: baseStyle.copyWith(
          backgroundColor: design.colors.divider.withValues(alpha: 0.15),
          fontFamily: 'monospace',
          fontSize: 13,
          color: design.colors.accent2,
        ),
        codeBlockDecoration: BoxDecoration(
          color: design.colors.divider.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(design.spacing.sm),
        ),
        codeBlockPadding: EdgeInsets.all(design.spacing.md),
        tableHeaderStyle: baseStyle.copyWith(
          color: design.colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        tableCellStyle: baseStyle,
        tableCellPadding: EdgeInsets.all(design.spacing.sm),
        tableHeaderDecoration: BoxDecoration(color: design.colors.surface),
        tableBorder: TableBorder.all(color: design.colors.border, width: 1.0),
      ),
    );
  }
}
