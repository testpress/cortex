## Why

The `CourseCard` currently has broken hit testing, only responding to taps on explicit sub-widgets (arrow, text, image) rather than the entire card container area. This results in poor UX and frustration for users trying to navigate to a course.

## What Changes

- Ensure `CourseCard` container captures hit tests for the entire surface area, even in transparent space between widgets.
- Verify `AppFocusable` and `AppCard` composition correctly passes down callbacks and captures events.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `study-curriculum-list`: Clarify that interactive curriculum items (including CourseCard) must utilize full width/height hit test boundaries to ensure consistent accessibility.

## Impact

- `packages/courses/lib/widgets/course_card.dart`
- Potential generic layout fixes in core package components if `AppFocusable` is the culprit.
