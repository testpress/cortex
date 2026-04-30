import 'package:drift/drift.dart';

/// Drift table for lessons inside a chapter.
class LessonsTable extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get title => text()();

  /// Stored as string: 'video' | 'pdf' | 'assessment' | 'test'
  TextColumn get type => text()();
  TextColumn get duration => text()();

  /// Stored as string: 'notStarted' | 'inProgress' | 'completed'
  TextColumn get progressStatus =>
      text().withDefault(const Constant('notStarted'))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer()();
  TextColumn get chapterTitle => text().nullable()();

  // New fields for LessonDetailScreen (Phase-2)
  TextColumn get contentUrl => text().nullable()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get subjectName => text().nullable()();
  IntColumn get subjectIndex => integer().nullable()();
  IntColumn get lessonNumber => integer().nullable()();
  IntColumn get totalLessons => integer().nullable()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
  
  // Status flags for localized filtering
  BoolColumn get isRunning => boolean().withDefault(const Constant(false))();
  BoolColumn get isUpcoming => boolean().withDefault(const Constant(false))();
  BoolColumn get hasAttempts => boolean().withDefault(const Constant(false))();
  TextColumn get image => text().nullable()();

  // New fields for LessonDetailShell (v2.4+)
  TextColumn get nextContentId => text().nullable()();
  TextColumn get previousContentId => text().nullable()();
  TextColumn get htmlContent => text().nullable()();
  
  // Live Stream specific fields
  TextColumn get chatEmbedUrl => text().nullable()();
  TextColumn get streamStatus => text().nullable()();
  BoolColumn get showRecordedVideo => boolean().withDefault(const Constant(false))();
  
  BoolColumn get isDetailFetched => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
