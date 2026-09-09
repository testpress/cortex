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

### Requirement: Automatic Store Refresh & Study Course Sync On Successful Purchase
The system SHALL automatically clear the store repository cache, invalidate store products, category, and product detail providers, and trigger a refresh of study courses via `courseListProvider.notifier.refresh()` upon successful completion of a product purchase or installment payment so that purchased products are immediately updated in the store and newly enrolled courses appear in the study library without requiring manual refreshes.

#### Scenario: User completes simple product purchase
- **WHEN** user successfully completes a purchase via the product detail screen
- **THEN** the store repository in-memory cache is cleared
- **AND** `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` are invalidated
- **AND** `courseListProvider.notifier.refresh()` is executed to synchronize newly enrolled courses into local database

#### Scenario: User completes installment payment
- **WHEN** user successfully completes an installment payment via the installment sheet
- **THEN** the store repository in-memory cache is cleared
- **AND** `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` are invalidated
- **AND** `courseListProvider.notifier.refresh()` is executed to synchronize newly enrolled courses into local database

### Requirement: Zero-Priced Product Free Label Presentation
The system SHALL display a localized "FREE" label instead of a currency string (such as "₹0.00") on store product cards and the product detail screen whenever a product's price evaluates to zero (`0.00` or `0`). The system SHALL also omit the strikethrough price when the product is free.

#### Scenario: Zero-priced product displayed on Store product card
- **WHEN** a product in the store catalogue has a price of `0.00` or `0`
- **THEN** the product card displays the localized "Free" label in place of the currency formatted price
- **AND** the strikethrough price is not rendered

#### Scenario: Zero-priced product displayed on Product Detail screen
- **WHEN** a user navigates to the product detail screen of a product with price `0.00` or `0`
- **THEN** the header price row displays the localized "Free" label in place of the currency formatted price
- **AND** the strikethrough price is not rendered

#### Scenario: Paid product displayed with standard currency formatting
- **WHEN** a product has a price greater than zero (e.g., `2500.00`)
- **THEN** the product card and product detail screen display `'₹' + price`
- **AND** the strikethrough price is displayed if present

