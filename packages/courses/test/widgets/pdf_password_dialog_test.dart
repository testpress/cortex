import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/pdf_password_dialog.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: LocalizationProvider(
        child: Builder(
          builder: (context) {
            return WidgetsApp(
              color: const Color(0xFF000000),
              locale: const Locale('en'),
              localizationsDelegates: LocalizationProvider.delegates,
              pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (ctx, anim1, anim2) => builder(ctx),
              ),
              home: child,
            );
          },
        ),
      ),
    );
  }

  group('PdfPasswordDialog', () {
    testWidgets('renders title, description, input field, and buttons', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const PdfPasswordDialog()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Password Protected'), findsOneWidget);
      expect(
        find.text(
          'This document is password protected. Please enter the password to view.',
        ),
        findsOneWidget,
      );
      expect(find.byType(AppTextField), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Incorrect password. Please try again.'), findsNothing);
    });

    testWidgets('renders retry error text when isRetry is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const PdfPasswordDialog(isRetry: true)),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Incorrect password. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error when submitting empty password', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const PdfPasswordDialog()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Enter password'), findsWidgets);
    });

    testWidgets('toggles password visibility when eye icon tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const PdfPasswordDialog()),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(textField.obscureText, isTrue);

      // Tap show password toggle
      await tester.tap(find.byIcon(LucideIcons.eye));
      await tester.pumpAndSettle();

      final updatedTextField =
          tester.widget<AppTextField>(find.byType(AppTextField));
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('showPdfPasswordDialog returns entered password on Open', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return Center(
                child: AppButton.primary(
                  label: 'Launch Dialog',
                  onPressed: () async {
                    result = await showPdfPasswordDialog(context);
                  },
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Launch Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Password Protected'), findsOneWidget);

      // Enter password
      await tester.enterText(find.byType(EditableText), 'secret123');
      await tester.pumpAndSettle();

      // Tap Open
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(result, equals('secret123'));
    });

    testWidgets('showPdfPasswordDialog returns null on Cancel', (
      tester,
    ) async {
      String? result = 'initial';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return Center(
                child: AppButton.primary(
                  label: 'Launch Dialog',
                  onPressed: () async {
                    result = await showPdfPasswordDialog(context);
                  },
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Launch Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets(
      'showPdfPasswordDialog renders without overflow when keyboard is open in tablet landscape',
      (tester) async {
        tester.view.physicalSize = const Size(1006.6, 441.8);
        tester.view.devicePixelRatio = 1.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 250);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetViewInsets();
        });

        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) {
                return Center(
                  child: AppButton.primary(
                    label: 'Launch Dialog',
                    onPressed: () => showPdfPasswordDialog(context),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Launch Dialog'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Password Protected'), findsOneWidget);
        expect(find.byType(AppTextField), findsOneWidget);
      },
    );
  });
}
