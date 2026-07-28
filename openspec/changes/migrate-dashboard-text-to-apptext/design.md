## Context

Various screens and widgets across `packages/testpress`, `packages/courses`, and `packages/profile` (excluding `packages/exams`) render their textual content using the raw Flutter `Text` widget with custom `TextStyle` declarations. This contradicts `packages/core/docs/ai_context.md`, which mandates using the platform-neutral `AppText` primitive to maintain unified scaling and style token compliance.

## Goals / Non-Goals

**Goals:**
- Replace raw `Text` widget invocations in Bookmarks, Downloads, Ask Doubt, Attachment Viewer, and App Settings screens/widgets with semantic `AppText` constructors.
- Ensure that the typography aligns completely with the design tokens from context.
- Improve typography scalability under system text scaling preference configurations.

**Non-Goals:**
- Modifying other components outside of the specified list (specifically leaving the `exams` package unchanged).
- Redesigning visual layouts of these screens.

## Decisions

### 1. Map Bookmarks Error Text to `AppText.body`
- **Rationale**: General generic error messages represent standard reading text and should resolve to the `body` semantic style token.

### 2. Map SnackBar Text Content to `AppText.body`
- **Rationale**: SnackBar text is standard alert text. Using `AppText.body` with an explicit color override for SnackBar styling is semantically correct.

### 3. Map Thumbnails and Badges to `AppText.labelSmall`
- **Rationale**: Video duration overlay tags and file type indicators inside lists are micro UI labels. Using `AppText.labelSmall` is the closest semantic role.

### 4. Map Ask Doubt FAB Label to `AppText.labelBold`
- **Rationale**: FAB button labels are UI chrome and should use `AppText.labelBold` for consistent prominence.

### 5. Map Attachment Viewer Text to `AppText` Semantic Roles
- **Rationale**:
  - `widget.title` -> `AppText.title` (balances title visibility).
  - `_getMetadataString()` -> `AppText.caption` (standard caption metadata style).
  - Progress and failure labels -> `AppText.bodySmall` (standard small body text).

### 6. Map App Settings Tags to `AppText.labelSmall`
- **Rationale**: The recommended/default video settings tags inside rich text widget spans are micro UI indicators, perfectly fitting the `AppText.labelSmall` semantic style.

## Risks / Trade-offs

- **[Risk] Slight Visual Alignment Adjustments**: The font sizes of the text elements will transition from arbitrary hardcoded values (like 10px or 11px) to the nearest typography scale equivalents (12px).
  - **Mitigation**: Visually check the thumbnails and spans after refactoring.
