import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import 'app_loading_indicator.dart';

import 'package:skeletonizer/skeletonizer.dart';

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

    final effectiveTextColor = textColor ?? design.colors.textPrimary;

    final processedData = _preprocessMath(data);

    return Padding(
      padding: padding,
      child: HtmlWidget(
        processedData,

        onTapImage: (metadata) {
          final sources = metadata.sources;
          if (sources.isNotEmpty) {
            final url = sources.first.url;
            _showZoomableImage(context, url, design);
          }
        },

        factoryBuilder: () => _MathWidgetFactory(
          textColor: effectiveTextColor,
          fontSize: fontSize,
          maxWidth: MediaQuery.of(context).size.width - 64,
        ),

        onLoadingBuilder: (context, element, progress) {
          final widthAttr = element.attributes['width'];
          final heightAttr = element.attributes['height'];

          double? w = widthAttr != null ? double.tryParse(widthAttr) : null;
          double? h = heightAttr != null ? double.tryParse(heightAttr) : null;

          final decoration = BoxDecoration(
            color: design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.md),
          );

          Widget placeholder;
          if (w != null && h != null && w > 0 && h > 0) {
            placeholder = AspectRatio(
              aspectRatio: w / h,
              child: Container(decoration: decoration),
            );
          } else {
            placeholder = SizedBox(
              width: double.infinity,
              height: h ?? 250,
              child: Container(decoration: decoration),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.md),
            child: Skeletonizer(
              enabled: true,
              child: Skeleton.replace(child: placeholder),
            ),
          );
        },

        textStyle: design.typography.body.copyWith(
          color: effectiveTextColor,
          fontSize: fontSize,
        ),

        customStylesBuilder: (element) {
          final tag = element.localName;

          final Map<String, String> styles = {};
          // We allow the backend's colors and font-families,
          // but we will strictly override the font size below.

          if (tag != 'math-tex') {
            styles['font-size'] = '${fontSize}px';
          }

          // Detect if paragraph is inside a list item

          var parent = element.parent;

          while (parent != null) {
            if (parent.localName == 'li') {
              break;
            }

            parent = parent.parent;
          }

          // Paragraphs
          if (tag == 'p') {
            styles['margin'] =
                '0'; // Fixed the huge gap on the bottom of options
          }

          // Divs
          if (tag == 'div') {
            styles['margin'] = '0';
          }

          // Ordered / unordered lists
          if (tag == 'ol' || tag == 'ul') {
            styles['margin'] = '0 0 8px 0';
            styles['padding-left'] = '20px';
          }

          // List items
          if (tag == 'li') {
            styles['margin'] = '0 0 4px 0';
          }

          // Tables
          if (tag == 'table') {
            styles['border-collapse'] = 'collapse';
            styles['width'] = '100%';
            styles['margin'] = '8px 0';
          }

          if (tag == 'td' || tag == 'th') {
            styles['border'] = '1px solid currentColor';
            styles['padding'] = '6px';
          }

          // Images
          if (tag == 'img') {
            styles['max-width'] = '100%';
          }

          return styles.isNotEmpty ? styles : null;
        },
      ),
    );
  }

  void _showZoomableImage(
    BuildContext context,
    String imageUrl,
    DesignConfig design,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: design.colors.overlay.withValues(alpha: 0.8),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _ZoomableImageViewer(imageUrl: imageUrl, design: design),
          );
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

    // ── PASS 0: STRIP MS WORD INLINE FONTS & STYLES ─────────────────────────

    // 1. Strip <style> blocks entirely (contains .MsoNormal etc.)
    res = res.replaceAll(
      RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false),
      '',
    );

    // 2. Strip only size from legacy <font> tags (preserve color and face)
    res = res.replaceAllMapped(
      RegExp(r'''<font([^>]*)>''', caseSensitive: false),
      (m) {
        String attrs = m[1] ?? '';
        attrs = attrs.replaceAll(
          RegExp(
            r'''size\s*=\s*(?:["'][^"']*["']|\S+)''',
            caseSensitive: false,
          ),
          '',
        );
        return '<font$attrs>';
      },
    );

    // 3. Strip only font-size from inline styles (preserve color and font-family)
    res = res.replaceAllMapped(
      RegExp(r'''style\s*=\s*(["'])(.*?)\1''', caseSensitive: false),
      (m) {
        String style = m[2] ?? '';
        style = style.replaceAll('&quot;', "'");
        style = style.replaceAll(
          RegExp(r'''font-size\s*:[^;]*;?''', caseSensitive: false),
          '',
        );
        return 'style=${m[1]}$style${m[1]}';
      },
    );

    // 4. Strip empty paragraphs
    res = res.replaceAll(
      RegExp(
        r'<p[^>]*>(?:\s|&nbsp;|<(?:span|div|br)[^>]*>(?:\s|&nbsp;)*</(?:span|div)>|<br\s*/?>)*</p>',
        caseSensitive: false,
      ),
      '',
    );

    // ── PASS 0b: REMAP UNSUPPORTED LATEX COMMANDS ─────────────────────────
    res = res.replaceAllMapped(
      RegExp(r'\\operatorname\{([^}]*)\}'),
      (m) => '\\mathrm{${m[1]}}',
    );

    // ── PASS 1: BLOCK MATH ──────────────────────────────────────────────────

    res = res.replaceAllMapped(
      RegExp(r'\$\$(.*?)\$\$', dotAll: true),
      (m) => '<math-tex block="true">${m[1]}</math-tex>',
    );

    res = res.replaceAllMapped(
      RegExp(r'\\\[(.*?)\\\]', dotAll: true),
      (m) => '<math-tex block="true">${m[1]}</math-tex>',
    );

    // ── PASS 2: INLINE MATH ─────────────────────────────────────────────────

    res = res.replaceAllMapped(
      RegExp(r'\\\((.*?)\\\)', dotAll: true),
      (m) => '<math-tex>${m[1]}</math-tex>',
    );

    res = res.replaceAllMapped(
      RegExp(r'\$(?!\s)([^$\n]+?)(?<!\s)\$'),
      (m) => '<math-tex>${m[1]}</math-tex>',
    );

    // ── PASS 3: BARE DELIMITERS ─────────────────────────────────────────────

    final bareBracketRegex = RegExp(
      r'(?<!\[)\[([^\]]*?(?:\\|\^|_)[^\]]*?)\](?!\])',
    );
    final bareParenRegex = RegExp(
      r'(?<![a-zA-Z0-9])\(([^)]*?(?:\\|\^|_)[^)]*?)\)',
    );

    final tagPattern = RegExp(r'<math-tex[^>]*>[\s\S]*?</math-tex>');
    final buffer = StringBuffer();
    var cursor = 0;

    for (final match in tagPattern.allMatches(res)) {
      var before = res.substring(cursor, match.start);
      before = before.replaceAllMapped(
        bareBracketRegex,
        (m) => '<math-tex block="true">${m[1]!.trim()}</math-tex>',
      );
      before = before.replaceAllMapped(
        bareParenRegex,
        (m) => '<math-tex>${m[1]!.trim()}</math-tex>',
      );
      buffer.write(before);
      buffer.write(match.group(0));
      cursor = match.end;
    }

    var tail = res.substring(cursor);
    tail = tail.replaceAllMapped(
      bareBracketRegex,
      (m) => '<math-tex block="true">${m[1]!.trim()}</math-tex>',
    );
    tail = tail.replaceAllMapped(
      bareParenRegex,
      (m) => '<math-tex>${m[1]!.trim()}</math-tex>',
    );
    buffer.write(tail);

    res = buffer.toString();

    return res;
  }
}

class _MathWidgetFactory extends WidgetFactory {
  _MathWidgetFactory({
    required this.textColor,
    required this.fontSize,
    required this.maxWidth,
  });

  final Color textColor;
  final double fontSize;
  final double maxWidth;

  @override
  void parse(BuildTree meta) {
    if (meta.element.localName == 'math-tex') {
      final isBlock = meta.element.attributes['block'] == 'true';

      final tex = meta.element.text.trim().replaceAll(RegExp(r'\s+'), ' ');

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
      else {
        meta.register(
          BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              final mathWidget = _buildInlineMath(tex);
              // Heuristic: If an inline equation is very long, it will overflow the line.
              // We wrap it in a scroll view constrained to the screen width.
              // Because it's an inline WidgetSpan, it will naturally wrap to the next
              // line if it doesn't fit next to the preceding text, preventing crashes.
              if (tex.length > 35) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: mathWidget,
                  ),
                );
              }

              return Baseline(
                baseline: fontSize * 1.15,
                baselineType: TextBaseline.alphabetic,
                child: mathWidget,
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

      // Prevents giant display-style inline equations from breaking line height
      mathStyle: MathStyle.text,

      textStyle: TextStyle(color: textColor, fontSize: fontSize * 1.1),

      onErrorFallback: (error) {
        return Text(
          tex,
          style: TextStyle(
            color: const Color(0xFFFF0000),
            fontSize: fontSize * 1.1,
          ),
        );
      },
    );
  }

  Widget _buildBlockMath(String tex) {
    final mathWidget = Math.tex(
      tex,

      mathStyle: MathStyle.display,

      textStyle: TextStyle(color: textColor, fontSize: fontSize * 1.2),

      onErrorFallback: (error) {
        return Text(
          tex,
          style: TextStyle(
            color: const Color(0xFFFF0000),
            fontSize: fontSize * 1.2,
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: mathWidget,
        ),
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({required this.imageUrl, required this.design});

  final String imageUrl;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: design.colors.transparent, // Transparent to catch tap
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 5.0,
                    child: Builder(
                      builder: (context) {
                        if (imageUrl.startsWith('data:image')) {
                          try {
                            // Extract just the base64 part
                            final commaIndex = imageUrl.indexOf(',');
                            if (commaIndex != -1) {
                              // We use dart:convert if we imported it, but for data URIs UriData works:
                              final uriData = UriData.parse(imageUrl);
                              return Image.memory(
                                uriData.contentAsBytes(),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildErrorText(design);
                                },
                              );
                            }
                          } catch (e) {
                            return _buildErrorText(design);
                          }
                        }

                        if (imageUrl.startsWith('file://')) {
                          final path = imageUrl.replaceFirst('file://', '');
                          return Image.file(
                            File(path),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildErrorText(design);
                            },
                          );
                        }

                        return Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: AppLoadingIndicator(
                                color: design.colors.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildErrorText(design);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: design.colors.onPrimary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorText(DesignConfig design) {
    return Center(
      child: Text(
        'Failed to load image',
        style: TextStyle(
          color: design.colors.textInverse,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
