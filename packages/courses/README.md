# Courses SDK Module

The `courses` module provides LMS capabilities for the Cortex SDK.

## Purpose
This module handles course listings, progress tracking, and course content rendering. It is designed to be embedded into any application via the `testpress` aggregator.

## Integration
Public UI components like `CourseCard` should be exposed via `package:testpress/course_list.dart`.

## Standards
- Depends on `package:core/core.dart` for all UI primitives.
- Must follow the **Neutral UI** and **Accessibility** contracts defined in `core`.
- No direct dependencies on standard Material/Cupertino widgets.

# Accessibility Integration

### Semantic Compositions
The courses module inherits its accessibility foundation from `core`. Components must compose these foundations into domain-specific semantics:
- **CourseCard**: Exposes progress semantics using `AppSemantics.progressValue`, allowing screen readers to announce "X percent complete" during list navigation.
- **Scrollable Lists**: The `CourseListScreen` uses semantic landmarks to announce item counts and list bounds to assistive technologies.
- **Navigation Indicators**: Progress bars and status tags are marked with appropriate semantic roles to ensure information is not conveyed by color alone.
