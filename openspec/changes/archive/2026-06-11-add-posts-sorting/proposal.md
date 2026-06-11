## Why
The `/api/v3/posts/` endpoint currently returns posts ordered by database ID, which causes older posts to appear first. We need to request posts ordered by `-published_date` (newest first) to match the web application's behavior and improve the visibility of recent announcements.

## What Changes
- Update the `getPosts` method in `http_data_source.dart` to include an `ordering` query parameter.
- The `ordering` parameter will be set to `-published_date` by default to fetch the newest posts first.

## Capabilities
### New Capabilities
- `posts-sorting`: Adds sorting support when fetching posts from the API.

### Modified Capabilities

## Impact
- `packages/core/lib/data/sources/http_data_source.dart`: The API call will be updated to include the `ordering=-published_date` query parameter.
