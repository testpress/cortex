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

  group('TimeFormatter.formatDurationToMinutes', () {
    test('should format minutes-only strings', () {
      expect(TimeFormatter.formatDurationToMinutes('45 min'), '45 minutes');
      expect(TimeFormatter.formatDurationToMinutes('30m'), '30 minutes');
    });

    test('should format hours-only strings', () {
      expect(TimeFormatter.formatDurationToMinutes('1h'), '60 minutes');
      expect(TimeFormatter.formatDurationToMinutes('2 h'), '120 minutes');
    });

    test('should format combined hours and minutes strings', () {
      expect(TimeFormatter.formatDurationToMinutes('1h 30m'), '90 minutes');
      expect(TimeFormatter.formatDurationToMinutes('2h 45min'), '165 minutes');
    });

    test('should format raw numeric minute values', () {
      expect(TimeFormatter.formatDurationToMinutes('60'), '60 minutes');
      expect(TimeFormatter.formatDurationToMinutes('90.5'), '90 minutes');
    });

    test('should format hh:mm:ss duration format', () {
      expect(TimeFormatter.formatDurationToMinutes('01:20:00'), '80 minutes');
    });

    test('should return null for invalid or empty duration input', () {
      expect(TimeFormatter.formatDurationToMinutes(null), null);
      expect(TimeFormatter.formatDurationToMinutes(''), null);
      expect(TimeFormatter.formatDurationToMinutes('abc'), null);
    });
  });

  group('TimeFormatter.formatDuration', () {
    test('should format raw decimal seconds (e.g. 51.0 -> 51s)', () {
      expect(TimeFormatter.formatDuration('51.0'), '51s');
    });

    test(
      'should format raw floating point seconds (e.g. 7188.653453 -> 1h 59m)',
      () {
        expect(TimeFormatter.formatDuration('7188.653453'), '1h 59m');
      },
    );

    test(
      'should format raw integer seconds (e.g. 120 -> 2 min, 3600 -> 1h)',
      () {
        expect(TimeFormatter.formatDuration('120'), '2 min');
        expect(TimeFormatter.formatDuration('3600'), '1h');
      },
    );

    test('should preserve already formatted strings', () {
      expect(TimeFormatter.formatDuration('45m'), '45m');
      expect(TimeFormatter.formatDuration('1h 30m'), '1h 30m');
    });

    test('should return null for invalid or zero inputs', () {
      expect(TimeFormatter.formatDuration(null), null);
      expect(TimeFormatter.formatDuration('0'), null);
      expect(TimeFormatter.formatDuration('00:00'), null);
    });
  });
}
