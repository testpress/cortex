## Why

The app needs a feature for users to create custom exams tailored to their specific needs. This gives users flexibility to practice specific subjects or difficulty levels, improving their learning outcomes and engagement.

## What Changes

- Add a UI flow to fetch and display courses where `allow_custom_test=true`.
- Add a screen to display filtering options (subjects, difficulty levels, question types) for a selected course using its custom test configuration.
- Implement sliders/inputs for the number of questions, respecting the `max_questions_per_test` limit.
- Display remaining daily and monthly attempt limits.
- Generate and launch the custom exam based on the user's selections.

## Capabilities

### New Capabilities
- `custom-exam`: The core capability that handles fetching eligible courses, fetching course-specific custom exam configurations, and submitting the user's custom exam generation request.

### Modified Capabilities
- 

## Impact

- **UI/UX**: New screens for selecting the custom exam course and configuring the custom exam parameters.
- **API Integration**: New endpoints `/api/v3/courses/?allow_custom_test=true` and `/api/v3/courses/<course_id>/custom-test-config/` will be integrated.
- **Routing**: Navigation routes for the custom exam flow.
