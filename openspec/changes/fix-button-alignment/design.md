## Context

The current implementation of action footers in the "Certificate Preview" and "Lesson Detail" screens uses `AppButton` widgets inside `Expanded` blocks within a `Row`. However, these buttons do not occupy the full width of their `Expanded` parentContainer because the `fullWidth` property is set to `false` by default. This results in buttons that only wrap their content, leading to improper edge alignment.

## Goals / Non-Goals

**Goals:**
- Ensure action buttons in `CertificatePreviewScreen`, `_UnlockedCertificateDetails` (Certificate Card), and `LessonNavigationFooter` fill the available horizontal space symmetrically and correctly.
- Leverage the existing `fullWidth` property of `AppButton` for consistent implementation.

**Non-Goals:**
- Modifying the shared `AppButton` component logic.
- Changing the overall layout structure (Row/Expanded) of the footers.

## Decisions

### Enable `fullWidth` for footer and card actions
We will set `fullWidth: true` for the buttons in:
1. `packages/profile/lib/screens/certificate_preview_screen.dart` (Download/Share)
2. `packages/profile/lib/screens/certificates_screen.dart` (View Certificate inside card)
3. `packages/courses/lib/widgets/lesson_detail/lesson_navigation_footer.dart` (Previous/Next)

**Rationale:**
The `AppButton` component's internal `Container` width is governed by the `fullWidth` flag. Setting it to `true` allows the button to fill its parent container (the `Expanded` widget), which in turn fills its proportional share of the `Row`.

**Alternatives considered:**
- Manually wrapping each button in a `SizedBox(width: double.infinity)`: Discarded as it duplicates what `fullWidth: true` already does.
- Changing the default value of `fullWidth` in `AppButton`: Discarded to avoid unintended side effects across the entire application where buttons are expected to be content-sized.

## Risks / Trade-offs

- **Risk**: Buttons might look too wide on very large screens (tablets).
  - **Mitigation**: The `CertificatePreviewScreen` already has a `ConstrainedBox` with `maxWidth` for the card, but the buttons are outside it in the scroll view. However, the standard `AppScroll` padding and the screen's layout constraints usually keep this within acceptable bounds. If necessary, we can wrap the button Row in a `ConstrainedBox` as well, but for now, we follow the standard full-width mobile pattern.
