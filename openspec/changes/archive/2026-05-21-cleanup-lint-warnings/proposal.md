## Why

The current codebase contains several minor linter warnings and info-level issues (unused declarations, unnecessary string interpolation braces, unnecessary imports, and conditional check improvements) that should be cleaned up to maintain repository hygiene and ensure a clean static analysis.

## What Changes

- Remove unused private method/declaration in the HTML widget.
- Correct unnecessary string interpolation braces.
- Remove redundant API endpoints import in HTTP data source.
- Simplify conditional null checks using null-aware operators.
- Implement the actual doubt submission logic using `DoubtRepository` and `AppDatabase` to resolve the linter warning for the pending TODO.

## Capabilities

### New Capabilities

### Modified Capabilities

## Impact

- `packages/core/lib/widgets/app_html.dart`
- `packages/core/lib/data/sources/http_data_source.dart`
- `packages/discussions/lib/screens/ask_doubt_form_screen.dart`
