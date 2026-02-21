# Specs: LMS Paid Active User Home Screen (`lms-home-paid-active`)

## Purpose
This specification documents the requirements and specific design rules for the Paid Active User Home Screen (`PaidActiveHomeScreen`), which serves as the primary dashboard for enrolled students in the LMS.

## Requirements

### Requirement: Today's Schedule Smart Grouping
The system SHALL group the user's daily schedule into contextual sections within the `TodaySnapshot` component.

#### Scenario: Live class takes precedence in "Now & Next"
- **WHEN** there is a class with status `live`
- **THEN** it MUST be shown first in the "Now & Next" section with a distinctive "LIVE" badge

#### Scenario: Upcoming classes are separated from immediate next
- **WHEN** there are multiple upcoming classes
- **THEN** only the first one appears in "Now & Next", while the others appear in the "Later Today" section

---

### Requirement: Visual Status Indicators
All carousel items MUST display icons and status tags that match their content type and current state.

#### Scenario: Assignment progress visualization
- **WHEN** an assignment has a `progress` value
- **THEN** the system MUST display a 4-segmented progress bar
- **AND** segments MUST be color-coded (Red for overdue, Amber for pending, Slate for empty)

---

### Requirement: Learning Momentum Visualization
The system SHALL provide a visual summary of the user's weekly study activity.

#### Scenario: Intensity-based color mapping
- **WHEN** a day in the 7-day strip is rendered
- **THEN** its color MUST reflect the minutes studied:
    - 0 mins: Neutral Grey (Light: `slate-100`, Dark: `slate-800`)
    - < 60 mins: Light Blue
    - 60-120 mins: Medium Blue
    - > 120 mins: High-intensity Blue

#### Scenario: Streak reinforcement
- **WHEN** the user has a study streak of 2 days or more
- **THEN** the system MUST display the "Flame" icon and streak count in the `StudyMomentum` card

---

### Requirement: Fast-tracked Actions
The system SHALL provide a `ContextualHeroCard` and `QuickAccess` grid for friction-free navigation.

#### Scenario: Contextual action for live class
- **WHEN** a class is currently `live`
- **THEN** the `ContextualHeroCard` MUST display "Join Live Class" as its primary CTA

---

### Requirement: Top App Bar & Navigation Access
The system SHALL provide a persistent top app bar (DashboardHeader) with access to global navigation options.

#### Scenario: Hamburger Menu Placeholder
- **WHEN** the `DashboardHeader` is rendered
- **THEN** it MUST include a hamburger menu icon (`Icons.menu_rounded`)
- **AND** the actual menu sidebar functionality is deferred to a separate/future spec change.

---

### Requirement: Offline-First Scaffold Architecture
The system SHALL organize data models and UI state following an offline-first repository pattern utilizing Riverpod providers.

#### Scenario: Mock Provider Usage
- **WHEN** the `TodaySnapshot` and `StudyMomentum` components render
- **THEN** they MUST strictly read data from Riverpod mock providers (`todayClassesProvider`, `studyMomentumProvider`) to prepare the UI for the future Drift DB offline-first data layer (completed in `lms-data-layer`).

#### Scenario: Temporary Hardcoded Assets
- **WHEN** reading `PromotionalBanners`, `TopLearnersSection`, `HeroBannerCarousel`, and `QuickAccessGrid`
- **THEN** these components rely entirely on static UI scaffolding text arrays temporarily until their respective dynamic domains are brought online via the database.

---

### Requirement: Pixel-Perfect Component Spacing and Backgrounds
The system SHALL replicate the exact padding, margin, and layer backgrounds defined in the Figma Design reference.

#### Scenario: Canvas and Header layers separation
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** its base `Scaffold` background MUST be `#F8FAFC` (`slate-50`) in light mode
- **AND** the `DashboardHeader` MUST use the `card` color (`#FFFFFF`) with a 1px solid bottom `border`, matching Figma's `border-b` instead of an elevation shadow.

#### Scenario: Native component margins
- **WHEN** rendering section components (`PromotionalBanners`, `QuickAccessGrid`, `StudyMomentumGrid`, `TopLearnersSection`)
- **THEN** they MUST contain their own top/bottom `Padding` values directly derived from Figma's `mt-*` classes (e.g., `EdgeInsets.only(top: 32)` for `mt-8`).
- **AND** external `SizedBox` spacing between section roots MUST NOT be used to prevent double-padding layouts.

---

### Requirement: Granular Iconography and Visuals
The system SHALL match exact iconography and visual masking definitions.

#### Scenario: Avatar Masking
- **WHEN** circular Learner avatars are rendered in the `TopLearnersSection`
- **THEN** they MUST use `DecorationImage` injected into a `BoxDecoration` to clip correctly, rather than a raw `Image.network` widget.

#### Scenario: "Ask Doubt" Icon
- **WHEN** the "Ask Doubt" shortcut is listed in the `QuickAccessGrid`
- **THEN** it MUST use `Icons.live_help_outlined` to accurately simulate the `MessageCircleQuestion` bubble visual from Figma.

#### Scenario: Specific Divider Tones
- **WHEN** rendering the horizontal dividers in the `StudyMomentumGrid` learning stats
- **THEN** the dividers MUST use `#E2E8F0` (`slate-200`) in light mode and `#1F2937` (`slate-800`) in dark mode explicitly to enhance contrast visibility.

