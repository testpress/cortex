import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Formatting and calculation helpers for ExamPrescreen.
class ExamPrescreenFormatter {
  const ExamPrescreenFormatter._();

  /// Formats exam or lesson duration (e.g. "03:00:00" -> ("180", "mins")).
  static ({String value, String? suffix}) formatDuration({
    required ExamDto? exam,
    required LessonDto? lesson,
    required bool isMetadataLoading,
  }) {
    String durationVal = isMetadataLoading ? '120' : '--';
    String? durationSuffix = isMetadataLoading ? 'mins' : null;

    if (exam?.duration != null || lesson?.duration != null) {
      final rawDuration = exam?.duration ?? lesson?.duration ?? '';
      final parts = rawDuration.split(':');
      if (parts.length == 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final mins = int.tryParse(parts[1]) ?? 0;
        final totalMinutes = (hours * 60) + mins;
        durationVal = '$totalMinutes';
        durationSuffix = 'mins';
      } else {
        final spaceParts = rawDuration.trim().split(' ');
        if (spaceParts.isNotEmpty) {
          durationVal = spaceParts[0];
          if (spaceParts.length > 1) {
            durationSuffix = spaceParts[1];
          } else {
            durationSuffix = 'mins';
          }
        }
      }
    }

    return (value: durationVal, suffix: durationSuffix);
  }

  /// Calculates total marks based on question count and mark per question.
  static String calculateTotalMarks({
    required ExamDto? exam,
    required bool isMetadataLoading,
  }) {
    if (isMetadataLoading) return '100';
    if (exam == null) return '--';

    final double mark = double.tryParse(exam.markPerQuestion ?? '') ?? 0.0;
    if (mark > 0 && exam.questionCount > 0) {
      final total = exam.questionCount * mark;
      return '${total % 1 == 0 ? total.toInt() : total}';
    } else if (exam.questionCount > 0) {
      return '${exam.questionCount}';
    }

    return '--';
  }

  /// Formats correct and negative marking scheme strings.
  static ({String correctMarks, String wrongMarks}) formatMarkingScheme({
    required ExamDto? exam,
    required bool isMetadataLoading,
  }) {
    if (isMetadataLoading) {
      return (correctMarks: '+1.0 Marks', wrongMarks: '-0.5 Marks');
    }
    if (exam == null) {
      return (correctMarks: '--', wrongMarks: '--');
    }

    final double mark = double.tryParse(exam.markPerQuestion ?? '') ?? 0.0;
    final String correctMarks = '+${mark % 1 == 0 ? mark.toInt() : mark} Marks';

    final double neg = double.tryParse(exam.negativeMarks ?? '') ?? 0.0;
    final String negVal = neg % 1 == 0
        ? neg.toInt().abs().toString()
        : neg.abs().toString();
    final String wrongMarks = neg == 0.0
        ? '0 Marks'
        : '-$negVal Mark${neg == 1.0 ? '' : 's'}';

    return (correctMarks: correctMarks, wrongMarks: wrongMarks);
  }

  /// Formats start and end dates into readable local date-time strings.
  static ({String startDate, String endDate}) formatDateRange({
    required ExamDto? exam,
    LessonDto? lesson,
    required bool isMetadataLoading,
  }) {
    if (isMetadataLoading) {
      return (
        startDate: 'Oct 14, 2024, 10:00 AM',
        endDate: 'Oct 14, 2024, 12:00 PM',
      );
    }

    final rawStart = exam?.startDate ?? lesson?.start;
    final rawEnd = exam?.endDate ?? lesson?.end;

    String startDateStr = '';
    String endDateStr = '';

    if (rawStart != null || rawEnd != null) {
      final parsedStart = rawStart != null
          ? DateTime.tryParse(rawStart)?.toLocal()
          : null;
      final parsedEnd = rawEnd != null
          ? DateTime.tryParse(rawEnd)?.toLocal()
          : null;

      startDateStr = parsedStart != null
          ? DateFormatter.formatDateTime(parsedStart)
          : (rawStart != null ? 'N/A' : 'N/A');
      endDateStr = parsedEnd != null
          ? DateFormatter.formatDateTime(parsedEnd)
          : (rawEnd != null ? 'N/A' : 'N/A');
    }

    return (startDate: startDateStr, endDate: endDateStr);
  }
}
