import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('Internationalization Support', () {
    testWidgets('Localized strings and directionality update on locale switch', (
      tester,
    ) async {
      await tester.pumpWidget(
        LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return Directionality(
                textDirection: locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Localizations(
                  locale: locale,
                  delegates: LocalizationProvider.delegates,
                  child: Builder(
                    builder: (context) {
                      final l10n = L10n.of(context);
                      return Center(child: Text(l10n.welcomeMessage));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initial English
      expect(find.text('Welcome to Cortex'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('Welcome to Cortex'))),
        TextDirection.ltr,
      );

      // Switch to Arabic
      final provider = LocalizationProvider.of(
        tester.element(find.text('Welcome to Cortex')),
      );
      provider.setLocale(const Locale('ar'));

      // We need to pump until no more frames are scheduled
      await tester.pumpAndSettle();

      // Debug: find all Text widgets and print their content
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final text in textWidgets) {
        print('DEBUG: Found Text widget with: ${text.data}');
      }

      // Should be Arabic (RTL)
      // Check for the Arabic text directly in the widget list if find.text continues to fail
      bool foundArabic = false;
      for (final text in textWidgets) {
        if (text.data == 'مرحبًا بك في كورتيكس') {
          foundArabic = true;
          break;
        }
      }
      expect(
        foundArabic,
        isTrue,
        reason: 'Arabic welcome message not found in Text widgets',
      );

      final BuildContext arabicContext = tester.element(find.byType(Text));
      expect(Directionality.of(arabicContext), TextDirection.rtl);
    });
  });
}
