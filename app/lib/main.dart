import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testpress/testpress.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  setAppStateContainer(container);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CortexAppRoot(),
    ),
  );
}

/// Root widget with mutable DesignConfig for hot reload testing.
///
/// To test runtime design changes:
/// 1. Change the primary color below
/// 2. Save the file (hot reload)
/// 3. See the UI update immediately
class CortexAppRoot extends ConsumerWidget {
  const CortexAppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🚀 BOOTSTRAP: Kick off app initialization (data seeding, etc.)
    ref.watch(appInitializationProvider);

    // 🎨 DARK MODE SUPPORT: Both configs are now passed to DesignProvider.
    final lightConfig = DesignConfig.light();
    final darkConfig = DesignConfig.dark();
    final mode = ref.watch(designModeProvider);

    // 🌍 LOCALIZATION SUPPORT: Wrapping the root with LocalizationProvider.
    return LocalizationProvider(
      child: DesignProvider(
        config: lightConfig,
        darkConfig: darkConfig,
        mode: mode,
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

    return MaterialApp.router(
      title: 'Cortex',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: LocalizationProvider.delegates,
      supportedLocales: LocalizationProvider.supportedLocales,
      routerConfig: appRouter,
      // Set Plus Jakarta Sans on the Material theme so widgets that still
      // use Material's text theme (Scaffold, SnackBar, etc.) also use it.
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        scaffoldBackgroundColor: design.colors.canvas,
        canvasColor: design.colors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: design.colors.primary,
          surface: design.colors.surface,
          brightness: design.isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      builder: (context, child) {
        return DefaultTextStyle(
          style: design.typography.body.copyWith(
            color: design.colors.textPrimary,
            decoration: TextDecoration.none,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
