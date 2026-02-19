import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../generated/l10n/app_localizations.dart';

class LocalizationProvider extends StatefulWidget {
  const LocalizationProvider({
    super.key,
    this.initialLocale = const Locale('en'),
    required this.child,
  });

  final Locale initialLocale;
  final Widget child;

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();

  static LocalizationProviderScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_LocalizationProviderInherited>();
    assert(scope != null, 'No LocalizationProvider found in context');
    return scope!.state;
  }

  /// Helper for root app configuration.
  static List<LocalizationsDelegate<dynamic>> get delegates => const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Helper for supported locales.
  static Iterable<Locale> get supportedLocales =>
      AppLocalizations.supportedLocales;
}

abstract class LocalizationProviderScope {
  Locale get locale;
  void setLocale(Locale locale);
}

class _LocalizationProviderState extends State<LocalizationProvider>
    implements LocalizationProviderScope {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  @override
  Locale get locale => _locale;

  @override
  void setLocale(Locale locale) {
    if (_locale != locale) {
      setState(() {
        _locale = locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LocalizationProviderInherited(
      state: this,
      locale: _locale,
      child: widget.child,
    );
  }
}

class _LocalizationProviderInherited extends InheritedWidget {
  const _LocalizationProviderInherited({
    required this.state,
    required this.locale,
    required super.child,
  });

  final _LocalizationProviderState state;
  final Locale locale;

  @override
  bool updateShouldNotify(_LocalizationProviderInherited oldWidget) {
    return locale != oldWidget.locale;
  }
}
