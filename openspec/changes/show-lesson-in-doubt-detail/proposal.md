## Why

When viewing a doubt in the detail screen, users currently cannot see which lesson the doubt is related to. Displaying the lesson title will provide essential context, helping users and mentors understand exactly where the student encountered an issue.

## What Changes

- Add a UI component in the Doubt Detail screen to display the related lesson's title if a `lessonId` is present in the `DoubtDto`.
- Fetch the lesson details or title using the `lessonId` associated with the doubt.

## Capabilities

### New Capabilities

### Modified Capabilities
- `doubt-thread-detail`: Update to display the lesson context (lesson title) associated with the doubt.

## Impact

- `DoubtDetailScreen` UI will have a new lesson context badge or title.
- Data layer might need a new provider or method to fetch a lesson's title from its `lessonId` if not already available.
