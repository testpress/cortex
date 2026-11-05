import 'package:core/core.dart';

/// Formats a duration in days into a localized string (e.g. "1 year" or "90 days").
String formatPlanDuration(AppLocalizations l10n, int durationInDays) {
  if (durationInDays >= 365 && durationInDays % 365 == 0) {
    return l10n.storeDurationYears(durationInDays ~/ 365);
  }
  return l10n.storeDurationDays(durationInDays);
}

/// Extension on [AppLocalizations] for convenient plan duration formatting.
extension StoreDurationFormatting on AppLocalizations {
  String formatPlanDuration(int durationInDays) {
    if (durationInDays >= 365 && durationInDays % 365 == 0) {
      return storeDurationYears(durationInDays ~/ 365);
    }
    return storeDurationDays(durationInDays);
  }
}
