import 'package:flutter/widgets.dart';
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
