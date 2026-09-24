import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/app_error_view.dart';
import 'package:core/data/exceptions/api_exception.dart';
import 'package:core/design/design_provider.dart';
import 'package:core/design/design_config.dart';
import 'package:core/generated/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: child),
      ),
    );
  }

  group('AppErrorView', () {
    testWidgets('renders generic title and message when error is unknown', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(AppErrorView(error: Exception('Some unknown error'))),
      );

      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(
        find.text(
          'Failed to load data. Please check your connection and try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders specific title when error is ApiException noInternet',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppErrorView(
              error: const ApiException(
                'No connection',
                type: ApiErrorType.noInternet,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should pick up the 'Connection Error' title from app_en.arb
        expect(find.text('Connection Error'), findsOneWidget);
        expect(find.text('No connection'), findsOneWidget);
      },
    );

    testWidgets(
      'renders specific title when error is ApiException unauthorized',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppErrorView(
              error: const ApiException(
                'Token expired',
                type: ApiErrorType.unauthorized,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Session Expired'), findsOneWidget);
        expect(find.text('Token expired'), findsOneWidget);
      },
    );

    testWidgets(
      'renders overridden title and message when explicitly provided',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppErrorView(
              title: 'Custom Title',
              message: 'Custom Message',
              error: const ApiException(
                'No connection',
                type: ApiErrorType.noInternet,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Custom Title'), findsOneWidget);
        expect(find.text('Custom Message'), findsOneWidget);
      },
    );

    testWidgets('handles async onRetry that throws without unhandled exception', (
      tester,
    ) async {
      var retryCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          AppErrorView(
            error: const ApiException(
              'This chapter belongs to a course which can be accessed only from web.',
              type: ApiErrorType.forbidden,
            ),
            onRetry: () async {
              retryCalled = true;
              throw const ApiException(
                'This chapter belongs to a course which can be accessed only from web.',
                type: ApiErrorType.forbidden,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Access Denied'), findsOneWidget);

      // Tap Retry
      await tester.tap(find.text('Retry'));
      await tester.pump(); // Start async operation

      expect(retryCalled, isTrue);

      await tester.pumpAndSettle(); // Await completion of future and setState

      // Still renders error view cleanly without unhandled exception
      expect(find.text('Access Denied'), findsOneWidget);
      expect(
        find.text(
          'This chapter belongs to a course which can be accessed only from web.',
        ),
        findsOneWidget,
      );
    });
  });
}
