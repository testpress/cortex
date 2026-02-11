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
