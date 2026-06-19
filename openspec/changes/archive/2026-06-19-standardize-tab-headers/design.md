## Context
Currently, the headers for Study, Exam, and Info tabs are embedded directly within their `CustomScrollView`s. This means that on mobile devices, when navigating to these primary sections, the headers bounce or stretch unnaturally along with the rest of the list content.

## Goals / Non-Goals
**Goals:**
- Provide a persistent, static header structure for the Study, Exam, and Info screens.
- Remove hardcoded `BouncingScrollPhysics` from these tabs so lists scroll cleanly underneath the static headers.
- Implement pull-to-refresh for the lists using Material's `RefreshIndicator`.

**Non-Goals:**
- Do not redesign the internal content of the tabs, just the layout hierarchy.
- Do not add or change any navigation icons (hamburger menus or back buttons) in the headers.

## Decisions
- **Structure**: We will wrap the primary UI for these screens in a `Column`, with the existing Header Container as the first child, and an `Expanded` containing the `CustomScrollView` as the second child. 

## Risks / Trade-offs
- **[Risk]** The Search bar and filters on the Study tab will permanently consume vertical screen space.
  → **Mitigation**: Users on smaller devices will lose some vertical list real estate, but the trade-off is improved layout stability.
