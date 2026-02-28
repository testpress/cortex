## Why

The current app lacks a dedicated Study tab where paid users can browse their enrolled courses and filter content by type (Videos, Lessons, Assessments, Tests). This change introduces the `StudyPage` as a core pillar of the LMS navigation, providing a structured way for students to access their curriculum.

## What Changes

- **New Study Tab**: Implements the main course listing screen for the 'Study' navigation item.
- **Search & Filtering**: Adds a search bar for curriculum-wide search and a "Content Type" filter grid to toggle specific categories of material.
- **Enhanced Course Cards**: Displays course progress, lesson counts, and duration using optimized spacing and design tokens.
- **Floating Resume Card**: Adds a sticky "Mini Player" style card to quickly pick up where the user left off in their most recent lesson.
- **Dark Mode Support**: Full implementation of the dark mode mapping strategy identified in the Premium Calibration spec (e.g., pure black/Zinc-950 canvas, Zinc-900 UI surfaces).

## Capabilities

### New Capabilities
- `study-curriculum-list`: Defines requirements for displaying the course and chapter hierarchy in the study tab.
- `study-content-filtering`: Specifies behavior for dynamic filtering of lessons by type (Video/PDF/Assessment/Test).

### Modified Capabilities
- `lms-navigation-shell`: Update the navigation shell to route the 'Study' tab to the new `StudyPage`.

## Impact

- **Affected Packages**: `packages/courses` (UI implementation), `packages/core` (primitives/routing), `packages/data` (providers for course list).
- **Dependencies**: Uses `lucide_icons_flutter` (mapping from React's lucide-react).
- **Breaking Changes**: None.
