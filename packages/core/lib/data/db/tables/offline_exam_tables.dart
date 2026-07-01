import 'package:drift/drift.dart';

/// Drift table for tracking offline exam downloads.
class OfflineExamDownloadsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get contentId => text()(); // lesson/content ID (local DB key)
  TextColumn get examId => text()(); // real exam primary key (for API calls)
  TextColumn get questionsJson =>
      text()(); // blob — questions only, no fake attempt
  DateTimeColumn get downloadedAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('DOWNLOADED'))();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  // Status can be: DOWNLOADED, IN_PROGRESS, PENDING_SYNC
}

/// Drift table for offline attempt items (user answers).
class OfflineExamAnswersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get downloadId =>
      integer().references(OfflineExamDownloadsTable, #id)();
  TextColumn get questionId => text()();
  TextColumn get selectedChoices =>
      text().nullable()(); // JSON array of choice IDs
  TextColumn get shortAnswer =>
      text().nullable()(); // For essay or short answer questions
  BoolColumn get review => boolean().withDefault(const Constant(false))();
  DateTimeColumn get savedAt => dateTime()();
  TextColumn get unSyncedFiles =>
      text().nullable()(); // JSON array of local file paths pending upload
}
