## Context

See `proposal.md → Why` for motivation.

The current data flow inside the `courses` package is:

```
Drift Row (LessonsTableData)
  └─▶ repo.rowToLessonDto(row)   → LessonDto      [core package]
        └─▶ manual 40-field copy → Lesson          [courses/models/course_content.dart]
              └─▶ UI widgets / screens
```

`LessonDto` (in `core`) is already a fully typed, immutable value object with
`copyWith`, `mergeWith`, `fromJson`, and an `isComplete` getter. The `Lesson`
domain model adds only three computed getters (`isZoom`, `isTeams`, `isFermion`)
on top of an identical field set. `ChapterDto` similarly covers everything the
`Chapter` wrapper provides, minus a `courseTitle` convenience field.

The three detail providers each contain a hand-written 40-field
`LessonDto → Lesson` copy block. Two of those copies are near-identical
(`lessonDetailProvider` and `liveClassDetailProvider`), and the third
(`chapterDetailProvider`) embeds a second copy inside a `.map()`.

## Goals / Non-Goals

**Goals:**
- Remove `class Lesson` and `class Chapter` from the `courses` package entirely
- Remove the `Lesson`/`Chapter` re-export shim (`course_content.dart`, `course.dart`)
- Eliminate all `LessonDto → Lesson` mapping boilerplate from the three providers
- Move `isZoom`, `isTeams`, `isFermion` getters into `LessonDto` (in `core`) so
  no information is lost at the call sites
- Reconcile the `isComplete` discrepancy (see Decisions § 1)
- Make all UI widgets accept `LessonDto` / `ChapterDto` directly

**Non-Goals:**
- Changing any user-visible behaviour
- Modifying the Drift schema or `rowToLessonDto` mapping logic
- Touching the `exams` or `app` packages (they already use `LessonDto`)
- Refactoring the providers' cache/keep-alive strategies

## Decisions

### 1 — Reconcile `isComplete` between `LessonDto` and `Lesson`

**Problem:** `Lesson.isComplete` has a special branch for Fermion live streams
(`liveStreamProvider.contains('fermion') → contentUrl != null`) that
`LessonDto.isComplete` does not have — it falls through to the generic
`uuid != null` check for `liveStream`. This means the orchestrator today uses
slightly different readiness logic than the DTO.

**Decision:** Adopt the `Lesson.isComplete` Fermion branch as the correct
behaviour and port it into `LessonDto.isComplete` in `core`. This fixes
a latent bug in addition to the refactor.

**Alternative considered:** Keep two separate `isComplete` implementations — 
rejected because it defeats the purpose of the refactor and leaves the bug in
place.

---

### 2 — Where to put `isZoom`, `isTeams`, `isFermion`

**Decision:** Add them as getters directly on `LessonDto` in `core`, since they
are simple string checks on `liveStreamProvider` that are clearly properties of
the lesson itself, not view logic.

```dart
// In LessonDto (core)
bool get isZoom   => liveStreamProvider?.toLowerCase().contains('zoom')   ?? false;
bool get isTeams  => liveStreamProvider?.toLowerCase().contains('teams')  ?? false;
bool get isFermion => liveStreamProvider?.toLowerCase().contains('fermion') ?? false;
```

**Alternative considered:** Extension methods on `LessonDto` inside `courses` —
rejected because these getters are domain semantics, not view-layer concerns.
Keeping them in `core` allows future packages to use them too.

---

### 3 — How to handle `Chapter.courseTitle`

**Problem:** `Chapter` carries a `courseTitle` field that `ChapterDto` does not
have. `chapterDetailProvider` populates it by doing a `watchCourses().first`
lookup to enrich the chapter.

**Decision:** Pass `courseTitle` as a separate `String?` alongside `ChapterDto`
at the provider level, making it an explicit nullable parameter rather than
baking it into the DTO. The provider returns a record / simple wrapper tuple:

```dart
// chapterDetailProvider now yields:
Stream<(ChapterDto, String? courseTitle)?>
```

This avoids adding a view-specific enrichment field to the core `ChapterDto`,
which is owned by the SDK layer, not the courses UI layer.

**Alternative considered:** Add `courseTitle` to `ChapterDto` in `core` — 
rejected because `courseTitle` is only relevant in the `chapter_detail_page`
header and pollutes the core model with UI context. 

**Alternative considered:** Derive `courseTitle` directly inside the widget by
watching `courseDetailProvider` — rejected because it adds a second provider
watch to the widget, coupling it to course-level state unnecessarily.

---

### 4 — Rollout strategy (no migration, swap in place)

Because this is a purely internal refactor with no persisted format changes
and no inter-package API surface change (the `LessonDto` getters are additive),
we can swap every usage in a single PR. There is no need for a phased rollout
or feature flag.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Missed usage site causes a compile error | `dart analyze` after each file change; CI will catch any remaining references before merge |
| `isComplete` Fermion fix changes real behaviour | The old `Lesson.isComplete` was already the intended code path in the orchestrator — this makes `LessonDto` match it, not the other way around |
| `ChapterDto` tuple type is more verbose at call sites | Only one call site (`chapter_detail_page.dart`) reads `courseTitle`; cost is minimal |
| `course_content.dart` re-exports `LessonDto`/`LessonType` etc. — removing it could break importers | Audit all import paths before deletion; redirect any re-export consumers directly to `package:core/data/data.dart` |

## Migration Plan

1. **`core` — extend `LessonDto`**
   - Add `isZoom`, `isTeams`, `isFermion` getters
   - Port Fermion branch into `isComplete`
   - No breaking changes (additive only)

2. **`courses` providers — drop domain model mapping**
   - `lesson_detail_provider.dart`: change return type to `Stream<LessonDto?>`;
     remove the 40-field `Lesson(...)` constructor block; stream `rowToLessonDto`
     output directly
   - `live_class_detail_provider.dart`: same treatment
   - `chapter_detail_provider.dart`: change return type to
     `Stream<(ChapterDto, String?)?>` (or a lightweight record); remove
     `Lesson(...)` mapping inside `_watchChapter`

3. **`courses` screens + widgets — update signatures**
   - `LessonDetailOrchestrator`: `Lesson lesson` → `LessonDto lesson`
   - `ChapterDetailPage.onLessonClick`: `ValueChanged<Lesson>` → `ValueChanged<LessonDto>`
   - All `widgets/lesson_detail/` widgets: update `final Lesson lesson` fields
   - `ChapterContentItem`: `final Lesson lesson` → `final LessonDto lesson`
   - `downloads_provider.dart`: `startPdfLessonDownload(Lesson)` → `startPdfLessonDownload(LessonDto)`

4. **`courses` models — delete files**
   - Delete `packages/courses/lib/models/course_content.dart`
   - Delete `packages/courses/lib/models/course.dart`
   - Remove their exports from `packages/courses/lib/courses.dart`

5. **Verify**
   - `dart analyze packages/courses` — zero errors
   - `dart analyze packages/core` — zero errors
   - Manual smoke test: open a video lesson, PDF lesson, live class, and video
     conference — all should render and the download button should function
