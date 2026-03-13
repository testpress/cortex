# Proposal: Fix Nested AppShells

## Problem
Sub-pages within the global navigation shell (`ChapterDetailPage`, `ReviewAnswerDetailScreen`, etc.) were using `AppShell` internally. This caused "double padding" and redundant safe-area calculations since the global shell already identifies and manages the viewport.

## Proposed Change
- Replace nested `AppShell` widgets with simple `Container` widgets.
- Ensure `backgroundColor` is passed correctly to the `Container`.
- Harmonize padding across sub-pages to ensure consistent alignment with the global navigation rail/tab bar.

## Scope
- `ChapterDetailPage` (package:courses)
- `ReviewAnswerDetailScreen` (package:exams)
- `PaidActiveProfileScreen` (package:profile)
