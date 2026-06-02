import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/widgets/chapters_filter_tab_bar.dart';
import 'package:courses/widgets/chapters_filter_rules.dart';

void main() {
  group('ChaptersFilterRules tests', () {
    test('showExamTab is false - all filters should be visible', () {
      const config = ClientConfig(showExamTab: false);
      final visible = ChaptersFilterRules.getVisibleFilters(config);

      expect(visible, contains(CurriculumFilter.all));
      expect(visible, contains(CurriculumFilter.lesson));
      expect(visible, contains(CurriculumFilter.video));
      expect(visible, contains(CurriculumFilter.assessment));
      expect(visible, contains(CurriculumFilter.test));
      expect(visible.length, equals(5));
    });

    test('showExamTab is true - Assessments and Tests should be hidden', () {
      const config = ClientConfig(showExamTab: true);
      final visible = ChaptersFilterRules.getVisibleFilters(config);

      expect(visible, contains(CurriculumFilter.all));
      expect(visible, contains(CurriculumFilter.lesson));
      expect(visible, contains(CurriculumFilter.video));
      expect(visible, isNot(contains(CurriculumFilter.assessment)));
      expect(visible, isNot(contains(CurriculumFilter.test)));
      expect(visible.length, equals(3));
    });
  });
}
