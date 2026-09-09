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
    bool removePhoto,
  })?
  onUpdateProfile;

  @override
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? photo,
    bool removePhoto = false,
  }) async {
    if (onUpdateProfile != null) {
      await onUpdateProfile!(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        photo: photo,
        removePhoto: removePhoto,
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
      mockUserActionsController.onUpdateProfile =
          ({firstName, lastName, phone, photo, removePhoto = false}) async {
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
          ({firstName, lastName, phone, photo, removePhoto = false}) async {
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

    testWidgets(
      'tapping avatar opens bottom sheet with options and handles removal',
      (tester) async {
        bool? savedRemovePhoto;

        mockUserActionsController.onUpdateProfile =
            ({firstName, lastName, phone, photo, removePhoto = false}) async {
              savedRemovePhoto = removePhoto;
            };

        await tester.pumpWidget(
          ProviderScope(
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
                    avatar: 'https://example.com/avatar.jpg',
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
                      home: const EditProfileScreen(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

        // Pencil icon and semantic button should be rendered
        expect(find.byIcon(LucideIcons.pencil), findsOneWidget);
        expect(
          find.bySemanticsLabel(l10n.editProfileChangePhoto),
          findsOneWidget,
        );

        // Dedicated change photo text button should NOT exist
        expect(find.text(l10n.editProfileChangePhoto), findsNothing);

        // Tap the avatar
        await tester.tap(find.byIcon(LucideIcons.pencil));
        await tester.pumpAndSettle();

        // Bottom sheet should be visible with options and semantics
        expect(find.text(l10n.editProfileAvatarSheetTitle), findsOneWidget);
        expect(find.text(l10n.editProfileCamera), findsOneWidget);
        expect(find.text(l10n.editProfileGallery), findsOneWidget);
        expect(find.text(l10n.editProfileRemovePhoto), findsOneWidget);

        bool hasButtonSemantics(String label) => find
            .byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  w.properties.button == true &&
                  w.properties.label == label,
            )
            .evaluate()
            .isNotEmpty;

        expect(hasButtonSemantics(l10n.editProfileCamera), isTrue);
        expect(hasButtonSemantics(l10n.editProfileGallery), isTrue);
        expect(hasButtonSemantics(l10n.editProfileRemovePhoto), isTrue);

        // Tap Remove Photo
        await tester.tap(find.text(l10n.editProfileRemovePhoto));
        await tester.pumpAndSettle();

        // Sheet dismissed and fallback initials "TU" is shown
        expect(find.text(l10n.editProfileAvatarSheetTitle), findsNothing);
        expect(find.text('TU'), findsOneWidget);

        // Tap Save
        await tester.tap(find.text(l10n.editProfileSave));
        await tester.pumpAndSettle();

        expect(savedRemovePhoto, isTrue);
      },
    );

    testWidgets('allows saving with empty last name', (tester) async {
      String? savedLastName;

      mockUserActionsController.onUpdateProfile =
          ({firstName, lastName, phone, photo, removePhoto = false}) async {
            savedLastName = lastName;
          };

      await tester.pumpWidget(wrap(const EditProfileScreen()));
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileFirstNameLabel),
        'SingleName',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, l10n.editProfileLastNameLabel),
        '',
      );
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text(l10n.editProfileSave));
      await tester.pumpAndSettle();

      expect(savedLastName, '');
      expect(find.text(l10n.editProfileErrorNameEmpty), findsNothing);
    });

    testWidgets(
      'does not show remove photo option when user has default backend image',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(MockAuth.new),
              userProvider.overrideWith(
                (ref) => Stream.value(
                  const UsersTableData(
                    id: '1',
                    name: 'Test User',
                    firstName: 'Test',
                    lastName: 'User',
                    email: 'test@example.com',
                    phone: '1234567890',
                    avatar:
                        'https://static.testpress.in/static/img/default_medium_image.png',
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
                      home: const EditProfileScreen(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

        // Tap avatar to open bottom sheet
        await tester.tap(find.byIcon(LucideIcons.pencil));
        await tester.pumpAndSettle();

        // Should show Camera and Gallery, but NOT Remove Photo
        expect(find.text(l10n.editProfileAvatarSheetTitle), findsOneWidget);
        expect(find.text(l10n.editProfileCamera), findsOneWidget);
        expect(find.text(l10n.editProfileGallery), findsOneWidget);
        expect(find.text(l10n.editProfileRemovePhoto), findsNothing);
      },
    );

    testWidgets(
      'does not repopulate intentionally blank fields on subsequent userProvider emissions',
      (tester) async {
        final userStreamController =
            StreamController<UsersTableData?>.broadcast();
        addTearDown(userStreamController.close);

        const initialUser = UsersTableData(
          id: '1',
          name: 'John Doe',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          phone: '1234567890',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(MockAuth.new),
              userProvider.overrideWith((ref) => userStreamController.stream),
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
                      home: const EditProfileScreen(),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Emit initial user data
        userStreamController.add(initialUser);
        await tester.pumpAndSettle();

        final l10n = L10n.of(tester.element(find.byType(EditProfileScreen)));

        final firstNameField = find.widgetWithText(
          AppTextField,
          l10n.editProfileFirstNameLabel,
        );
        final lastNameField = find.widgetWithText(
          AppTextField,
          l10n.editProfileLastNameLabel,
        );

        // Initial text should be populated from initialUser
        expect(
          tester.widget<AppTextField>(firstNameField).controller?.text,
          'John',
        );
        expect(
          tester.widget<AppTextField>(lastNameField).controller?.text,
          'Doe',
        );

        // Clear both fields intentionally
        await tester.enterText(firstNameField, '');
        await tester.enterText(lastNameField, '');
        await tester.pumpAndSettle();

        // Emit another user update from userProvider
        userStreamController.add(initialUser);
        await tester.pumpAndSettle();

        // Fields should remain empty and not get clobbered
        final firstTextField = tester.widget<AppTextField>(firstNameField);
        final lastTextField = tester.widget<AppTextField>(lastNameField);
        expect(firstTextField.controller?.text, '');
        expect(lastTextField.controller?.text, '');
      },
    );
  });
}
