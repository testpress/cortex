# Technical Design: Remove Empty Banner Spacing

## Architecture Context

In `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`, section widgets are rendered within an `AppScroll` children array. Standalone `SizedBox` widgets were inserted between sections for spacing. These static spacers cause unwanted empty gaps when conditionally rendered widgets evaluate to `SizedBox.shrink()`.

## Design Details

### 1. Remove Standalone `SizedBox` Spacers from `_HomeLayout`

By removing external `SizedBox(height: ...)` widgets, section height is entirely controlled by the section widgets themselves. If a widget evaluates to `SizedBox.shrink()`, it occupies exactly `0px`.

### 2. Self-Contained Section Padding

- `TopCarouselSectionWidget`: When `banners` is non-empty or skeletonizing, wrap `HeroBannerCarousel` with bottom padding (`design.spacing.md`). When empty, return `SizedBox.shrink()`.
- `ContextualHeroSectionWidget`: When `todayClasses` has live/upcoming classes, wrap `ContextualHeroCard` with bottom padding (`design.spacing.md`). When empty, return `SizedBox.shrink()`.
- `TodayScheduleSectionWidget`: Include bottom padding (`design.spacing.lg`) inside `TodaySnapshot`. When empty, return `SizedBox.shrink()`.

## Migration & Testing Plan

1. Verify layout spacing visually and via widget tests when banners are non-empty vs empty.
2. Verify that no regressions occur for users with active banners or live classes.
