import 'package:drift/drift.dart';

enum DashboardSectionType { whatsNew, resumeLearning, recentlyCompleted }

enum DashboardContentType {
  video,
  pdf,
  notes,
  test,
  assessment,
  liveStream,
  attachment,
  embedContent,
  unknown
}

@DataClassName('DashboardContentData')
class DashboardContentsTable extends Table {
  TextColumn get lessonId => text()();
  IntColumn get sectionType => intEnum<DashboardSectionType>()();
  IntColumn get lessonType => intEnum<DashboardContentType>()();
  TextColumn get title => text()();
  TextColumn get chapterId => text().nullable()();
  TextColumn get chapterTitle => text().nullable()();
  TextColumn get totalDuration => text().nullable()();
  TextColumn get remainingDuration => text().nullable()();
  TextColumn get coverImage => text().nullable()();
  RealColumn get progress => real().nullable()();
  IntColumn get displayOrder => integer()();

  @override
  Set<Column> get primaryKey => {lessonId, sectionType};
}


class DashboardBannersTable extends Table {
  TextColumn get id => text()();
  TextColumn get imageUrl => text()();
  TextColumn get title => text().nullable()();
  TextColumn get link => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get bgColor => integer().nullable()();
  IntColumn get textColor => integer().nullable()();
  TextColumn get tag => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


@DataClassName('LearnersTableData')
class LearnersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text()();
  RealColumn get points => real()();
  IntColumn get rank => integer()();
  IntColumn get coursesCompleted => integer().withDefault(const Constant(0))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
