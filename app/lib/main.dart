import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testpress/course_list.dart';
import 'package:core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CortexAppRoot()));
}

/// Root widget with mutable DesignConfig for hot reload testing.
///
/// To test runtime design changes:
/// 1. Change the primary color below
/// 2. Save the file (hot reload)
/// 3. See the UI update immediately
class CortexAppRoot extends StatefulWidget {
  const CortexAppRoot({super.key});

  @override
  State<CortexAppRoot> createState() => _CortexAppRootState();
}

class _CortexAppRootState extends State<CortexAppRoot> {
  @override
  Widget build(BuildContext context) {
    // 🎨 DARK MODE SUPPORT: Both configs are now passed to DesignProvider.
    final lightConfig = DesignConfig.light();
    final darkConfig = DesignConfig.dark();

    // 🌍 LOCALIZATION SUPPORT: Wrapping the root with LocalizationProvider.
    return LocalizationProvider(
      child: DesignProvider(
        config: lightConfig,
        darkConfig: darkConfig,
        mode: DesignMode.system,
        child: const CortexApp(),
      ),
    );
  }
}

/// Cortex reference application.
class CortexApp extends StatelessWidget {
  const CortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final localization = LocalizationProvider.of(context);
    final locale = localization.locale;

    return MaterialApp(
      title: 'Cortex',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: LocalizationProvider.delegates,
      supportedLocales: LocalizationProvider.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = L10n.of(context);
          return DefaultTextStyle(
            style: design.typography.body.copyWith(
              color: design.colors.textPrimary,
              decoration: TextDecoration.none,
            ),
            child: Column(
              children: [
                AppHeader(
                  title: l10n.appTitle,
                  subtitle: l10n.welcomeMessage,
                  actions: [
                    AppButton.secondary(
                      label: _getLanguageLabel(locale.languageCode),
                      onPressed: () {
                        final nextLocale = _getNextLocale(locale.languageCode);
                        localization.setLocale(nextLocale);
                      },
                    ),
                  ],
                ),
                const Expanded(child: CourseListScreen()),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getLanguageLabel(String code) {
    switch (code) {
      case 'ar':
        return 'മലയാളം';
      case 'ml':
        return 'English';
      default:
        return 'العربية';
    }
  }

  Locale _getNextLocale(String code) {
    switch (code) {
      case 'ar':
        return const Locale('ml');
      case 'ml':
        return const Locale('en');
      default:
        return const Locale('ar');
    }
  }
}
