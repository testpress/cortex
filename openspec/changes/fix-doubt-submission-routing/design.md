## Context

Currently, the `AskDoubtFormScreen` dismisses itself by calling `Navigator.pop(context)` upon successful doubt creation. This leaves the user on the screen they originated from (e.g., the lesson detail screen). To improve the user experience, we want to immediately take the user to the detail screen of the newly created doubt. On error, we want to ensure the form pops and an error toast is displayed.

## Goals / Non-Goals

**Goals:**
- Navigate to the doubt detail screen (`/home/discussions/doubts/:id`) upon successful doubt submission.
- Ensure the form pops correctly and shows an error message upon failure, returning the user to the previous screen.

**Non-Goals:**
- Changes to the doubt list screen or doubt detail UI.
- Changes to the underlying HTTP API request formats.

## Decisions

1. **Update `DoubtRepository.createDoubt` Return Type**
   - **Rationale**: Currently, `DoubtRepository.createDoubt` returns `Future<void>`. To navigate to the newly created doubt, we need its ID. The `_dataSource.createDoubt` already returns a `DoubtDto`, so we just need to pass the ID back up.
   - **Decision**: Change the return type of `DoubtRepository.createDoubt` to `Future<String>` to return the newly created doubt's ID.

2. **Navigation Flow in `AskDoubtFormScreen`**
   - **Success**: We will first call `Navigator.pop(context)` to close the form, then call `context.push('/home/discussions/doubts/$newDoubtId')` so the doubt detail screen is pushed onto the navigator stack. This allows the user to press "Back" from the doubt detail to return to the lesson detail.
   - **Failure**: Instead of keeping the form open (`_isSubmitting = false`), we will `Navigator.pop(context)` out of the form entirely and display the error toast.

## Risks / Trade-offs

- **Risk**: Popping and immediately pushing might cause a slight visual jitter in the UI navigation transition.
  - **Mitigation**: Standard Flutter navigation handles this gracefully, but if needed, we can use `context.pushReplacement` to replace the form screen with the detail screen directly. Popping and pushing is preferred to maintain a clean navigation stack (`Lesson Detail -> Doubt Detail`).
