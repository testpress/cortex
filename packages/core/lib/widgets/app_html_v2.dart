import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../design/design_provider.dart';

/// Native HTML + LaTeX renderer.
///
/// Features:
/// - Proper inline LaTeX rendering
/// - Proper block equations
/// - Browser-like spacing
/// - Reduced excessive newlines
/// - Native Flutter rendering (no WebView)
/// - Horizontal scroll for large equations
class AppHtmlV2 extends StatelessWidget {
  const AppHtmlV2({
    super.key,
    required this.data,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.padding = EdgeInsets.zero,
  });

  final String data;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final effectiveTextColor =
        textColor ?? design.colors.textPrimary;

    final processedData = _preprocessMath(data);

    return Padding(
      padding: padding,
      child: HtmlWidget(
        processedData,

        factoryBuilder: () => _MathWidgetFactory(
          textColor: effectiveTextColor,
          fontSize: fontSize,
        ),

        textStyle: design.typography.body.copyWith(
          color: effectiveTextColor,
          fontSize: fontSize,
          height: 1.35,
        ),

        customStylesBuilder: (element) {
          final tag = element.localName;

          // Detect if paragraph is inside a list item
          bool insideLi = false;

          var parent = element.parent;

          while (parent != null) {
            if (parent.localName == 'li') {
              insideLi = true;
              break;
            }

            parent = parent.parent;
          }

          // Paragraphs
          if (tag == 'p') {
            return {
              'margin': insideLi
                  ? '0'
                  : '0 0 6px 0',
            };
          }

          // Divs
          if (tag == 'div') {
            return {
              'margin': '0',
            };
          }

          // Ordered / unordered lists
          if (tag == 'ol' || tag == 'ul') {
            return {
              'margin': '0 0 8px 0',
              'padding-left': '20px',
            };
          }

          // List items
          if (tag == 'li') {
            return {
              'margin': '0 0 4px 0',
            };
          }

          // Tables
          if (tag == 'table') {
            return {
              'border-collapse': 'collapse',
              'width': '100%',
              'margin': '8px 0',
            };
          }

          if (tag == 'td' || tag == 'th') {
            return {
              'border': '1px solid currentColor',
              'padding': '6px',
            };
          }

          // Images
          if (tag == 'img') {
            return {
              'max-width': '100%',
            };
          }

          return null;
        },
      ),
    );
  }

  /// Converts LaTeX delimiters into custom math-tex tags.
  ///
  /// Handles all delimiter variants the API may produce:
  ///
  /// BLOCK math:
  ///   - $$ ... $$
  ///   - \[ ... \]         (proper)
  ///   - [ \n ... \n ]     (bare brackets, multiline — common LLM output)
  ///
  /// INLINE math:
  ///   - \( ... \)         (proper)
  ///   - $ ... $           (single dollar, skips currency like $5)
  ///   - ( \cmd ... )      (bare parens starting with a LaTeX command)
  ///
  /// Order matters:
  ///   All BLOCK patterns are processed first, then INLINE.
  ///   Bare paren detection runs only on text outside already-converted tags
  ///   to prevent nested math-tex tags inside block equations.
  String _preprocessMath(String html) {
    var res = html;

    // ── PASS 1: BLOCK MATH ──────────────────────────────────────────────────

    // Block: $$ ... $$
    res = res.replaceAllMapped(
      RegExp(r'\$\$(.*?)\$\$', dotAll: true),
      (m) => '<math-tex block="true">${m[1]}</math-tex>',
    );

    // Block: \[ ... \] (proper backslash delimiters)
    res = res.replaceAllMapped(
      RegExp(r'\\\[(.*?)\\\]', dotAll: true),
      (m) => '<math-tex block="true">${m[1]}</math-tex>',
    );

    // Block: bare [ ... ] — must contain a \ command, caret ^, or underscore _.
    // Avoids matching normal text like [see above] or [1].
    res = res.replaceAllMapped(
      RegExp(r'(?<!\[)\[([^\]]*?(?:\\|\^|_)[^\]]*?)\](?!\])'),
      (m) => '<math-tex block="true">${m[1]!.trim()}</math-tex>',
    );

    // ── PASS 2: INLINE MATH ─────────────────────────────────────────────────

    // Inline: \( ... \) (proper backslash delimiters)
    res = res.replaceAllMapped(
      RegExp(r'\\\((.*?)\\\)', dotAll: true),
      (m) => '<math-tex>${m[1]}</math-tex>',
    );

    // Inline: $ ... $ (single dollar)
    // Standard MathJax/KaTeX rule: the $ must not be immediately followed by a space,
    // and the closing $ must not be immediately preceded by a space.
    // This perfectly skips false positives like "I paid $5 and he paid $10."
    res = res.replaceAllMapped(
      RegExp(r'\$(?!\s)([^$\n]+?)(?<!\s)\$'),
      (m) => '<math-tex>${m[1]}</math-tex>',
    );

    // Inline: bare ( ... ) — must contain a \ command, caret ^, or underscore _.
    // Runs only on text OUTSIDE existing <math-tex> tags.
    final bareParenRegex = RegExp(
      r'(?<![a-zA-Z0-9])\(([^)]*?(?:\\|\^|_)[^)]*?)\)',
    );

    // Split by existing tags, apply bare-paren regex only to plain text parts.
    // Manually reconstruct segments because splitWithDelimiters is unavailable.
    final tagPattern = RegExp(r'<math-tex[^>]*>[\s\S]*?</math-tex>');
    final buffer = StringBuffer();
    var cursor = 0;

    for (final match in tagPattern.allMatches(res)) {
      // Text before this tag — apply bare-paren regex
      final before = res.substring(cursor, match.start);
      buffer.write(before.replaceAllMapped(
        bareParenRegex,
        (m) => '<math-tex>${m[1]!.trim()}</math-tex>',
      ));
      // The tag itself — keep as-is
      buffer.write(match.group(0));
      cursor = match.end;
    }

    // Remaining text after last tag
    final tail = res.substring(cursor);
    buffer.write(tail.replaceAllMapped(
      bareParenRegex,
      (m) => '<math-tex>${m[1]!.trim()}</math-tex>',
    ));

    res = buffer.toString();

    return res;
  }
}

class _MathWidgetFactory extends WidgetFactory {
  _MathWidgetFactory({
    required this.textColor,
    required this.fontSize,
  });

  final Color textColor;
  final double fontSize;

  @override
  void parse(BuildTree meta) {
    if (meta.element.localName == 'math-tex') {
      final isBlock =
          meta.element.attributes['block'] == 'true';

      final tex = meta.element.text.trim();

      // BLOCK EQUATIONS
      if (isBlock) {
        meta.register(
          BuildOp(
            onRenderBlock: (tree, placeholder) {
              return _buildBlockMath(tex);
            },
          ),
        );
      }

      // INLINE EQUATIONS
      // INLINE EQUATIONS
      else {
        meta.register(
          BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              return Baseline(
                baseline: fontSize * 1.15,
                baselineType: TextBaseline.alphabetic,
                child: _buildInlineMath(tex),
              );
            },
          ),
        );
      }
    } else {
      super.parse(meta);
    }
  }

  Widget _buildInlineMath(String tex) {
    return Math.tex(
      tex,

      // Important:
      // Prevents giant display-style inline equations
      mathStyle: MathStyle.text,

      textStyle: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),

      onErrorFallback: (error) {
        return Text(
          tex,
          style: TextStyle(
            color: const Color(0xFFFF0000),
            fontSize: fontSize,
          ),
        );
      },
    );
  }

  Widget _buildBlockMath(String tex) {
    final mathWidget = Math.tex(
      tex,

      mathStyle: MathStyle.display,

      textStyle: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),

      onErrorFallback: (error) {
        return Text(
          tex,
          style: TextStyle(
            color: const Color(0xFFFF0000),
            fontSize: fontSize,
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: mathWidget,
        ),
      ),
    );
  }
}