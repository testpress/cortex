## Why

The LMS screens require two token groups that don't exist in `DesignConfig`:
a **dynamic subject color palette** (assigned to subjects by index at runtime
from API data) and **content-status colors** (live/completed/locked/upcoming).
Without these, every LMS widget would hard-code colors and break dark mode and
multi-tenant deployments. Subjects and their names are API-driven — the design
system MUST NOT assume a fixed subject list (e.g., Physics/Chemistry for IIT-JEE
could be Reasoning/Quant for a bank coaching institute using the same app).

## What Changes

- Add `DesignSubjectPalette` token group to `DesignConfig` — a fixed-size ordered
  list of `SubjectColors` entries (background/foreground/accent). Subjects from the
  API carry a `colorIndex` (0-based integer) that maps to a slot in this list.
  No subject names are baked into the token system.
- Add `DesignStatusColors` token group to `DesignConfig` — 4 status states
  (`live`, `completed`, `locked`, `upcoming`) each with `background` + `foreground`,
  light + dark variants.
- Add `card` / `onCard` color tokens to `DesignColors` — card surface distinct
  from `surface` (white on light, slate-800 on dark), required by `AppCard`.
- Extend `DesignConfig.copyWith`, `==`, `hashCode` to cover the new groups.
- Update `DesignColors.light()`, `.dark()`, `.smart()` to include `card`/`onCard`.
- Update `CourseDto.subjectColor` field: rename to `colorIndex` (int, 0-based)
  replacing the current placeholder hex/string value.

## Capabilities

### New Capabilities

- `subject-palette`: `DesignSubjectPalette` token group — an ordered list of
  `SubjectColors` (background/foreground/accent). Access via
  `Design.of(context).subjectPalette.atIndex(colorIndex)`. The API provides
  `colorIndex` per subject; the token system provides the color.
- `status-colors`: `DesignStatusColors` token group — badge/status color palettes
  (live/completed/locked/upcoming) via `Design.of(context).statusColors`

### Modified Capabilities

- `core`: `DesignColors` gains `card`/`onCard` tokens; `DesignConfig` gains
  `subjectPalette` and `statusColors` fields.

## Impact

- `packages/core/lib/design/design_config.dart` — primary change file
- `packages/core/lib/design/design_context.dart` — `Design.of(context)` passthrough
- `packages/data/lib/models/course_dto.dart` — `subjectColor: String` → `colorIndex: int`
- `packages/courses/lib/widgets/course_card.dart` — update to use `colorIndex`
- All consumers of `DesignConfig.defaults()` get the new tokens automatically

## Future Considerations

> **Known follow-up — Subject data model:**
> This change only handles *how to color* a subject (via `colorIndex`). It does NOT
> introduce a `SubjectDto` representing a subject entity (name, description, icon,
> colorIndex). When the course detail or subject list screen is built, a follow-up
> change will need to:
> - Add `SubjectDto` to `packages/data/lib/models/`
> - Add `getSubjects(courseId)` to the `DataSource` interface
> - Add `SubjectRepository` with `watchSubjects(courseId)` / `refreshSubjects(courseId)`
> - Add mock subject data to `MockDataSource` (e.g., "Physics", "Reasoning" for different tenants)
> - Add `HttpDataSource.getSubjects()` stub
>
> This follows the same repository pattern as `CourseRepository` today.
