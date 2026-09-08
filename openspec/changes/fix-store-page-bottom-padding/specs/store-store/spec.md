## ADDED Requirements

### Requirement: Store Page Bottom Navigation Clearance
The system SHALL provide bottom clearance at the end of the store page scrollable content to ensure that bottom-most products are fully visible and not obscured by the persistent floating bottom navigation bar when fully scrolled.

#### Scenario: Scroll to bottom of store page
- **WHEN** user scrolls to the bottom of the store product list
- **THEN** the bottom-most product cards are fully visible above or scrolled past the floating bottom navigation bar

### Requirement: Store Product Card Grid Alignment Uniformity
The system SHALL display product card titles with single-line ellipsis (`maxLines: 1`) to ensure uniform card heights and aligned pricing rows across all product cards in the store grid without introducing artificial whitespace gaps.

#### Scenario: Long product title truncated to single line
- **WHEN** a product has a long title exceeding the available width of a card
- **THEN** the title is truncated with an ellipsis on a single line
- **AND** the card height and price placement match adjacent cards in the same grid row
