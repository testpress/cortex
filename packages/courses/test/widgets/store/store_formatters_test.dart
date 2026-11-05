import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/store/store_formatters.dart';

void main() {
  group('formatPlanDuration Tests', () {
    test('formats days correctly when duration is less than 365', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(formatPlanDuration(l10n, 30), '30 days');
      expect(formatPlanDuration(l10n, 90), '90 days');
      expect(formatPlanDuration(l10n, 180), '180 days');
    });

    test('formats exact year multiples correctly', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(formatPlanDuration(l10n, 365), '1 year');
      expect(formatPlanDuration(l10n, 730), '2 years');
    });

    test('formats days when duration >= 365 but not an exact year multiple',
        () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(formatPlanDuration(l10n, 400), '400 days');
    });
  });
}
