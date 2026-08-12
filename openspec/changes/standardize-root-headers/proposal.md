## Why

Many root-level screens (Study, AI, Profile, Info, etc.) manually implement identical container-based safe-area padding logic and header styling. Unifying them into a single widget reduces tech debt, ensures design consistency, and improves maintainability across the monorepo.

## What Changes

- Create a generic `SectionHeader` widget in the `core` package that supports built-in safe area padding, leading icons (menu/back buttons), title text, trailing actions, and secondary content (search bars, subtitles).
- Strip out manual header containers in `StudyScreen`, `AiScreen`, `InfoPage`, and `ExamsScreen` and replace them with `SectionHeader`.
- Strip out manual headers in `NotificationsScreen` and `CertificatesScreen` and replace them with `AppHeader` (removing subtitle layouts).

## Capabilities

### New Capabilities
- `SectionHeader`: A highly flexible layout widget in the core package for root-level and sub-level page headers, supporting dynamic leading icons, trailing actions, and secondary content.

### Modified Capabilities
None

## Impact

- **packages/core**: Adds `SectionHeader` widget, updates `AiScreen`.
- **packages/profile**: Updates `PaidActiveProfileScreen`, `NotificationsScreen`, `CertificatesScreen`.
- **packages/courses**: Updates `StudyScreen`, `InfoPage`, `StorePage`.
- **packages/exams**: Updates `ExamsScreen`.
