## Architecture: 3-Layer Ownership

To keep it simple and clean, we follow a clear responsibility model:

1.  **STORAGE LAYER (The Vaults)**:
    *   **`SessionStorage`**: Owns **Auth Tokens** (`accessToken`, `refreshToken`). It's fast and transient.
    *   **`AppDatabase (UsersTable)`**: Owns **Identity Record** (`UserDto`). It's structured and permanent.

2.  **API LAYER (The Messenger)**:
    *   **`AuthClient`**: Owns **Networking**. It converts raw JSON from endpoints into our internal DTOs.
    *   **`AuthInterceptor`**: Simple Dio middleware that reads the token from `SessionStorage` and adds it to headers for every request.

3.  **REPOSITORY LAYER (The Brain)**:
    *   **`UserRepository`**: Owns **Sync Logic**. When a user logs in:
        *   Tells `SessionStorage` to save the token.
        *   Tells `AppDatabase` to save the user profile.
        *   Updates the `AuthNotifier` state.

## Database Schema: `UsersTable`

Minimalist schema in `packages/core/lib/data/db/tables/users_table.dart`:

```dart
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatar => text().nullable()();
  BoolColumn get isPro => boolean().withDefault(const Constant(false))();
  DateTimeColumn get joinedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

## Auth Interceptor Logic

Keep it logic-less:
```dart
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  final token = SessionStorage.instance.accessToken;
  if (token != null) {
    options.headers['Authorization'] = 'JWT $token';
  }
  handler.next(options);
}
```

## State Management

*   **`authProvider`**: A simple `StateNotifier` that watches for changes.
*   **Initialization**: On app start, the `initializationProvider` checks `SessionStorage`. If a token exists, it fetches the user from `AppDatabase` and sets the `authProvider` state immediately.

## Enhancements (Post v1)

### Auth Ownership Refinement

- **`AuthService`**: Owns login, OTP generation, OTP verification, and logout orchestration.
- **`SessionManager`**: Owns session hydration, profile refresh TTL checks, and token lifecycle coordination.
- **`authProvider`**: Owns reactive auth state only, delegating workflow logic to the service layer.

### Typed Auth Transport

- Replace raw map responses in `AuthClient` for login and OTP verification with a typed token response object.
- Continue fetching full `UserDto` separately via profile endpoint to match backend payload boundaries.

### Secure Storage Partitioning

- Persist secrets (`authToken`, `refreshToken`) in `flutter_secure_storage`.
- Keep non-sensitive metadata (`profile_synced_at`) in `shared_preferences`.

### UI Integration Consistency

- Login and OTP screens should invoke `authProvider` actions, not direct mock client instances.

## Enhancements (Post v2)

### Target Flow (Simplified)

`UI -> AuthProvider -> AuthRepository`

Inside `AuthRepository`:
- `AuthApiService` (network calls via Dio)
- `Profile identity contract` (implemented in `packages/profile`)
- `SessionStore` (`SessionStorage` + `SessionManager`)

### Responsibility Split

- **AuthProvider**
  - Owns reactive `AuthState` only.
  - Delegates workflows to repository.
- **AuthRepository**
  - Owns login, OTP generation, OTP verification, hydration, logout.
  - Coordinates API calls, session persistence, and current-user sync trigger.
- **AuthApiService**
  - Owns HTTP concerns only (endpoint paths, payloads, response parsing, error mapping).
- **Profile package (`packages/profile`)**
  - Owns `UserRepository`, `UserApiService`, and user profile cache/read/write.
  - Exposes `getCurrentUser()` semantics: return cached user when available and
    refresh from API asynchronously.
- **SessionStore**
  - Owns token lifecycle and session metadata.

### Architecture Corrections from Current State

- Remove direct auth orchestration leakage across multiple layers.
- Remove auth/profile-refresh dependence on generic `DataSource`.
- Keep mock switching as a domain-level decision; auth real API integration should
  use dedicated auth service + repository flow.
- Enforce package boundaries: `Auth*` in `core`, `User/Profile*` in `profile`.
- Route profile synchronization through an explicit contract abstraction to keep
  auth orchestration decoupled from profile implementation details.
- Keep error categorization and API-message extraction in `AuthException` so the
  API service remains transport-focused.
- On fresh install, clear secure storage before hydration to avoid stale iOS
  keychain auth restoration.
