# Proposal: Fix App Settings Database Singleton

## Problem
The `AppSettingsTable` used for persistent settings lacks a Primary Key constraint on the `id` column. Additionally, multiple Providers (Appearance, Playback, Accessibility) attempt to initialize the settings row simultaneously on the App Settings screen. This leads to race conditions where multiple rows with `id: 1` might be created, or `getSingle()` fails, resulting in a "Something went wrong" error for the user.

## Proposed Change
1.  **Enforce Singleton Pattern**: Update `AppSettingsTable` to explicitly define the `id` column as a Primary Key.
2.  **Database Migration**: Bump the schema version to 6 and add a migration to recreate the `app_settings_table` with the primary key constraint and clear any duplicate data.
3.  **Atomic Initialization**: Refactor `AppDatabase.getAppSettings()` to use a more robust insert-or-ignore strategy to ensure only one row exists.

## Scope
- `packages/core/lib/data/db/tables/app_settings_table.dart`
- `packages/core/lib/data/db/app_database.dart`
