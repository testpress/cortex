import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExamDto.fromJson and toJson', () {
    test('parses allow_preemptive_section_ending when true', () {
      final json = <String, dynamic>{
        'id': 45684,
        'title': 'RRB CLERK PRELIMS',
        'duration': '0:45:00',
        'allow_preemptive_section_ending': true,
      };

      final dto = ExamDto.fromJson(json);

      expect(dto.id, '45684');
      expect(dto.allowPreemptiveSectionEnding, isTrue);
      expect(dto.toJson()['allow_preemptive_section_ending'], isTrue);
    });

    test('parses allow_preemptive_section_ending when false', () {
      final json = <String, dynamic>{
        'id': 45684,
        'title': 'RRB CLERK PRELIMS',
        'duration': '0:45:00',
        'allow_preemptive_section_ending': false,
      };

      final dto = ExamDto.fromJson(json);

      expect(dto.allowPreemptiveSectionEnding, isFalse);
      expect(dto.toJson()['allow_preemptive_section_ending'], isFalse);
    });

    test(
      'defaults allow_preemptive_section_ending to false when missing or null',
      () {
        final json = <String, dynamic>{
          'id': 45684,
          'title': 'RRB CLERK PRELIMS',
          'duration': '0:45:00',
        };

        final dto = ExamDto.fromJson(json);

        expect(dto.allowPreemptiveSectionEnding, isFalse);
        expect(dto.toJson()['allow_preemptive_section_ending'], isFalse);
      },
    );
  });
}
