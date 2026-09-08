## ADDED Requirements

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

