## ADDED Requirements

### Requirement: Automatic Store Refresh On Successful Purchase
The system SHALL automatically clear the store repository cache and invalidate store products and category providers upon successful completion of a product purchase or installment payment so that purchased products are immediately updated in the store without requiring a manual page refresh.

#### Scenario: User completes simple product purchase
- **WHEN** user successfully completes a purchase via the product detail screen
- **THEN** the store repository in-memory cache is cleared
- **AND** `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` are invalidated

#### Scenario: User completes installment payment
- **WHEN** user successfully completes an installment payment via the installment sheet
- **THEN** the store repository in-memory cache is cleared
- **AND** `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` are invalidated
