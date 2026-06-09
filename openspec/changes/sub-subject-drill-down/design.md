## Context

The analytics screen (`SubjectAnalyticsScreen`) was built to display top-level subject performance data. It accepts an optional `parentId` parameter in its route, but previously had no mechanism to conditionally change its layout or allow navigation into child subjects.

The existing data layer (`SubjectAnalyticsRepository`, `subjectAnalyticsProvider`) already supports filtering by `parentId`, as the `subjectAnalyticsTable` stores a `parent` column. The chevron icon on non-leaf rows was already present from the previous task. The missing piece was the UI layer: making those rows tappable and hiding the tabs when viewing a scoped child subject.

## Goals / Non-Goals

**Goals:**
- Allow the user to navigate from a parent subject row into a child subject's analytics view.
- Hide the "Overall / Individual Reports" tab bar when viewing a child subject, since the individual tab's donut chart data is only meaningful at the root level.

**Non-Goals:**
- Back-stack history or breadcrumb trail — go_router's native stack handles back navigation.
- Multi-level nesting beyond a single parent-child relationship.

## Decisions

### 1. Reuse `SubjectAnalyticsScreen` for child subjects (no new screen)

**Decision**: Navigate to the same `/exams/analytics` route with a `parentId` query parameter rather than creating a separate child screen.

**Rationale**: The UI layout for a child subject view is identical to the root view — same header, same filter, same `OverallReportsView`. Creating a duplicate screen would introduce unnecessary code duplication and divergence over time.

**Alternative considered**: A dedicated `ChildSubjectAnalyticsScreen`. Rejected because it would require duplicating the header, filter menu, and tab logic.

---

### 2. Hide tabs using `widget.parentId == null` check

**Decision**: Wrap the tab row in an `if (widget.parentId == null)` condition inside the screen's `build` method.

**Rationale**: The Individual Reports tab shows donut charts scoped to a hardcoded `parentId: 3`. This concept is not meaningful for child subjects, which have their own isolated data scope. Hiding the tabs avoids confusing or incorrect data being displayed.

---

### 3. `GestureDetector` on table cells; `AppFocusable` on bar chart rows

**Decision**: Wrap individual `Table` cells in `GestureDetector` (with `HitTestBehavior.opaque`) in `IndividualReportsView`, and wrap bar rows in `AppFocusable` in `OverallReportsView`.

**Rationale**: The `Table` widget in Flutter does not support row-level tap detection natively. Each cell must be wrapped individually. `AppFocusable` is the project-standard interactive wrapper for list-style rows and is appropriate for `BarRow` items outside a `Table`.

---

### 4. Navigation via `context.push` with query parameters

**Decision**: Navigate using `context.push('/exams/analytics?parentId=\${subject.id}&subjectName=\${Uri.encodeComponent(subject.name)}')`.

**Rationale**: go_router's `context.push` adds the destination to the navigation stack, allowing the user to press the existing back button to return. The `subjectName` parameter populates the header title without an additional DB lookup.

## Risks / Trade-offs

- **[Risk] Leaf subjects tapped accidentally** → Mitigated by setting `onTap: null` for rows where `subject.leaf == true`, making them non-interactive.
- **[Risk] `parentId` string parsing failure** → `int.tryParse` is used throughout; a `null` parse result falls back gracefully to root-level data.
- **[Trade-off] No breadcrumb UI** → Users rely solely on the back button to navigate up. Acceptable for now; breadcrumb can be added in a future iteration.
