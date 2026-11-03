import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_faculty_summary.dart';
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
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  const faculty1 = ProductFacultyDto(
    id: 1,
    name: 'Dr. Ananya Rao',
    initials: 'AR',
    subjects: ['Polity'],
  );

  const faculty2 = ProductFacultyDto(
    id: 2,
    name: 'Rahul Mehta',
    initials: 'RM',
    subjects: ['History'],
  );

  const faculty3 = ProductFacultyDto(
    id: 3,
    name: 'Kavya Iyer',
    initials: 'KI',
    subjects: ['Economy'],
  );

  group('ProductFacultySummary', () {
    testWidgets('renders nothing when faculty list is empty', (tester) async {
      await tester.pumpWidget(wrap(const ProductFacultySummary(faculty: [])));
      expect(find.byType(ProductFacultySummary), findsOneWidget);
      expect(find.textContaining('Taught by'), findsNothing);
    });

    testWidgets('renders single instructor without "and more"', (tester) async {
      await tester.pumpWidget(wrap(const ProductFacultySummary(
        faculty: [faculty1],
      )));

      expect(find.text('Taught by Dr. Ananya Rao'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
    });

    testWidgets('renders instructor name and count for multiple instructors',
        (tester) async {
      await tester.pumpWidget(wrap(const ProductFacultySummary(
        faculty: [faculty1, faculty2, faculty3],
      )));

      expect(find.text('Taught by Dr. Ananya Rao and 2 more'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
      expect(find.text('RM'), findsOneWidget);
      expect(find.text('KI'), findsOneWidget);
    });

    testWidgets('invokes onTap callback when tapped and meets touch target',
        (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrap(ProductFacultySummary(
        faculty: const [faculty1],
        onTap: () => tapped = true,
      )));

      final rowFinder = find.byType(ProductFacultySummary);
      expect(tester.getSize(rowFinder).height, greaterThanOrEqualTo(48.0));

      await tester.tap(rowFinder);
      expect(tapped, isTrue);
    });
  });
}
