## Context

The application currently supports English (`en`), Arabic (`ar`), and Malayalam (`ml`) using Flutter's standard localization mechanism (`flutter_localizations`). To reach more users, we need to add support for the Tamil language (`ta`).

## Goals / Non-Goals

**Goals:**
- Add an `app_ta.arb` file with correct Tamil translations for all existing app strings.
- Ensure the build system automatically generates `app_localizations.dart` covering the new language.

**Non-Goals:**
- Implementing any new UI for language selection (assuming the existing language picker automatically detects or lists supported locales).
- Adding completely new strings that do not exist in the current English template.

## Decisions

- **Translation File**: We will create `packages/core/lib/l10n/app_ta.arb` based on the template `app_en.arb`. 
- **Tooling**: We rely on Flutter's built-in `gen-l10n` tool configured via `l10n.yaml` which automatically watches the `lib/l10n` directory and updates `app_localizations.dart`.
- **Locale Code**: We will use standard ISO 639-1 code `ta` for Tamil.

## Risks / Trade-offs

- **Translation Accuracy**: Machine translation may be inaccurate. 
  - *Mitigation*: We will use standard translations and leave complex ones to be verified by native speakers or translators later.
- **RTL/LTR Conflicts**: Tamil is an LTR (Left-To-Right) language, so it shouldn't face the layout issues common in RTL (like Arabic).
