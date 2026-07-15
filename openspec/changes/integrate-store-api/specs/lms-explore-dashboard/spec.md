## MODIFIED Requirements

### Requirement: Course Discovery Sections
The system SHALL display store products fetched from the API instead of static mock discovery sections. The products should be rendered in a list or grid to facilitate marketplace browsing.

#### Scenario: Viewing product details from discovery
- **WHEN** the user selects a product card from the store listing
- **THEN** the system SHALL present the product purchase details (or plan selection if it is a subscription)

### Requirement: Quick Access Filtering
The system SHALL provide a horizontal list of interactive "pills" representing Store Categories (fetched from `/api/v2.5/products/categories/`) that allow the user to filter the products displayed on the page.

#### Scenario: Tapping a category pill
- **WHEN** the user taps a specific category pill in the filter bar
- **THEN** the system SHALL re-fetch and display products for that category

## REMOVED Requirements

### Requirement: Popular Tests Data Fetching
**Reason**: The Explore page is pivoting to a Store/Marketplace displaying real products.
**Migration**: Removed from the Explore page. Tests will be accessed via purchased products.

### Requirement: Featured Content Carousel
**Reason**: Removed in favor of prioritizing real products and categories at the top of the storefront.
**Migration**: N/A.
