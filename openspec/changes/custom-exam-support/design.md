## Context

The app already has an `ExamPrescreen` (bottom sheet) used before launching a specific, pre-defined exam via `testId`. That flow is for assigned tests tied to course lessons.

The Custom Exam Options screen is a separate concern: the learner initiates a practice session on their own terms, with no pre-assigned `testId`. They choose their own exam options before the session begins.

These two flows must not be confused or merged. The new screen lives in `packages/exams` and is a full-page screen, not a bottom sheet.

## Goals / Non-Goals

**Goals:**
- Add a full-page screen where learners configure a custom practice exam before starting.
- Support intuitive UI flow: Practice scope is presented first, and selecting a specific course opens a dedicated bottom sheet.
- Configuration options cover: practice scope (full course vs specific course), question source, number of questions, difficulty level, and attempt mode.
- A single primary action at the bottom confirms the configuration.
- Screen uses only core primitives (`AppText`, `AppButton`, `AppScroll`, `AppHeader`, etc.) — no raw Material or Cupertino widgets.
- All interactive elements wrapped with `AppSemantics`.
- Design tokens accessed via `Design.of(context)`, never static imports.

**Non-Goals:**
- No changes to `ExamPrescreen` or the existing lesson-linked exam flow.
- No API integration in this change — the screen is UI-only; API wiring is a follow-up.
- No changes to the exam player, review, or analytics screens.
- No changes to the attempt mode runtime behaviour (Test vs Quiz player logic already exists).

## Decisions

### New screen, not a modification of ExamPrescreen
`ExamPrescreen` is a bottom sheet tightly coupled to a `testId` and `LessonDto`. Reusing it for the Custom Exam Options screen would require unwinding that coupling significantly. A new standalone screen is cleaner, avoids breaking the existing flow, and respects the separation of concerns between assigned exams and self-initiated practice.

### Custom Exam Options screen is full-page, not a bottom sheet or dialog
The screen has multiple configuration options plus a conditional sub-section (lesson picker). A bottom sheet would be cramped for this. A full-page screen with `AppScroll` is the right container.

### Scope selection determines next steps
The flow starts by asking the learner for the practice scope: "Full course practice" or "Select course". If they choose "Full course practice", no further course selection is needed. If they choose "Select course", a dedicated bottom sheet opens immediately.

### Course Selection Bottom Sheet
Rather than using inline dropdowns, course selection happens via a floating bottom sheet (`CourseSelectionSheet`). This sheet contains a sticky search bar at the top and a scrollable list of all enrolled courses fetched globally via `courseListProvider`. This provides ample space for searching and browsing without cluttering the main configuration screen.

### Attempt mode selection on the Custom Exam Options screen, not as a dialog
The existing flow shows a mode selection dialog (`ExamModeSelectionDialog`) at the point of starting the exam. For custom practice, attempt mode is part of the initial configuration intent, so it belongs on the Custom Exam Options screen itself. The dialog is not used here.

### Placed in `packages/exams`
The new screen is domain-specific to exams. It does not belong in `packages/core` (no shared primitive) or `packages/courses` (course selection is an input, not the owner of this flow). `packages/exams` is the right home.

## Risks / Trade-offs

- **Course data dependency**: The screen relies on fetching all enrolled courses via `courseListProvider` to populate the bottom sheet. Until full API integration handles pagination, the local search acts as a filter over the initial fetch.
- **Option availability per institute**: Some options (e.g. difficulty level, question source) may not be available for all institutes or all courses. If the API returns no options, the field should be hidden or shown in a disabled state. This is deferred to the API integration phase.

## Navigation

The Custom Exam Options screen is accessed from the Exams screen. It opens as a full-page route.
