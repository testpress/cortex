# Design: Conditional UI Visibility based on Client Configuration

## Context
The current application layout is monolithic. As we onboard more institutes, we need the flexibility to toggle entire UI sections (like "Today's Schedule" or category shortcuts) based on the client's subdomain. We also need to introduce institute-specific branding in the form of a top banner.

## Goals / Non-Goals

**Goals:**
- Implement a feature-gating mechanism that reads configuration from the client/subdomain context.
- Enable/Disable `TodaySnapshot`, `QuickAccessGrid`, and `ContextualHeroCard` on the Home screen.
- Enable/Disable category buttons on the Study screen search bar.
- Implement an `InstituteBanner` component that displays the institute logo and user info (name/ID) at the top of the screen.

**Non-Goals:**
- Creating a full CMS for UI customization (this will be hardcoded or via existing config APIs).
- Changing the underlying data fetching logic for the sections (they just won't be rendered).

## Decisions

### 1. Unified Client Config Provider
We will utilize a `clientConfigProvider` (Riverpod) that fetches configuration based on the current subdomain. This config will include flags like:
- `showTodaySchedule`: boolean
- `showQuickAccess`: boolean
- `showContextualHero`: boolean
- `showStudyCategoryButtons`: boolean
- `instituteLogoUrl`: string (optional)

### 2. Conditional Rendering in Screen Layouts
Instead of modifying every widget, the main screen scaffolds (`PaidActiveHomeScreen` and `StudyCurriculumList`) will use these flags to conditionally include/exclude sections.

### 3. InstituteBanner Implementation
A new `InstituteBanner` widget will be created in `packages/core`. It will be designed to fit within the `DashboardHeader` slot.
- **Layout**: Image/Logo on the left, Name and ID on the right.
- **Styling**: Premium look, matching the "Brilliant Study Centre" reference image.

## Risks / Trade-offs
- **Complexity**: Adding many flags can make the UI logic harder to test.
- **Performance**: Fetching config must be fast to avoid "layout shift" where sections disappear after a few milliseconds.
- **Solution**: Cache the config locally or bundle it with the initial app state.
