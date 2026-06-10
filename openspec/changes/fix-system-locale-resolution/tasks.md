## 1. LocalizationProvider Update

- [x] 1.1 Update `LocalizationProvider` in `packages/core/lib/localization/localization_provider.dart` to make `initialLocale` a nullable `Locale?` that defaults to `null`.
- [x] 1.2 Update `LocalizationProviderScope` interface to return `Locale?` for `locale`.
- [x] 1.3 Update `_LocalizationProviderState` and `_LocalizationProviderInherited` to store and handle `Locale?` for `_locale`.

## 2. CortexApp Update

- [x] 2.1 Verify `MaterialApp` in `app/lib/main.dart` passes the now-nullable `locale` correctly to let Flutter's automatic locale resolution logic handle system defaults.
