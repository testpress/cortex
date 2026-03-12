# Capability: Explore Dashboard

## Purpose
The main landing experience for the Explore tab, coordinating the layout of featured content and discovery sections.

## Requirements

### Requirement: Featured Content Carousel
The system SHALL display a horizontal carousel of featured banners at the top of the Explore dashboard to highlight new launches, updates, or special sessions.

#### Scenario: Navigating featured items
- **WHEN** the user swipes left or right on the hero banner section
- **THEN** the system SHALL navigate through the featured banners using a snapping animation
- **AND** the system SHALL update the pagination indicator to reflect the current banner index

### Requirement: Course Discovery Sections
The system SHALL provide distinct horizontal scrolling sections for "Trending Now" and "Recommended for You" courses to facilitate discovery.

#### Scenario: Viewing course details from discovery
- **WHEN** the user selects a course card from any discovery section
- **THEN** the system SHALL navigate to the Course Detail view for that specific course

### Requirement: Quick Access Filtering
The system SHALL provide a horizontal list of interactive "pills" (Trending, Recommended, Short Lessons, Popular, Study Tips) that allow the user to quickly navigate to specific sections of the Explore page.

#### Scenario: Tapping a filter pill
- **WHEN** the user taps a specific pill in the filter bar (e.g., "Study Tips")
- **THEN** the system SHALL automatically scroll the dashboard to the corresponding section header
