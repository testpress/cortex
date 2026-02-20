## ADDED Requirements

### Requirement: AppBadge component
The system SHALL provide an `AppBadge` widget for displaying compact status tags and roles. The component MUST accept standard texts and optional colors, falling back to `DesignStatusColors` when semantic statuses (e.g., Live, Completed) are provided. It MUST also support an optional leading icon and an optional pill-shaped boundary.

#### Scenario: Displaying a semantic status badge
- **WHEN** the `AppBadge` is instantiated with a "Live" status
- **THEN** it renders with the specific background and foreground colors defined by `design.statusColors.live`

#### Scenario: Rendering variants (Pill & Icon)
- **WHEN** the `AppBadge` is provided with an icon and `isPill` set to true
- **THEN** it renders utilizing the `design.radius.pill` rather than default `design.radius.sm`, and visually layers the `Icon` preceding the text.

### Requirement: AppSearchBar component
The system SHALL provide an `AppSearchBar` widget acting as a standardized text input. It MUST occupy the full available width by default, feature a leading search icon, and emit an event when text changes.

#### Scenario: User types in the search bar
- **WHEN** the user inputs text into the `AppSearchBar`
- **THEN** the component triggers the `onChanged` callback with the updated string value

#### Scenario: Rendering the search bar
- **WHEN** the `AppSearchBar` is placed in a view
- **THEN** it renders with a `design.colors.surface` background, standard rounded corners, and a leading magnifying glass icon

### Requirement: AppTabBar component
The system SHALL provide an `AppTabBar` widget to handle bottom navigation. It MUST accept a list of navigation items and an active item identifier, and emit events when an inactive item is tapped.

#### Scenario: Changing the active tab
- **WHEN** a user taps an inactive tab inside `AppTabBar`
- **THEN** the component triggers the `onTabChange` callback emitting the new tab identifier

#### Scenario: Rendering the active state
- **WHEN** a tab is marked as the active item
- **THEN** it renders pulling the explicit `activeIcon` paired with `design.colors.textPrimary` font weights to visually differentiate it from the standard, inactive `icon` variant

### Requirement: AppSubjectChip component
The system SHALL provide an `AppSubjectChip` widget for filtering by subject or content type. It MUST leverage the `DesignSubjectPalette` based on an index parameter to generate its colors.

#### Scenario: Toggling the chip state
- **WHEN** a user taps an inactive `AppSubjectChip`
- **THEN** it transitions to an active visual state and fires the associated toggle callback

#### Scenario: Styling based on subject index
- **WHEN** the `AppSubjectChip` is instantiated with an active state and a specific subject index
- **THEN** it retrieves the corresponding `SubjectColors` from `design.subjectPalette` to style its background, text, and icon
