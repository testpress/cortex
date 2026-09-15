import 'package:core/data/data.dart';
import 'package:exams/utils/exam_prescreen_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

ExamDto _createExam({
  String duration = '01:00:00',
  int questionCount = 10,
  String? markPerQuestion,
  String? negativeMarks,
  String? startDate,
  String? endDate,
}) {
  return ExamDto(
    id: '1',
    title: 'Test Exam',
    duration: duration,
    questionCount: questionCount,
    attemptsUrl: 'https://example.com/attempts',
    markPerQuestion: markPerQuestion,
    negativeMarks: negativeMarks,
    startDate: startDate,
    endDate: endDate,
  );
}

LessonDto _createLesson({String duration = '30 mins'}) {
  return LessonDto(
    id: '1',
    chapterId: '1',
    title: 'Test Lesson',
    type: LessonType.test,
    duration: duration,
    progressStatus: LessonProgressStatus.notStarted,
    isLocked: false,
    orderIndex: 0,
  );
}

void main() {
  group('ExamPrescreenFormatter', () {
    group('formatDuration', () {
      test('returns loading fallback when isMetadataLoading is true', () {
        final result = ExamPrescreenFormatter.formatDuration(
          exam: null,
          lesson: null,
          isMetadataLoading: true,
        );
        expect(result.value, '120');
        expect(result.suffix, 'mins');
      });

      test('returns placeholder when exam and lesson have no duration', () {
        final result = ExamPrescreenFormatter.formatDuration(
          exam: null,
          lesson: null,
          isMetadataLoading: false,
        );
        expect(result.value, '--');
        expect(result.suffix, isNull);
      });

      test('parses hh:mm:ss format correctly', () {
        final exam = _createExam(duration: '02:30:00');
        final result = ExamPrescreenFormatter.formatDuration(
          exam: exam,
          lesson: null,
          isMetadataLoading: false,
        );
        expect(result.value, '150');
        expect(result.suffix, 'mins');
      });

      test('parses space-separated duration string', () {
        final lesson = _createLesson(duration: '45 mins');
        final result = ExamPrescreenFormatter.formatDuration(
          exam: null,
          lesson: lesson,
          isMetadataLoading: false,
        );
        expect(result.value, '45');
        expect(result.suffix, 'mins');
      });
    });

    group('calculateTotalMarks', () {
      test('returns 100 when loading', () {
        final result = ExamPrescreenFormatter.calculateTotalMarks(
          exam: null,
          isMetadataLoading: true,
        );
        expect(result, '100');
      });

      test('calculates total marks with decimal correctly', () {
        final exam = _createExam(questionCount: 10, markPerQuestion: '2.5');
        final result = ExamPrescreenFormatter.calculateTotalMarks(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result, '25');
      });

      test('calculates total marks with fractional result', () {
        final exam = _createExam(questionCount: 3, markPerQuestion: '1.25');
        final result = ExamPrescreenFormatter.calculateTotalMarks(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result, '3.75');
      });

      test('falls back to questionCount when markPerQuestion is not set', () {
        final exam = _createExam(questionCount: 50);
        final result = ExamPrescreenFormatter.calculateTotalMarks(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result, '50');
      });
    });

    group('formatMarkingScheme', () {
      test('returns default shimmer values when loading', () {
        final result = ExamPrescreenFormatter.formatMarkingScheme(
          exam: null,
          isMetadataLoading: true,
        );
        expect(result.correctMarks, '+1.0 Marks');
        expect(result.wrongMarks, '-0.5 Marks');
      });

      test('formats correct and negative marks correctly', () {
        final exam = _createExam(markPerQuestion: '4.0', negativeMarks: '1.0');
        final result = ExamPrescreenFormatter.formatMarkingScheme(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result.correctMarks, '+4 Marks');
        expect(result.wrongMarks, '-1 Mark');
      });

      test('formats zero negative marks without minus sign', () {
        final exam = _createExam(markPerQuestion: '2', negativeMarks: '0.0');
        final result = ExamPrescreenFormatter.formatMarkingScheme(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result.correctMarks, '+2 Marks');
        expect(result.wrongMarks, '0 Marks');
      });
    });

    group('formatDateRange', () {
      test('returns loading dummy dates when loading', () {
        final result = ExamPrescreenFormatter.formatDateRange(
          exam: null,
          isMetadataLoading: true,
        );
        expect(result.startDate, 'Oct 14, 2024, 10:00 AM');
        expect(result.endDate, 'Oct 14, 2024, 12:00 PM');
      });

      test('formats dates when present', () {
        final exam = _createExam(
          startDate: '2026-10-14T04:30:00.000Z',
          endDate: '2026-10-14T06:30:00.000Z',
        );
        final result = ExamPrescreenFormatter.formatDateRange(
          exam: exam,
          isMetadataLoading: false,
        );
        expect(result.startDate, isNotEmpty);
        expect(result.endDate, isNotEmpty);
      });
    });
  });
}
