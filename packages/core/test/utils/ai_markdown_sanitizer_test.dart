import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/ai_markdown_sanitizer.dart';

void main() {
  group('AiMarkdownSanitizer', () {
    test('preserves code blocks and inline code untouched', () {
      const input = '''
Here is some code:
```dart
void main() {
  var x_1 = 10;
  // \$\$ not math \$\$
}
```
And inline `var y_1 = 20;` code.
''';
      expect(AiMarkdownSanitizer.sanitize(input), input);
    });

    test('protects unclosed code fences during streaming', () {
      const input = '''
Here is partial code:
```dart
void main() {
  var x_1 = 10;
  \$\$ not math \$\$
''';
      expect(AiMarkdownSanitizer.sanitize(input), input);

      const bareFence = 'Here is code:\n```';
      expect(AiMarkdownSanitizer.sanitize(bareFence), bareFence);

      const bareLanguageFence = 'Here is code:\n```dart';
      expect(
        AiMarkdownSanitizer.sanitize(bareLanguageFence),
        bareLanguageFence,
      );
    });

    test('normalizes bracket block math to double dollars', () {
      const input = r'\[ x^2 + y^2 = r^2 \]';
      expect(
        AiMarkdownSanitizer.sanitize(input),
        '\n\$\$\nx^2 + y^2 = r^2\n\$\$\n',
      );
    });

    test('normalizes paren inline math to single dollars', () {
      const input = r'The value \( x \) is variable.';
      expect(
        AiMarkdownSanitizer.sanitize(input),
        'The value \$x\$ is variable.',
      );
    });

    test('expands indented single-line block math to multiline block math', () {
      const input = '  \$\$ c^2 = a^2 + b^2 \$\$';
      expect(
        AiMarkdownSanitizer.sanitize(input),
        '\n\$\$\nc^2 = a^2 + b^2\n\$\$\n',
      );
    });

    test(
      'auto-closes trailing unclosed double dollars on streaming cutoff',
      () {
        const cutoffAfterOpening = 'Here is math:\n\$\$';
        expect(
          AiMarkdownSanitizer.sanitize(cutoffAfterOpening),
          'Here is math:\n\$\$\n\$\$\n',
        );

        const bareOpening = 'Formula: \$\$';
        expect(
          AiMarkdownSanitizer.sanitize(bareOpening),
          'Formula: \$\$\n\$\$\n',
        );

        const cutoffMidFormula = 'Here is math: \$\$ x = 5';
        expect(
          AiMarkdownSanitizer.sanitize(cutoffMidFormula),
          'Here is math: \$\$ x = 5\n\$\$\n',
        );
      },
    );

    test('preserves coordinates and parentheses in prose untouched', () {
      const input =
          'Points (x_1, y_1), 3D (x_1, y_1, z_1), and negative (-x_1, y_2, -var_3).';
      expect(AiMarkdownSanitizer.sanitize(input), input);
    });

    test('preserves headings in prose untouched', () {
      const input = 'Some text\n### Heading';
      expect(AiMarkdownSanitizer.sanitize(input), input);
    });

    test('preserves headings with numbers and list-like text untouched', () {
      const input =
          '### Key Points  1. **Direction:** Text.  2. **Units:** Force.';
      expect(AiMarkdownSanitizer.sanitize(input), input);
    });

    group('negative tests (preserves valid markdown unaltered)', () {
      test(
        'does not break prose with double spaces before negative numbers or emphasis',
        () {
          const input =
              'The temperature was  -5 degrees and  *italic* emphasis.';
          expect(AiMarkdownSanitizer.sanitize(input), input);
        },
      );

      test('does not break headings with negative numbers or emphasis', () {
        const input = '# Heading  -5% change and  **bold** text';
        expect(AiMarkdownSanitizer.sanitize(input), input);
      });

      test(
        'does not swallow multiple paragraphs when escaped bracket is across paragraph boundary',
        () {
          const input =
              'Look at array\\[0 here.\n\nThen in this next paragraph check array 1\\].';
          expect(AiMarkdownSanitizer.sanitize(input), input);
        },
      );

      test('preserves tables and nested markdown structure untouched', () {
        const input = '''
| Header 1 | Header 2 |
| --- | --- |
| Row 1 - Note | Value |
''';
        expect(AiMarkdownSanitizer.sanitize(input), input);
      });

      test(
        'does not treat ordinary prose with hyphens or asterisks as list items',
        () {
          const input1 = 'value  - note';
          expect(AiMarkdownSanitizer.sanitize(input1), input1);

          const input2 = 'Here is a value  - note for reference.';
          expect(AiMarkdownSanitizer.sanitize(input2), input2);

          const input3 = 'Compute a  * b for multiplication.';
          expect(AiMarkdownSanitizer.sanitize(input3), input3);
        },
      );

      test('does not split math containing operators preceded by spaces', () {
        const input = r'Calculate $a  - b$ and $$c  * d$$.';
        expect(AiMarkdownSanitizer.sanitize(input), input);
      });

      test(
        'preserves escaped markdown brackets and parentheses without LaTeX math content',
        () {
          const input1 = r'Check array arr\[0\] in memory.';
          expect(AiMarkdownSanitizer.sanitize(input1), input1);

          const input2 = r'Escape item \[0\] used as markdown escape.';
          expect(AiMarkdownSanitizer.sanitize(input2), input2);

          const input3 = r'Read \[link\] documentation.';
          expect(AiMarkdownSanitizer.sanitize(input3), input3);

          const input4 = r'Call func\(x\) repeatedly.';
          expect(AiMarkdownSanitizer.sanitize(input4), input4);

          const input5 = r'Range \[a-b\] remains escaped bracket range.';
          expect(AiMarkdownSanitizer.sanitize(input5), input5);

          const input6 = r'Choose option \(and/or\) from list.';
          expect(AiMarkdownSanitizer.sanitize(input6), input6);

          const input7 = r'Option \(and/or\)';
          expect(AiMarkdownSanitizer.sanitize(input7), input7);
        },
      );

      test(
        'does not corrupt coordinates already inside math blocks or inline math',
        () {
          const input1 =
              r'Formula $a + (x_1, y_1) + b$ and $$c + (x_1, y_1) + d$$.';
          expect(AiMarkdownSanitizer.sanitize(input1), input1);

          const input2 = r'Simple $(x_1, y_1)$ inside inline math.';
          expect(AiMarkdownSanitizer.sanitize(input2), input2);
        },
      );

      test(
        'does not split headings containing hyphenated descriptions like Pros - cons or Title - note',
        () {
          const input1 = '# Pros  - cons';
          expect(AiMarkdownSanitizer.sanitize(input1), input1);

          const input2 = '# Title  - note';
          expect(AiMarkdownSanitizer.sanitize(input2), input2);
        },
      );
    });
  });
}
