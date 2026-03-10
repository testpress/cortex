## Context

The project spans multiple packages (`core`, `courses`, `exams`, `profile`, `testpress`). Frequent refactoring has left behind "ghost" imports that are no longer needed. Additionally, some widgets unnecessarily import both `material.dart` and `widgets.dart` when one would suffice. The goal of this design is to methodically clear these specific analyzer markers.

## Goals / Non-Goals

**Goals:**
- Resolve all `unused_import`, `unnecessary_import`, and `unused_shown_name` markers identified in the latest analysis.
- Ensure no functional code is removed during the cleanup.

**Non-Goals:**
- Adding new features.
- Fixing logical bugs in tests or localization (out of scope).
- Refactoring internal logic (strictly limited to the import/header blocks).

## Decisions

- **Precision over Bulk**: Only remove imports specifically flagged by the analyzer to avoid accidental breaking changes in files that haven't been analyzed yet.
- **Redundant Material Imports**: In files importing both `material.dart` and `widgets.dart`, we will prioritize `material.dart` if material widgets are used, or `widgets.dart` if only basic primitives are used, following the analyzer's specific recommendation for each file.

## Risks / Trade-offs

- **[Risk] Accidental deletion of extension methods** → Mitigation: Rely on the IDE/Analyzer's specific `unused_import` flag, which is aware of extension usage.
- **[Risk] Multiple package synchronization** → Mitigation: Run `dart analyze` across all packages after the cleanup.
