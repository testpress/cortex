## 1. Modify Routing Configuration

- [x] 1.1 In `packages/testpress/lib/navigation/app_router.dart`, locate the `course/:courseId/chapters` routes (both under the Study and Exams branches) and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.2 In `app_router.dart`, locate the `lesson/:id` route and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.3 In `app_router.dart`, locate the `test/:id` routes and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.4 In `app_router.dart`, locate the `assessment/:id` routes and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.5 In `app_router.dart`, locate the `discussions/forum/posts/:courseId` route and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.6 In `app_router.dart`, locate the `discussions/doubts` route and add `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.7 Ensure all nested sub-routes (e.g., `:chapterId`, `:threadId`, `player`, `review-analytics`) also use `parentNavigatorKey: _rootNavigatorKey`.
- [x] 1.8 Move all Hamburger Menu / Drawer related routes (Forum Selection, Downloads, Typography Gallery) and Profile sub-routes (Notifications, Edit, Settings, Certificates) to the root navigator.

## 2. Verification

- [ ] 2.1 Verify that navigating to a video lesson hides the bottom navigation bar and that pressing back properly disposes the video player, resolving the memory leak and background audio issue.
- [ ] 2.2 Verify that navigating to the forum or doubt details page hides the bottom navigation bar and provides an immersive view.
- [ ] 2.3 Ensure deep links and sub-routing parameters continue functioning as expected when pushed onto the root navigator.
