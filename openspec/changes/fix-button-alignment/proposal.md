## Why

The action buttons in the "Certificate Preview" and "Lesson Navigation Footer" screens currently do not align properly to the edges of their containers. This creates a visual inconsistency where the buttons appear centered or clumped rather than filling the available horizontal space symmetrically, which is the expected design for primary action toolbars in the Cortex mobile experience.

## What Changes

- Update `CertificatePreviewScreen` to ensure "Download" and "Share" buttons fill their half of the layout.
- Update `_UnlockedCertificateDetails` (Certificate Card) to ensure the "View Certificate" button fills the available space next to the download action.
- Update `LessonNavigationFooter` to ensure "Previous" and "Next" buttons fill their half of the layout.
- These changes involve setting `fullWidth: true` on the `AppButton` instances within their respective `Row` and `Expanded` structures.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `lms-certificates`: Ensure the preview screen buttons follow full-width alignment standards.
- `chapter-detail`: Ensure the lesson navigation footer buttons follow full-width alignment standards.

## Impact

- `packages/profile/lib/screens/certificate_preview_screen.dart`
- `packages/profile/lib/screens/certificates_screen.dart`
- `packages/courses/lib/widgets/lesson_detail/lesson_navigation_footer.dart`
- No breaking changes; UI polish only.
