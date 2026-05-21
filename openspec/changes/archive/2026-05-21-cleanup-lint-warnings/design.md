## Context

The static analyzer identified several minor lint issues and warnings in `packages/core` and `packages/discussions` that need to be resolved.

## Goals / Non-Goals

**Goals:**
- Fix the unreferenced declaration warning (`_updateHeight` not used) in `app_html.dart`.
- Fix unnecessary braces in string interpolation in `app_html.dart`.
- Fix unnecessary import warning in `http_data_source.dart`.
- Fix the null-aware check recommendation in `http_data_source.dart`.
- Implement actual doubt submission logic using `DoubtRepository` and local `AppDatabase` in `_handleSubmit` inside `ask_doubt_form_screen.dart` to resolve the linter warning for the pending TODO.

**Non-Goals:**
- Making functional changes to any of these widgets or data sources.
- Implementing features or any new logic other than the pending doubt submission TODO.
