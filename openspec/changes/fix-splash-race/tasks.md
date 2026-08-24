## 1. Bootstrap State Provider

- [x] 1.1 Create `BootstrapState` enum (`loading`, `unauthenticated`, `authenticated`) in `packages/testpress/lib/navigation/bootstrap_provider.dart`
- [x] 1.2 Implement `bootstrapProvider` to watch `authProvider` and `instituteSettingsProvider`
- [x] 1.3 Ensure `bootstrapProvider` transitions out of `loading` only when both underlying dependencies have stable non-loading values

## 2. Refactor Routing Logic

- [x] 2.1 Update `AuthRoutes.redirect` in `packages/testpress/lib/navigation/routes/auth_routes.dart` to depend on `bootstrapProvider`
- [x] 2.2 Implement redirect rules: `loading` stays on `/onboarding`, `unauthenticated` forces `/login`, `authenticated` moves off auth routes to `/home`
- [x] 2.3 Update `goRouterProvider` in `packages/testpress/lib/navigation/app_router.dart` to refresh on `bootstrapProvider` changes

## 3. Onboarding Screen Cleanup

- [x] 3.1 Convert `OnboardingScreen` in `packages/profile/lib/screens/onboarding_screen.dart` from a `ConsumerStatefulWidget` to a `StatelessWidget`
- [x] 3.2 Remove all manual `_navigateToLogin` hooks, state properties, and provider listeners
- [x] 3.3 Verify the screen solely renders the splash image without executing any navigation commands
