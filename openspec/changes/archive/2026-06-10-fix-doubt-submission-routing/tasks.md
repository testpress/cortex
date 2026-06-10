## 1. Data Layer Updates

- [x] 1.1 Update `DoubtRepository.createDoubt` in `packages/discussions/lib/repositories/doubt_repository.dart` to return `Future<String>` instead of `Future<void>`, returning the `id` of the newly created doubt.

## 2. UI Routing Updates

- [x] 2.1 Update `_submitDoubt` in `packages/discussions/lib/screens/ask_doubt_form_screen.dart` to await and capture the returned doubt ID.
- [x] 2.2 Modify the success condition in `_submitDoubt` to call `Navigator.pop(context)` (to close the form/sheet) and then `context.push('/home/discussions/doubts/$newDoubtId')` to navigate to the new doubt detail screen.
- [x] 2.3 Modify the error condition in `_submitDoubt` to call `Navigator.pop(context)` to dismiss the form along with displaying the error toast message.
