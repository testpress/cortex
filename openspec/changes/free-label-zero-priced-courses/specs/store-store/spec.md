## ADDED Requirements

### Requirement: Zero-Priced Product Free Label Presentation
The system SHALL display a localized "Free" label instead of a currency string (such as "₹0.00") on store product cards and the product detail screen whenever a product's price evaluates to zero (`0.00`, `0`, or `<= 0`). The system SHALL also omit the strikethrough price when the product is free.

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
