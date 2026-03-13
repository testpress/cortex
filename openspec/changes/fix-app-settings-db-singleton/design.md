# Design: Robust Settings Singleton

## Schema Enforcement
The `AppSettingsTable` must be a hard singleton.

### Primary Key
The `id` field will be defined as:
```dart
IntColumn get id => integer()();
@override
Set<Column> get primaryKey => {id};
```
*Correction*: In Drift, `integer()()` is enough for an auto-increment or primary key if specified, but to be explicit and ensure single-row behavior:
```dart
IntColumn get id => integer()();
@override
Set<Column> get primaryKey => {id};
```

## Migration Path (v5 -> v6)
To avoid data loss while fixing the constraint:
1.  Check for existing duplicate `id=1` rows.
2.  Clean up duplicates leaving only the first one.
3.  Recreate the table structure if Drift's `alterTable` isn't enough for primary key addition.
*Simplified approach for dev*: Drop and recreate the table as it only holds user preferences.

## Atomic Get
The `getAppSettings` method will handle the missing row case:
```dart
Future<AppSettingsTableData> getAppSettings() async {
  return transaction(() async {
    await into(appSettingsTable).insert(
      const AppSettingsTableCompanion(id: Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    return await select(appSettingsTable).getSingle();
  });
}
```
Using a transaction ensures the insert and select happen atomically.
