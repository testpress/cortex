import 'dart:async';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/screens/edit_profile_screen.dart';

class MockAuth extends Auth {
  @override
  FutureOr<bool> build() {
    return true;
  }
}

class MockUserActionsController extends UserActionsController {
  Future<void> Function({
    String? firstName,
    String? lastName,
    String? phone,
    String? photo,
  })?
  onUpdateProfile;

  @override
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? photo,
  }) async {
    if (onUpdateProfile != null) {
      await onUpdateProfile!(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        photo: photo,
      );
    }
  }
}

void main() {
  late MockUserActionsController mockUserActionsController;

  setUp(() {
    mockUserActionsController = MockUserActionsController();
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith(MockAuth.new),
        userProvider.overrideWith(
          (ref) => Stream.value(
            const UsersTableData(
              id: '1',
              firstName: 'Test',
              lastName: 'User',
              email: 'test@example.com',
              phone: '1234567890',
            ),
          ),
        ),
        userActionsControllerProvider.overrideWith(
          () => mockUserActionsController,
        ),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return MaterialApp(
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
                home: child,
              );
            },
          ),
        ),
      ),
    );
  }

  group('EditProfileScreen validation', () {
    testWidgets('shows inline field error when API returns phone validation error', (
      tester,
    ) async {
      mockUserActionsController
          .onUpdateProfile = ({firstName, lastName, phone, photo}) async {
        throw const ApiException(
          'Validation error',
          statusCode: 400,
          data: {
            'phone': [
              "Phone number must be entered in the format: '999999999'. Only 10 digits allowed.",
            ],
          },
        );
      };

      await tester.pumpWidget(wrap(const EditProfileScreen()));
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileFirstNameLabel),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileLastNameLabel),
        'User',
      );
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text(l10n.editProfileSave));
      await tester.pumpAndSettle();

      // Inline error for phone should be present
      expect(
        find.text(
          "Phone number must be entered in the format: '999999999'. Only 10 digits allowed.",
        ),
        findsOneWidget,
      );

      // Top banner with general error should NOT be shown
      expect(find.text('Validation error'), findsNothing);

      // Type in the phone field should clear the inline error
      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfilePhoneLabel),
        '9876543210',
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          "Phone number must be entered in the format: '999999999'. Only 10 digits allowed.",
        ),
        findsNothing,
      );
    });

    testWidgets('shows top error banner for non-field errors', (tester) async {
      mockUserActionsController.onUpdateProfile =
          ({firstName, lastName, phone, photo}) async {
            throw const ApiException(
              'Server could not process your request',
              statusCode: 400,
              data: {
                'non_field_errors': ['Server could not process your request'],
              },
            );
          };

      await tester.pumpWidget(wrap(const EditProfileScreen()));
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileFirstNameLabel),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileLastNameLabel),
        'User',
      );
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text(l10n.editProfileSave));
      await tester.pumpAndSettle();

      expect(
        find.text('Server could not process your request'),
        findsOneWidget,
      );
    });
  });
}
