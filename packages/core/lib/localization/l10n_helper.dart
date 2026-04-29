import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../generated/l10n/app_localizations.dart';

/// Convenience accessor for localization.
///
/// Usage:
/// ```dart
/// final l10n = L10n.of(context);
/// Text(l10n.loginButton)
/// ```
class L10n {
  L10n._();

  static AppLocalizations of(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    assert(
      l10n != null,
      'No AppLocalizations found in context. Ensure LocalizationProvider is at the root.',
    );
    return l10n!;
  }
}

extension AppLocalizationsX on AppLocalizations {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return greetingMorning;
    if (hour < 17) return greetingAfternoon;
    return greetingEvening;
  }

  String getTodayDate() {
    // Uses the standard locale for now. You might pass the localName from AppLocalizations
    // if full localization of dates is required, e.g. DateFormat('EEEE · MMM d', localeName)
    return DateFormat('EEEE · MMM d').format(DateTime.now());
  }
}
