## Why

We need to provide a new "My Results" screen for students to view their exam performance. This feature was previously implemented in the Android app for a specific institute (Brilliant Palla), and we now need to replicate this capability within the Flutter application so that students on iOS and Android can access their Model Exam and Weekly Exam results.

## What Changes

- Add a new "My Results" screen with two tabs: Model Exam and Weekly Exam.
- Implement horizontal scrolling data tables to display detailed exam scores across various subjects (Physics, Chemistry, Biology, Maths, etc.), along with rank and grade.
- Connect to an external API (`https://65.108.62.51/studentexamapi`) using the student's username as the `studentno` parameter.
- Bypass SSL certificate validation for this specific API request since it relies on an IP address without a valid certificate.
- Add a new toggle flag `SHOW_EXAM_RESULTS` to `AppConfig` to control the visibility of this feature.
- Add a "My Results" menu item to the dashboard drawer that pushes to the new screen when enabled.

## Capabilities

### New Capabilities
- `my-results`: Displays paginated exam results (Model and Weekly) in a detailed tabular format for a student.

### Modified Capabilities

## Impact

- **UI/Navigation**: `dashboard_drawer.dart` will be updated to include the new menu item.
- **Config**: `app_config.dart` will receive a new boolean flag `showExamResults`.
- **Network**: A custom network client/override will be introduced specifically for the external IP address to bypass SSL.
- **Packages**: The new screens and providers will be located within `packages/exams` under a `results` subfolder.
