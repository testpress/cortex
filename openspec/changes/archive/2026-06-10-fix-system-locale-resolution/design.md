## Context

Currently, the `CortexApp` in `app/lib/main.dart` is explicitly given a default `Locale('en')` by the `LocalizationProvider`. By explicitly passing a locale to `MaterialApp`, we bypass Flutter's automatic locale resolution, which means the app will not react to changes in the mobile device's system language (e.g., Tamil, Arabic). We need to fix this so that the app correctly identifies and applies the system language if it is one of our supported locales.

## Goals / Non-Goals

**Goals:**
- Ensure the app respects the device's system language at startup if it matches any of the `supportedLocales`.
- Ensure the app falls back to English (`en`) gracefully if the system language is not supported.
- Maintain the ability for the `LocalizationProvider` to override the locale if a user manually selects a language in-app in the future.

**Non-Goals:**
- Adding a new UI language picker.
- Adding additional language support beyond the existing ones (`en`, `ar`, `ml`, `ta`).

## Decisions

- **Nullable Locale State**: We will change `LocalizationProvider`'s internal `_locale` state from `Locale` to `Locale?`. It will default to `null`.
- **MaterialApp Initialization**: `MaterialApp.locale` will receive this `null` value by default. This enables Flutter's internal `localeListResolutionCallback` (or default fallback logic) to check the device locale against `supportedLocales`.
- **System Settings Reaction**: Because `MaterialApp` is correctly configured with `supportedLocales`, setting `locale` to `null` allows the app to respond dynamically when the mobile settings language changes to a supported language.

## Risks / Trade-offs

- **Risk**: Defaulting to `null` might cause unexpected behavior if a dependent widget strictly expects a non-null `Locale` from `LocalizationProvider.of(context).locale`.
  - **Mitigation**: We will ensure the interface `LocalizationProviderScope.locale` returns `Locale?` and any callers correctly handle the nullable type or retrieve the effective locale through Flutter's `Localizations.localeOf(context)` instead.
