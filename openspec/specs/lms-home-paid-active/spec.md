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

#### Scenario: Gated accessibility
- **GIVEN** the client configuration has `showTodaySchedule` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `TodaySnapshot` section MUST be hidden from the UI
- **AND** any associated data fetching for this section SHOULD be bypassed

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
- **THEN** its color MUST reflect the minutes studied using a linear interpolation of the `primary` color
- **AND** 0 mins MUST use the `surfaceVariant` color token

#### Scenario: Streak reinforcement
- **WHEN** the user has a study streak of 2 days or more
- **THEN** the system MUST display the "Flame" icon and streak count in the `StudyMomentum` card
- **AND** the label MUST be localized using `streakMomentumLabel(count)`

#### Scenario: Semantic subject insights
- **WHEN** strongest or weak subject cards are rendered
- **THEN** they MUST use `SubjectColors` from `design.subjectPalette`
- **AND** "Strongest" MUST use Emerald (Index 2) and "Need Focus" MUST use Amber (Index 6)

---

### Requirement: Fast-tracked Actions
The system SHALL provide a `ContextualHeroCard` and `QuickAccess` grid for friction-free navigation.

#### Scenario: Contextual action for live class
- **WHEN** a class is currently `live`
- **THEN** the `ContextualHeroCard` MUST display "Join Live Class" as its primary CTA

#### Scenario: Adaptive shortcut colors
- **WHEN** items in the `QuickAccessGrid` are rendered
- **THEN** background and icon colors MUST be resolved from `design.shortcutPalette.atIndex(index)`

#### Scenario: Gated Quick Access
- **GIVEN** the client configuration has `showQuickAccess` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `QuickAccessGrid` MUST NOT be visible

#### Scenario: Gated Contextual Hero
- **GIVEN** the client configuration has `showContextualHero` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `ContextualHeroCard` MUST NOT be displayed

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

#### Scenario: Localization implementation
- **WHEN** rendering dynamic text components (headers, captions, badges)
- **THEN** they MUST use `L10n.of(context)` for all user-facing strings to support internationalization.

#### Scenario: Temporary Hardcoded Data Models
- **WHEN** reading `PromotionalBanners`, `TopLearnersSection`, and `QuickAccessGrid`
- **THEN** these components rely on mock data objects but use dynamic UI rendering logic, awaiting the full database integration.
- **BUT** for `HeroBannerCarousel`, the system MUST now fetch live data from the backend as specified in the `api-dashboard-banners` capability.

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

---

### Requirement: Domain-Specific Layout Behavior
The system SHALL support specialized layout rules and section ordering based on client configuration.

#### Scenario: Sticky branding for specialized institutes
- **GIVEN** a client configuration with an active institute banner (e.g., Brilliant)
- **WHEN** the user scrolls the home screen
- **THEN** the `InstituteBanner` MUST remain fixed (sticky) at the top
- **AND** the `DashboardHeader` MUST scroll with the content
- **BUT** for standard clients without a banner, the `DashboardHeader` MUST remain fixed at the top

#### Scenario: Custom section prioritization
- **GIVEN** the "Brilliant" institute configuration
- **WHEN** the dashboard sections are rendered
- **THEN** they MUST follow the specific sequence: Top Carousel -> Updates & Announcements -> Learning Performance -> Top Learners
- **AND** this sequence MUST NOT affect the default ordering of other subdomains

