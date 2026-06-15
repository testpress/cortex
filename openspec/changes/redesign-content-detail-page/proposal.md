## Why

The current UI on the content detail and lesson detail pages has some layout issues. The next and previous buttons on the content detail page take up too much space and have an unnecessary footer block. Additionally, the back button on the lesson detail page header has excessive padding on the left side, which breaks the visual alignment. This change improves the visual aesthetics and usability of these pages.

## What Changes

- Modify the next and previous buttons on the content detail page to be smaller, similar to the exams UI.
- Remove the footer block surrounding the next and previous buttons on the content detail page.
- Fix the left padding on the back button in the header of the lesson detail page.

## Capabilities

### New Capabilities

### Modified Capabilities

- `content-detail`: UI adjustments to next/previous buttons and header back button padding.

## Impact

- `packages/courses` (UI adjustments only)
