# store-store Specification

## Purpose
TBD - created by archiving change store-product-features. Update Purpose after archive.
## Requirements
### Requirement: Product Detail Presentation
The system SHALL display product details including tabs for curriculum and action buttons for checkout.

#### Scenario: View Product
- **WHEN** user opens a product detail screen
- **THEN** system displays tabs and pricing information with CTAs for Buy Now and Installments

### Requirement: Pull-to-Refresh Store Content
The system SHALL allow users to manually refresh the store page content (products and categories) using a pull-to-refresh gesture.

#### Scenario: Successful pull-to-refresh
- **WHEN** user swipes down from the top of the store page
- **THEN** the system displays a refresh indicator and fetches the latest store categories and products from the server
- **AND** the store page content is updated with the fetched data

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

