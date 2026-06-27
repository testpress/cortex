## ADDED Requirements

### Requirement: Display Announcement Cards at Reduced Width
The announcements carousel SHALL render each card at a reduced width, so that more announcement cards are visible at a glance without horizontal scrolling.

#### Scenario: Multiple announcements displayed in carousel
- **WHEN** the announcements section renders more than one announcement card in the carousel
- **THEN** each announcement card SHALL occupy a reduced horizontal width compared to the current full-width behaviour
- **AND** the card height remains unchanged

#### Scenario: Single announcement displayed
- **WHEN** only one announcement card is present
- **THEN** the card rendering path is unaffected by this requirement
