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
    'AppMarkdown catches line break followed by # via fallback without parser error',
    (tester) async {
      const rawMarkdown = '''
\$\$
a = b \\\\
# line break then hash
\$\$
''';

      await tester.pumpWidget(buildSubject(rawMarkdown));
      await tester.pumpAndSettle();

      expect(find.textContaining('Parser Error'), findsNothing);
    },
  );
}
