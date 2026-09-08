## Why

On the Store page, the bottom-most product cards are partially obscured behind the persistent floating bottom navigation bar when scrolled to the end of the page because trailing bottom clearance is missing. Adding bottom spacing allows users to scroll all content completely into view.

## What Changes

- Add trailing bottom clearance sliver (`SizedBox(height: 120)`) to the `CustomScrollView` in `StorePage`, matching the bottom clearance pattern used in `StudyScreen`, `ExamsScreen`, and `InfoPage`.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `store-store`: Update Store page scrollable area requirements to ensure bottom content clears the floating bottom navigation bar when fully scrolled.

## Impact

- **Affected Code**: `packages/courses/lib/screens/store/store_page.dart`
- **Tests**: `packages/courses/test/screens/store/store_page_test.dart`
