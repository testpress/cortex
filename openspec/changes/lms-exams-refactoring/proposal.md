## Why

Currently, all code related to tests, exams, and assessments (screens, widgets, models, data) is located within the `courses` package. This creates a monolithic module, bloats the `courses` package with unrelated functionality, and makes both packages harder to maintain. Moving these components to the dedicated `exams` package will improve code organization, establish clear separation of concerns, and align with the intended project architecture.

## What Changes

- Move screens related to assessments (`assessment_detail_screen.dart`), tests (`test_detail_screen.dart`), and reviews (`review_answer/`) from `courses` to `exams` package.
- Move assessment and test-related widgets (`assessment_detail/`, `test_detail/`) from `courses` to `exams`.
- Move test and assessment data models (`assessment_model.dart`, `test_model.dart`) from `courses` to `exams`.
- Move test and assessment mock data (`mock_assessments.dart`, `mock_tests.dart`) from `courses` to `exams`.
- Refactor the app's router and imports to reference `exams` package components where appropriate.

## Capabilities

### New Capabilities

### Modified Capabilities
- `lms-assessment-detail`: The module location changes from `courses` to `exams`.
- `lms-exam-review`: The module location changes from `courses` to `exams`.
- `lms-test-detail`: The module location changes from `courses` to `exams`.

## Impact

- `packages/courses`: Removal of all exams/tests/assessment code.
- `packages/exams`: Becomes the primary package for all test feature robust functionality.
- Router Configuration and any file importing test details, review, and assessment components.
