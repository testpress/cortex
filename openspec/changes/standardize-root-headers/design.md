## Context

The monorepo currently suffers from duplicated UI layout logic for root-level screens (e.g., Study, AI Support, Profile, Exams, Info). Each of these screens manually wraps a `Column` inside a `Container` with hardcoded top padding calculated via `MediaQuery.paddingOf(context)` to avoid overlaps with the system status bar and notches.

## Goals / Non-Goals

**Goals:**
- Unify all standard root-level and sub-level header layouts under a single `SectionHeader` widget.
- Support `leadingIcon` actions (menu/back buttons) explicitly.
- Support `trailingAction` widgets.
- Support optional `secondaryContent` below the main header row.

**Non-Goals:**
- Modifying the navigation paradigms or routing of the app.
- Changing the visual styling or colors (it should perfectly replicate the existing design).

## Decisions

- **Nullable Parameters:** To ensure maximal reusability, `leadingIcon`, `trailingAction`, and `secondaryContent` in `SectionHeader` will all be nullable.

## Risks / Trade-offs

- [Risk] Replacing manual paddings might slightly alter pixel-perfect alignments if not done carefully. -> Mitigation: Ensure `SectionHeader` uses the equivalent padding logic (`math.max(padding.left, design.spacing.md)`) as the original screens.
