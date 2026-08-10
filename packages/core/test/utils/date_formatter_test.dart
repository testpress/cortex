import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:core/utils/date_formatter.dart';

void main() {
  group('DateFormatter.formatTimeAgo', () {
    test('should return just now for recent events', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(seconds: 30))),
        'just now',
      );
    });

    test('should format minutes ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(minutes: 5))),
        '5 mins ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(minutes: 1))),
        '1 min ago',
      );
    });

    test('should format hours ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(hours: 3))),
        '3 hrs ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(hours: 1))),
        '1 hr ago',
      );
    });

    test('should format days ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 3))),
        '3 days ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 1))),
        '1 day ago',
      );
    });

    test('should format weeks ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 15))),
        '2 weeks ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 8))),
        '1 week ago',
      );
    });

    test('should format months ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 60))),
        '2 months ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 31))),
        '1 month ago',
      );
    });

    test('should format years ago', () {
      final now = DateTime.now();
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 730))),
        '2 years ago',
      );
      expect(
        DateFormatter.formatTimeAgo(now.subtract(const Duration(days: 366))),
        '1 year ago',
      );
    });
  });

  group('DateFormatter.formatFullDate', () {
    test('should format dates as dd MMM yyyy', () {
      final date = DateTime(2026, 8, 10);
      expect(DateFormatter.formatFullDate(date), '10 Aug 2026');
    });
  });

  group('DateFormatter.formatDateTime', () {
    test('should format date and time as dd MMM yyyy, hh:mm a', () {
      final date = DateTime(2026, 8, 10, 11, 38);
      expect(DateFormatter.formatDateTime(date), '10 Aug 2026, 11:38 AM');
    });
  });

  group('DateFormatter.formatStartDateTime', () {
    test(
      'should parse and format ISO date strings with timezone independence',
      () {
        const startStr = '2026-08-11T10:42:35Z';
        final expected = DateFormat(
          'dd MMM yyyy, hh.mm a',
        ).format(DateTime.parse(startStr).toLocal());
        expect(DateFormatter.formatStartDateTime(startStr), expected);
      },
    );

    test('should return null for invalid inputs', () {
      expect(DateFormatter.formatStartDateTime(null), null);
      expect(DateFormatter.formatStartDateTime(''), null);
      expect(DateFormatter.formatStartDateTime('invalid-date'), null);
    });
  });
}
