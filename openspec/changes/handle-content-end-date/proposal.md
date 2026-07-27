## Why
We need to handle course content end dates correctly so that users cannot access expired content. Currently, when content expires, the UI may not accurately reflect the expiration state. Adding `end` and `has_ended` fields to our model and UI ensures proper access control and better user experience.

## What Changes
- Add `end` (DateTime or String representing date) and `has_ended` (boolean) to the Content model.
- Prevent opening of the content if `has_ended` is true and instead show a toast: "Your access to this content has ended!"
- Update the list item UI for ended content to display a lock icon and text: "Access expired on <end_date>".

## Capabilities

### New Capabilities
- `content-expiration`: Handles the logic and UI representation of content that has reached its end date, preventing access and showing expiration details.

### Modified Capabilities

## Impact
- Content Model parsing logic
- Content list item widget (UI)
- Content click handler (to check `has_ended` before opening and show toast)
