## Why

Currently, when a user successfully submits a doubt, the application simply pops the current screen, returning them to the previous screen (such as the lesson detail screen). However, to provide a better user experience, we want to immediately navigate the user to the newly created doubt's detail screen upon successful submission. In the event of an error, we should pop the form screen and return the user to the previous screen with an error toast message.

## What Changes

- **Modified**: Update the success navigation logic in `AskDoubtFormScreen`. Instead of just popping, it will navigate to the newly created doubt's detail screen.
- **Modified**: Update the failure navigation logic in `AskDoubtFormScreen`. Instead of keeping the form open, it will pop back to the previous screen and display an error toast message.
- **Modified**: Update the `createDoubt` method in `DoubtRepository` to return the newly created `Doubt` or its `id` if it doesn't already, so the router can navigate to it.

## Capabilities

### New Capabilities

### Modified Capabilities
- `doubts-compose-ui`: The submission behavior is changing to include redirection to the doubt detail screen upon success, and popping the form upon error.

## Impact

- **packages/discussions**: The `ask_doubt_form_screen.dart` will be modified.
- **DoubtRepository**: May need an API signature update to return the created doubt.
- **Routing**: Will involve the `go_router` paths for navigating to the doubt detail screen.
