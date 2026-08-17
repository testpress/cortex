## Context

See proposal.md for motivation and context. The feature must align with the monorepo's strict SDK boundaries and design rules defined in packages/core/docs/ai_context.md.

## Goals / Non-Goals

**Goals:**
- Provide a robust offline-first architecture using a 3-layer data flow (DataSource -> Repository -> Riverpod).
- Embed a custom-designed calendar view via `syncfusion_flutter_calendar` that integrates dynamically with Design system tokens.
- Ensure strict compliance with accessibility standards (WCAG 2.5.5 touch target size and AppSemantics structural wrapping).
- Fully localize all user-facing strings.

**Non-Goals:**
- Allowing the `app/` package to import anything from internal packages other than `package:testpress`.

## Decisions

### 1. Data Flow Architecture
We implement the standard 3-layer architecture:
- **DataSource**: Extended to support pagination parameters (`getLiveClasses(page, status, ordering)`). Implementations in `HttpDataSource` and `MockDataSource`.
- **Repository**: `LiveClassesRepository` handles SQLite local database transactions and sync. It is the single source of truth for the list data stream (`watchLiveClasses`).
- **Provider**: `LiveStreamList` watches the repository stream and exposes localized `LiveStreamItem` models.
- **Alternative considered**: Memory cache inside provider. Rejected because it violates offline persistence guidelines.

### 2. Third-Party Calendar Integration
- We use `syncfusion_flutter_calendar` to provide the monthly calendar interface since it is highly customizable and can bind to the Design token palette dynamically.
- Timezone overrides are added to handle package dependencies.

### 3. Accessibility & Clean Layout
- **AppSemantics**: List views are wrapped in `AppSemantics.scrollableList()` to provide structural cues to screen readers.
- **Touch Targets**: Interactive controls such as `_CustomSwitch` are sized at 48x48dp minimum to comply with WCAG 2.5.5.
- **Badges**: Text in statuses uses `AppText` components with scale tokens rather than raw `Text` with inline sizes.

## Risks / Trade-offs

- **Risk**: Version mismatches on the timezone dependency.
- **Mitigation**: Add `timezone: any` dependency override to both `testpress/pubspec.yaml` and `app/pubspec.yaml`.
