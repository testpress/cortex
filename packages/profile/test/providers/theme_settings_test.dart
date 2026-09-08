import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/providers/settings_providers.dart';
import 'package:profile/providers/design_mode_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Settings Persistence', () {
    test(
      'defaults to DesignMode.system when SharedPreferences is empty',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        final mode = container.read(designModeProvider);
        expect(mode, DesignMode.system);
      },
    );

    test(
      'synchronously restores saved dark mode preference on startup',
      () async {
        SharedPreferences.setMockInitialValues({'appearance_mode': 'dark'});
        final prefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        final mode = container.read(designModeProvider);
        expect(mode, DesignMode.dark);
      },
    );

    test(
      'updates SharedPreferences and provider state on updateMode',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        expect(container.read(designModeProvider), DesignMode.system);

        await container
            .read(appearanceSettingsNotifierProvider.notifier)
            .updateMode(DesignMode.dark);

        expect(container.read(designModeProvider), DesignMode.dark);
        expect(prefs.getString('appearance_mode'), 'dark');
      },
    );
  });
}
