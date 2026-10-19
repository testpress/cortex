import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_smooth_markdown/flutter_smooth_markdown.dart';
import '../design/design_provider.dart';
import '../utils/ai_markdown_sanitizer.dart';
import 'app_text.dart';

/// Platform-neutral Markdown widget aligned with the design system.
///
/// Ensures consistent markdown rendering across the app by mapping the
/// central typography and layout spacing tokens to [SmoothMarkdown].
class AppMarkdown extends StatefulWidget {
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
  State<AppMarkdown> createState() => _AppMarkdownState();
}

class _AppMarkdownState extends State<AppMarkdown> {
  late String _sanitizedData;

  @override
  void initState() {
    super.initState();
    _sanitizedData = AiMarkdownSanitizer.sanitize(widget.data);
  }

  @override
  void didUpdateWidget(covariant AppMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _sanitizedData = AiMarkdownSanitizer.sanitize(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final baseStyle = design.typography.body.copyWith(
      fontSize: 14,
      height: 1.5,
    );

    return SmoothMarkdown(
      data: _sanitizedData,
      selectable: widget.selectable,
      onTapLink: widget.onTapLink,
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
      builderRegistry: _scrollableMathRegistry,
    );
  }
}

final BuilderRegistry _scrollableMathRegistry = BuilderRegistry()
  ..register('block_math', const _ScrollableBlockMathBuilder())
  ..register('inline_math', const _InlineMathBuilder());

String _sanitizeLatex(String latex) {
  return latex.replaceAllMapped(RegExp(r'(\\*)#'), (match) {
    final slashes = match.group(1)!;
    // An even number of backslashes (0, 2, 4...) means '#' itself is unescaped
    if (slashes.length.isEven) {
      return '$slashes\\#';
    }
    return match.group(0)!;
  });
}

Widget _fallbackMathWidget(String latex, TextStyle? style) {
  var clean = latex.trim();
  // Strip \ce{...} if present so raw chemistry formula renders legibly
  if (clean.startsWith(r'\ce{') && clean.endsWith('}')) {
    clean = clean.substring(4, clean.length - 1);
  }
  return AppText(clean, style: style);
}

class _ScrollableBlockMathBuilder extends MarkdownWidgetBuilder {
  const _ScrollableBlockMathBuilder();

  @override
  bool canBuild(MarkdownNode node) => node is BlockMathNode;

  @override
  Widget build(
    MarkdownNode node,
    MarkdownStyleSheet styleSheet,
    MarkdownRenderContext context,
  ) {
    final mathNode = node as BlockMathNode;
    final sanitizedLatex = _sanitizeLatex(mathNode.latex);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
        child: Math.tex(
          sanitizedLatex,
          textStyle: styleSheet.textStyle,
          mathStyle: MathStyle.display,
          options: MathOptions(
            fontSize: (styleSheet.textStyle?.fontSize ?? 16) * 1.25,
            color: styleSheet.textStyle?.color ?? const Color(0xFF000000),
          ),
          onErrorFallback: (_) =>
              _fallbackMathWidget(mathNode.latex, styleSheet.textStyle),
        ),
      ),
    );
  }
}

class _InlineMathBuilder extends MarkdownWidgetBuilder {
  const _InlineMathBuilder();

  @override
  bool canBuild(MarkdownNode node) => node is InlineMathNode;

  @override
  Widget build(
    MarkdownNode node,
    MarkdownStyleSheet styleSheet,
    MarkdownRenderContext context,
  ) {
    final mathNode = node as InlineMathNode;
    final sanitizedLatex = _sanitizeLatex(mathNode.latex);

    return Math.tex(
      sanitizedLatex,
      textStyle: styleSheet.textStyle,
      mathStyle: MathStyle.text,
      options: MathOptions(
        fontSize: styleSheet.textStyle?.fontSize ?? 16,
        color: styleSheet.textStyle?.color ?? const Color(0xFF000000),
      ),
      onErrorFallback: (_) =>
          _fallbackMathWidget(mathNode.latex, styleSheet.textStyle),
    );
  }
}
