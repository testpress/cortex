import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject(String markdown) {
    return MaterialApp(
      home: Scaffold(
        body: DesignProvider(
          config: DesignConfig.defaults(),
          child: AppMarkdown(data: markdown),
        ),
      ),
    );
  }

  testWidgets('AppMarkdown renders math with # without parser error', (
    tester,
  ) async {
    const rawMarkdown = '''
A simple representation is:

\$\$
Reactants -> Products # comment
\$\$
''';

    await tester.pumpWidget(buildSubject(rawMarkdown));
    await tester.pumpAndSettle();

    expect(find.textContaining('Parser Error'), findsNothing);
  });

  testWidgets('AppMarkdown renders unclosed math without parser error', (
    tester,
  ) async {
    const rawMarkdown = '''
- A simple representation is:

\$\$
# Chemical Equation
''';

    await tester.pumpWidget(buildSubject(rawMarkdown));
    await tester.pumpAndSettle();

    expect(find.textContaining('Parser Error'), findsNothing);
  });

  testWidgets(
    'AppMarkdown renders standard markdown elements without alteration',
    (tester) async {
      const rawMarkdown = '''
# Heading 1
## Heading 2
### Heading 3

This is **bold text** and *italic text* and `inline code`.

- Item 1
- Item 2
  - Sub-item A

1. First ordered
2. Second ordered

> This is a blockquote.

The price is \$50 and total is \$100.
''';

      await tester.pumpWidget(buildSubject(rawMarkdown));
      await tester.pumpAndSettle();

      expect(find.textContaining('Heading 1'), findsOneWidget);
      expect(find.textContaining('bold text'), findsOneWidget);
      expect(find.textContaining('Sub-item A'), findsOneWidget);
      expect(find.textContaining('The price is'), findsOneWidget);
      expect(find.textContaining('Parser Error'), findsNothing);
    },
  );

  testWidgets(
    'AppMarkdown renders indented math formulas followed by lists and headings without swallowing text',
    (tester) async {
      const rawMarkdown = '''
### 3. Properties and Theorems:
- **Pythagorean Theorem:** In a right triangle:
  \$\$ c^2 = a^2 + b^2 \$\$

- **Angle Relationships:** Complementary angles add up to 90 degrees.

### 4. Coordinate Geometry:
- **Distance Formula:** To find the distance between two points (x_1, y_1) and (x_2, y_2):
  \$\$ d = \\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2} \$\$
- **Midpoint Formula:** To find the midpoint M of the line segment joining points A and B:
  \$\$ M = \\left( \\frac{x_1 + x_2}{2}, \\frac{y_1 + y_2}{2} \\right) \$\$

### Conclusion:
Geometry plays a crucial role.
''';

      await tester.pumpWidget(buildSubject(rawMarkdown));
      await tester.pumpAndSettle();

      // Check that standard text after indented math was NOT swallowed into LaTeX
      expect(find.textContaining('Angle Relationships'), findsOneWidget);
      expect(find.textContaining('Coordinate Geometry'), findsOneWidget);
      expect(find.textContaining('Conclusion'), findsOneWidget);
      expect(
        find.textContaining('Geometry plays a crucial role.'),
        findsOneWidget,
      );
      expect(find.textContaining('Parser Error'), findsNothing);
    },
  );
}
