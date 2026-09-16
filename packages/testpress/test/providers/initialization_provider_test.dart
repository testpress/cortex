import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/providers/initialization_provider.dart';

class FakeInstituteSettingsRepository extends Fake
    implements InstituteSettingsRepository {
  InstituteSettings? cachedSettings;
  bool shouldThrowOnRefresh = false;
  InstituteSettings? freshSettings;

  @override
  Future<InstituteSettings?> loadSettings() async => cachedSettings;

  @override
  Future<InstituteSettings> refreshSettings() async {
    if (shouldThrowOnRefresh) {
      throw Exception('Network connection error: Failed host lookup');
    }
    return freshSettings ?? InstituteSettings.fromJson(const {});
  }
}

void main() {
  late FakeInstituteSettingsRepository fakeSettingsRepo;

  setUp(() {
    fakeSettingsRepo = FakeInstituteSettingsRepository();
  });

  group('settingsInitialization', () {
    test(
      'throws when offline on first launch (no cache, refresh fails) so bootstrapProvider transitions to error',
      () async {
        fakeSettingsRepo.cachedSettings = null;
        fakeSettingsRepo.shouldThrowOnRefresh = true;

        final container = ProviderContainer(
          overrides: [
            instituteSettingsRepositoryProvider.overrideWithValue(
              fakeSettingsRepo,
            ),
          ],
        );
        addTearDown(container.dispose);

        // Should throw so bootstrapProvider can detect error state
        expect(
          () => container.read(settingsInitializationProvider.future),
          throwsA(isA<Exception>()),
        );
      },
    );

    test('uses cached settings when offline and cache exists', () async {
      final cachedSettings = InstituteSettings.fromJson({
        'login_label': 'Custom ID',
        'allow_signup': true,
      });

      fakeSettingsRepo.cachedSettings = cachedSettings;
      fakeSettingsRepo.shouldThrowOnRefresh = true;

      final container = ProviderContainer(
        overrides: [
          instituteSettingsRepositoryProvider.overrideWithValue(
            fakeSettingsRepo,
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(settingsInitializationProvider.future),
        completes,
      );

      final settings = container.read(instituteSettingsProvider);
      expect(settings, isNotNull);
      expect(settings!.loginIdLabel, 'Custom ID');
      expect(settings.allowSignup, isTrue);
    });
  });
}
