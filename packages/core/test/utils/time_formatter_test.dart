import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/time_formatter.dart';

void main() {
  group('TimeFormatter.parseDuration', () {
    test('should parse mm:ss format correctly', () {
      expect(
        TimeFormatter.parseDuration('01:23'),
        const Duration(minutes: 1, seconds: 23),
      );
    });

    test('should parse hh:mm:ss format correctly', () {
      expect(
        TimeFormatter.parseDuration('01:23:45'),
        const Duration(hours: 1, minutes: 23, seconds: 45),
      );
    });

    test('should parse single seconds value format correctly', () {
      expect(TimeFormatter.parseDuration('45'), const Duration(seconds: 45));
    });

    test('should return zero duration for empty input', () {
      expect(TimeFormatter.parseDuration(''), Duration.zero);
    });

    test(
      'should parse sub-second decimal format correctly (Case 1: 00:00:01.500)',
      () {
        expect(
          TimeFormatter.parseDuration('00:00:01.500'),
          const Duration(seconds: 1, milliseconds: 500),
        );
      },
    );

    test(
      'should parse sub-second decimal format correctly (Case 2: 01:23.45)',
      () {
        expect(
          TimeFormatter.parseDuration('01:23.45'),
          const Duration(minutes: 1, seconds: 23, milliseconds: 450),
        );
      },
    );

    test('should handle padded/clipped sub-second inputs gracefully', () {
      expect(
        TimeFormatter.parseDuration('00:02.1'),
        const Duration(seconds: 2, milliseconds: 100),
      );
      expect(
        TimeFormatter.parseDuration('00:02.12345'),
        const Duration(seconds: 2, milliseconds: 123),
      );
    });
  });
}
