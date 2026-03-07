## Why

The current Assessment Detail screen in Flutter does not perfectly align with the intended React design specifications. Users have reported missing navigation buttons, incorrect feedback colors (orange instead of amber), and a question palette that doesn't match the premium aesthetic. This change ensures visual consistency and a smooth assessment experience across platforms.

## What Changes

- **3-State Action Bar**: Implement a navigation bar that intelligently switches between "Previous/Next" and "Check Answer" based on the user's interaction state.
- **Refined Question Palette**: Rewrite the palette to include a vertical legend, rounded square tiles with state-specific icons (checkmark/X), and a snug layout that avoids excessive bottom spacing.
- **Localized Feedback**: Add specific strings for "Exit Assessment", "Correct!", "Not quite right", etc., in English, Arabic, and Malayalam.
- **Design System Alignment**: Fix feedback colors to use the amber subject palette for incorrect answers and remove extraneous card borders.
- **Component Standardization**: Update `OptionCard` and `AssessmentHeader` to support these new refined states.

## Capabilities

### New Capabilities
- `lms-assessment-detail`: Comprehensive detail view for assessments including question navigation, real-time feedback, and a stateful question palette.

### Modified Capabilities
- `lms-test-shared`: Shared components like `OptionCard` and navigation buttons modified to support assessment-specific feedback states.

## Impact

- `packages/courses/lib/screens/assessment_detail_screen.dart`
- `packages/courses/lib/widgets/assessment_detail/`
- `packages/core/lib/l10n/`
- `packages/courses/lib/models/assessment_model.dart`
