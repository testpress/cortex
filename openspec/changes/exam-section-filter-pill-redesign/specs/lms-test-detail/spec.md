## MODIFIED Requirements

### Requirement: Section / Subject Filter Strip
The system SHALL display an always-visible, horizontally-scrollable filter strip below the test header when a test has more than one section or more than one subject.

The pill style SHALL match the study-page filter pattern:
- Inactive pill: background `design.colors.surfaceVariant`, foreground text `design.colors.textPrimary`.
- Active pill: background `design.colors.textPrimary`, foreground text `design.colors.card`.
- Border-radius: `design.radius.pill`.
- Text style: `AppText.label`.
- Wrappers: `AppSemantics.button` + `AppFocusable` with `AnimatedContainer` (200 ms, `easeOut`).

The filter strip SHALL NOT have a collapse/expand toggle. It SHALL always be visible when sections or subjects are present.

#### Scenario: Single section or subject
- **WHEN** the exam has only one section or all questions share the same subject
- **THEN** the filter strip SHALL NOT be rendered (no tabs shown).

#### Scenario: Multiple sections — active state
- **WHEN** the exam has multiple sections and the user is on section N
- **THEN** the pill for section N SHALL display with `textPrimary` background and `card` foreground.
- **AND** all other pills SHALL display with `surfaceVariant` background and `textPrimary` foreground.

#### Scenario: Multiple subjects (single section)
- **WHEN** the exam has one section but questions have multiple distinct subjects
- **THEN** one pill per subject SHALL be rendered.
- **AND** the active pill SHALL reflect the subject of the currently displayed question.

#### Scenario: Horizontal overflow
- **WHEN** the combined pill width exceeds the screen width
- **THEN** the strip SHALL be horizontally scrollable without clipping or fade masks.

#### Scenario: Pill tap
- **WHEN** the user taps an inactive pill
- **THEN** the system SHALL switch to that section or scroll to the first question of that subject.
- **AND** the tapped pill SHALL transition to the active state with a 200 ms animation.

## REMOVED Requirements

### Requirement: Collapsible Section Tab Bar
**Reason**: The collapse/expand toggle was removed as part of the filter-pill redesign. The always-visible strip provides the same navigational function with less interaction complexity.
**Migration**: No user-facing migration needed. `isExpanded` and `onExpandChanged` props are removed from `SectionsTabBar`; call sites in `TestDetailScreen` must drop those props and remove the `_isSectionsTabBarExpanded` state field.
