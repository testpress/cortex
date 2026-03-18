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
