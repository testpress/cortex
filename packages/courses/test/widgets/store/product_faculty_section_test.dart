import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_faculty_section.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: LocalizationProvider(
        child: Builder(
          builder: (context) {
            final locale = LocalizationProvider.of(context).locale;
            return Localizations(
              locale: locale,
              delegates: LocalizationProvider.delegates,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: SingleChildScrollView(child: child),
              ),
            );
          },
        ),
      ),
    );
  }

  const facultyWithVideo = ProductFacultyDto(
    id: 1,
    name: 'Dr. Ananya Rao',
    initials: 'AR',
    subjects: ['Polity', 'Governance'],
    shortDescription:
        'Former civil servant who teaches polity through landmark judgements.',
    yearsOfExperience: 14,
    videoUrl: 'https://example.com/intro.mp4',
  );

  const facultyWithoutVideo = ProductFacultyDto(
    id: 2,
    name: 'Kavya Iyer',
    initials: 'KI',
    subjects: ['Economy'],
    shortDescription: 'Economist who explains the budget in plain language.',
    yearsOfExperience: 9,
  );

  group('ProductFacultySection', () {
    testWidgets('renders nothing when faculty list is empty', (tester) async {
      await tester.pumpWidget(wrap(ProductFacultySection(
        faculty: const [],
        onSelectFaculty: (_) {},
      )));

      expect(find.text('Meet your faculty'), findsNothing);
    });

    testWidgets(
        'renders faculty cards with details, experience, and video badge',
        (tester) async {
      await tester.pumpWidget(wrap(ProductFacultySection(
        faculty: const [facultyWithVideo, facultyWithoutVideo],
        onSelectFaculty: (_) {},
      )));

      expect(find.text('Meet your faculty'), findsOneWidget);

      // Card 1
      expect(find.text('Dr. Ananya Rao'), findsOneWidget);
      expect(find.text('Polity · Governance'), findsOneWidget);
      expect(
          find.text(
              'Former civil servant who teaches polity through landmark judgements.'),
          findsOneWidget);
      expect(find.text('14 years teaching'), findsOneWidget);
      expect(find.text('Intro video'), findsOneWidget);

      // Card 2
      expect(find.text('Kavya Iyer'), findsOneWidget);
      expect(find.text('Economy'), findsOneWidget);
      expect(find.text('Economist who explains the budget in plain language.'),
          findsOneWidget);
      expect(find.text('9 years teaching'), findsOneWidget);
      // No video badge for faculty 2
      expect(find.text('Intro video'), findsOneWidget); // Only from card 1
    });

    testWidgets('calls onSelectFaculty when a card is tapped', (tester) async {
      ProductFacultyDto? selected;
      await tester.pumpWidget(wrap(ProductFacultySection(
        faculty: const [facultyWithVideo],
        onSelectFaculty: (f) => selected = f,
      )));

      await tester.tap(find.text('Dr. Ananya Rao'));
      expect(selected, equals(facultyWithVideo));
    });

    testWidgets(
        'limits cards to 4 and provides expand/collapse when > 4 faculty',
        (tester) async {
      final manyFaculty = List.generate(
        6,
        (i) => ProductFacultyDto(
          id: i + 1,
          name: 'Faculty Member ${i + 1}',
          subjects: ['Subject ${i + 1}'],
        ),
      );

      await tester.pumpWidget(wrap(ProductFacultySection(
        faculty: manyFaculty,
        onSelectFaculty: (_) {},
      )));

      // Initially shows first 4 cards
      expect(find.text('Faculty Member 1'), findsOneWidget);
      expect(find.text('Faculty Member 4'), findsOneWidget);
      expect(find.text('Faculty Member 5'), findsNothing);
      expect(find.text('Show all 6 faculty'), findsOneWidget);

      // Expand
      await tester.ensureVisible(find.text('Show all 6 faculty'));
      await tester.tap(find.text('Show all 6 faculty'));
      await tester.pumpAndSettle();

      expect(find.text('Faculty Member 5'), findsOneWidget);
      expect(find.text('Faculty Member 6'), findsOneWidget);
      expect(find.text('Show fewer'), findsOneWidget);

      // Collapse
      await tester.ensureVisible(find.text('Show fewer'));
      await tester.tap(find.text('Show fewer'));
      await tester.pumpAndSettle();

      expect(find.text('Faculty Member 5'), findsNothing);
      expect(find.text('Show all 6 faculty'), findsOneWidget);
    });
  });
}
