# Design: Robust Settings Singleton

## Schema Enforcement
The `AppSettingsTable` must be a hard singleton.

### Primary Key
The `id` field must be defined as an explicit Primary Key to prevent row multiplicity. While Drift's `integer().autoIncrement()` is a common shortcut for primary keys, since we manage the `id` manually (fixed at `1`), we use an explicit override:

```dart
IntColumn get id => integer()();

@override
Set<Column> get primaryKey => {id};
```

## Migration Path (v5 -> v6)
To ensure zero data loss during the schema upgrade:
1.  **Backup**: Read existing settings from the old table using `customSelect`.
2.  **Schema Update**: Drop and recreate the `app_settings_table` to apply the Primary Key constraint.
3.  **Restore**: Re-insert the backed-up settings into the newly created table.

This non-destructive approach preserves user preferences across the mandatory upgrade.

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
