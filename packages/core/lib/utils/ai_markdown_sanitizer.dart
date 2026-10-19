/// Utility that sanitizes AI assistant markdown responses before rendering.
///
/// Normalizes LLM delimiter inconsistencies while preserving code blocks untouched.
class AiMarkdownSanitizer {
  const AiMarkdownSanitizer._();

  // Code blocks & inline code (including unclosed fences during token streaming).
  static final _codeBlockRegex = RegExp(
    r'(```[\s\S]*?```|```[^\n]*(?:\n[\s\S]*)?$|`[^`\n]+`)',
  );

  // LaTeX math delimited by \[ ... \] and \( ... \) within a single paragraph.
  static final _blockMathBracketRegex = RegExp(
    r'(?<!\w)\\\[((?:[^\n\r]|\r?\n(?!\s*\r?\n))+?)\\\]',
  );
  static final _inlineMathParenRegex = RegExp(r'(?<!\w)\\\(([^\n\r]+?)\\\)');

  static final _singleLineBlockMathRegex = RegExp(
    r'^[ \t]*\$\$(.+?)\$\$[ \t]*$',
    multiLine: true,
  );
  static final _indentedDoubleDollarRegex = RegExp(
    r'^[ \t]+(\$\$)[ \t]*$',
    multiLine: true,
  );
  static final _allDoubleDollarRegex = RegExp(r'\$\$');

  static final _latexMathIndicatorRegex = RegExp(r'[\\^=_<>±×÷≈≠≤≥]');
  static final _digitOperatorRegex = RegExp(r'(?:\d\s*[-+/*]|[-+/*]\s*\d)');
  static final _singleVariableRegex = RegExp(r'^[a-zA-Z]$');

  // Private-use unicode sentinels to prevent syntax collisions.
  static const _codeSentinelPrefix = '\uE000CODEBLOCK';
  static const _codeSentinelSuffix = '\uE001';

  static String sanitize(String input) {
    if (input.isEmpty) return input;

    final codeSpans = <String>[];
    var text = _maskCodeBlocks(input, codeSpans);
    text = _normalizeMath(text);

    return _unmask(text, codeSpans, _codeSentinelPrefix, _codeSentinelSuffix);
  }

  static bool _hasMathContent(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;
    return _latexMathIndicatorRegex.hasMatch(trimmed) ||
        _digitOperatorRegex.hasMatch(trimmed) ||
        _singleVariableRegex.hasMatch(trimmed);
  }

  static String _maskCodeBlocks(String input, List<String> spans) {
    return input.replaceAllMapped(_codeBlockRegex, (match) {
      spans.add(match[0]!);
      return '$_codeSentinelPrefix${spans.length - 1}$_codeSentinelSuffix';
    });
  }

  static String _normalizeMath(String input) {
    var text = input.replaceAllMapped(_blockMathBracketRegex, (m) {
      final inner = m.group(1)!.trim();
      return _hasMathContent(inner) ? '\n\$\$\n$inner\n\$\$\n' : m.group(0)!;
    });

    text = text.replaceAllMapped(_inlineMathParenRegex, (m) {
      final inner = m.group(1)!.trim();
      return _hasMathContent(inner) ? '\$$inner\$' : m.group(0)!;
    });

    text = text.replaceAllMapped(_singleLineBlockMathRegex, (m) {
      final inner = m.group(1)!.trim();
      return (inner.isNotEmpty && !inner.contains('\n'))
          ? '\n\$\$\n$inner\n\$\$\n'
          : m.group(0)!;
    });

    text = text.replaceAllMapped(
      _indentedDoubleDollarRegex,
      (m) => m.group(1)!,
    );

    // Auto-close trailing $$ for streaming cutoffs (note: also triggers on literal $$ in prose like currency).
    final doubleDollarCount = _allDoubleDollarRegex.allMatches(text).length;
    if (doubleDollarCount.isOdd) {
      text = text.trimRight();
      text += '\n\$\$\n';
    }

    return text;
  }

  static String _unmask(
    String input,
    List<String> spans,
    String prefix,
    String suffix,
  ) {
    var text = input;
    for (int i = 0; i < spans.length; i++) {
      text = text.replaceAll('$prefix$i$suffix', spans[i]);
    }
    return text;
  }
}
