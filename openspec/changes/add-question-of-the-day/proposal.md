## Why

We need to add the "Question of the Day" (QOTD) feature to the application. This feature increases daily student engagement by providing a quick, daily learning activity accessible directly from the dashboard navigation with an interactive quiz experience, progress tracking, and detailed explanations.

## What Changes

- Add boolean flag `qotdEnabled` to the `InstituteSettings` data model.
- Add a new "Daily Questions" menu item in the Dashboard Drawer.
- Introduce native `QotdOverviewScreen` and `QotdQuizScreen` driven by Riverpod (`qotdQuizControllerProvider`).
- Implement dynamic `QotdDto` parsing for subject, difficulty, question type, options, and past attempts.
- Render questions using `AppHtmlV2` with custom MathJax SVG decoding support.

## Capabilities

### New Capabilities
- `daily-questions`: Feature providing landing overview, interactive multi-question quiz flow, option selection, attempt submission, and solution explanations.

### Modified Capabilities
- `lms-home-paid-active`: Adding the "Daily Questions" item to the drawer navigation.

## Impact

- `packages/core/lib/data/config/institute_settings.dart`: Modified to support the new `qotd_enabled` JSON field.
- `packages/core/lib/data/models/qotd_dto.dart`: Robust DTO parsing subject, difficulty, type, options, and attempts.
- `packages/core/lib/widgets/app_html_v2.dart`: Custom MathJax SVG decoding.
- `packages/testpress/lib/screens/dashboard/qotd/`: Contains `QotdOverviewScreen`, `QotdQuizScreen`, controller, and widgets.
- `packages/testpress/lib/navigation/app_router.dart`: Added routing for the `/qotd` screen.
