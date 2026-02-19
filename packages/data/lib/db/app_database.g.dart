// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTableTable extends CoursesTable
    with TableInfo<$CoursesTableTable, CoursesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorIndexMeta =
      const VerificationMeta('colorIndex');
  @override
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
      'color_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterCountMeta =
      const VerificationMeta('chapterCount');
  @override
  late final GeneratedColumn<int> chapterCount = GeneratedColumn<int>(
      'chapter_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalDurationMeta =
      const VerificationMeta('totalDuration');
  @override
  late final GeneratedColumn<String> totalDuration = GeneratedColumn<String>(
      'total_duration', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedLessonsMeta =
      const VerificationMeta('completedLessons');
  @override
  late final GeneratedColumn<int> completedLessons = GeneratedColumn<int>(
      'completed_lessons', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalLessonsMeta =
      const VerificationMeta('totalLessons');
  @override
  late final GeneratedColumn<int> totalLessons = GeneratedColumn<int>(
      'total_lessons', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        colorIndex,
        chapterCount,
        totalDuration,
        progress,
        completedLessons,
        totalLessons
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses_table';
  @override
  VerificationContext validateIntegrity(Insertable<CoursesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
          _colorIndexMeta,
          colorIndex.isAcceptableOrUnknown(
              data['color_index']!, _colorIndexMeta));
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('chapter_count')) {
      context.handle(
          _chapterCountMeta,
          chapterCount.isAcceptableOrUnknown(
              data['chapter_count']!, _chapterCountMeta));
    } else if (isInserting) {
      context.missing(_chapterCountMeta);
    }
    if (data.containsKey('total_duration')) {
      context.handle(
          _totalDurationMeta,
          totalDuration.isAcceptableOrUnknown(
              data['total_duration']!, _totalDurationMeta));
    } else if (isInserting) {
      context.missing(_totalDurationMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('completed_lessons')) {
      context.handle(
          _completedLessonsMeta,
          completedLessons.isAcceptableOrUnknown(
              data['completed_lessons']!, _completedLessonsMeta));
    }
    if (data.containsKey('total_lessons')) {
      context.handle(
          _totalLessonsMeta,
          totalLessons.isAcceptableOrUnknown(
              data['total_lessons']!, _totalLessonsMeta));
    } else if (isInserting) {
      context.missing(_totalLessonsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoursesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoursesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      colorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_index'])!,
      chapterCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_count'])!,
      totalDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}total_duration'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      completedLessons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_lessons'])!,
      totalLessons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_lessons'])!,
    );
  }

  @override
  $CoursesTableTable createAlias(String alias) {
    return $CoursesTableTable(attachedDatabase, alias);
  }
}

class CoursesTableData extends DataClass
    implements Insertable<CoursesTableData> {
  final String id;
  final String title;
  final int colorIndex;
  final int chapterCount;
  final String totalDuration;
  final int progress;
  final int completedLessons;
  final int totalLessons;
  const CoursesTableData(
      {required this.id,
      required this.title,
      required this.colorIndex,
      required this.chapterCount,
      required this.totalDuration,
      required this.progress,
      required this.completedLessons,
      required this.totalLessons});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['color_index'] = Variable<int>(colorIndex);
    map['chapter_count'] = Variable<int>(chapterCount);
    map['total_duration'] = Variable<String>(totalDuration);
    map['progress'] = Variable<int>(progress);
    map['completed_lessons'] = Variable<int>(completedLessons);
    map['total_lessons'] = Variable<int>(totalLessons);
    return map;
  }

  CoursesTableCompanion toCompanion(bool nullToAbsent) {
    return CoursesTableCompanion(
      id: Value(id),
      title: Value(title),
      colorIndex: Value(colorIndex),
      chapterCount: Value(chapterCount),
      totalDuration: Value(totalDuration),
      progress: Value(progress),
      completedLessons: Value(completedLessons),
      totalLessons: Value(totalLessons),
    );
  }

  factory CoursesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoursesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      colorIndex: serializer.fromJson<int>(json['colorIndex']),
      chapterCount: serializer.fromJson<int>(json['chapterCount']),
      totalDuration: serializer.fromJson<String>(json['totalDuration']),
      progress: serializer.fromJson<int>(json['progress']),
      completedLessons: serializer.fromJson<int>(json['completedLessons']),
      totalLessons: serializer.fromJson<int>(json['totalLessons']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'colorIndex': serializer.toJson<int>(colorIndex),
      'chapterCount': serializer.toJson<int>(chapterCount),
      'totalDuration': serializer.toJson<String>(totalDuration),
      'progress': serializer.toJson<int>(progress),
      'completedLessons': serializer.toJson<int>(completedLessons),
      'totalLessons': serializer.toJson<int>(totalLessons),
    };
  }

  CoursesTableData copyWith(
          {String? id,
          String? title,
          int? colorIndex,
          int? chapterCount,
          String? totalDuration,
          int? progress,
          int? completedLessons,
          int? totalLessons}) =>
      CoursesTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        colorIndex: colorIndex ?? this.colorIndex,
        chapterCount: chapterCount ?? this.chapterCount,
        totalDuration: totalDuration ?? this.totalDuration,
        progress: progress ?? this.progress,
        completedLessons: completedLessons ?? this.completedLessons,
        totalLessons: totalLessons ?? this.totalLessons,
      );
  CoursesTableData copyWithCompanion(CoursesTableCompanion data) {
    return CoursesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      colorIndex:
          data.colorIndex.present ? data.colorIndex.value : this.colorIndex,
      chapterCount: data.chapterCount.present
          ? data.chapterCount.value
          : this.chapterCount,
      totalDuration: data.totalDuration.present
          ? data.totalDuration.value
          : this.totalDuration,
      progress: data.progress.present ? data.progress.value : this.progress,
      completedLessons: data.completedLessons.present
          ? data.completedLessons.value
          : this.completedLessons,
      totalLessons: data.totalLessons.present
          ? data.totalLessons.value
          : this.totalLessons,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('chapterCount: $chapterCount, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('progress: $progress, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('totalLessons: $totalLessons')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, colorIndex, chapterCount,
      totalDuration, progress, completedLessons, totalLessons);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoursesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.colorIndex == this.colorIndex &&
          other.chapterCount == this.chapterCount &&
          other.totalDuration == this.totalDuration &&
          other.progress == this.progress &&
          other.completedLessons == this.completedLessons &&
          other.totalLessons == this.totalLessons);
}

class CoursesTableCompanion extends UpdateCompanion<CoursesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> colorIndex;
  final Value<int> chapterCount;
  final Value<String> totalDuration;
  final Value<int> progress;
  final Value<int> completedLessons;
  final Value<int> totalLessons;
  final Value<int> rowid;
  const CoursesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.chapterCount = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedLessons = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesTableCompanion.insert({
    required String id,
    required String title,
    required int colorIndex,
    required int chapterCount,
    required String totalDuration,
    this.progress = const Value.absent(),
    this.completedLessons = const Value.absent(),
    required int totalLessons,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        colorIndex = Value(colorIndex),
        chapterCount = Value(chapterCount),
        totalDuration = Value(totalDuration),
        totalLessons = Value(totalLessons);
  static Insertable<CoursesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? colorIndex,
    Expression<int>? chapterCount,
    Expression<String>? totalDuration,
    Expression<int>? progress,
    Expression<int>? completedLessons,
    Expression<int>? totalLessons,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (colorIndex != null) 'color_index': colorIndex,
      if (chapterCount != null) 'chapter_count': chapterCount,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (progress != null) 'progress': progress,
      if (completedLessons != null) 'completed_lessons': completedLessons,
      if (totalLessons != null) 'total_lessons': totalLessons,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? colorIndex,
      Value<int>? chapterCount,
      Value<String>? totalDuration,
      Value<int>? progress,
      Value<int>? completedLessons,
      Value<int>? totalLessons,
      Value<int>? rowid}) {
    return CoursesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      colorIndex: colorIndex ?? this.colorIndex,
      chapterCount: chapterCount ?? this.chapterCount,
      totalDuration: totalDuration ?? this.totalDuration,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (chapterCount.present) {
      map['chapter_count'] = Variable<int>(chapterCount.value);
    }
    if (totalDuration.present) {
      map['total_duration'] = Variable<String>(totalDuration.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (completedLessons.present) {
      map['completed_lessons'] = Variable<int>(completedLessons.value);
    }
    if (totalLessons.present) {
      map['total_lessons'] = Variable<int>(totalLessons.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('chapterCount: $chapterCount, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('progress: $progress, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTableTable extends ChaptersTable
    with TableInfo<$ChaptersTableTable, ChaptersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
      'course_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonCountMeta =
      const VerificationMeta('lessonCount');
  @override
  late final GeneratedColumn<int> lessonCount = GeneratedColumn<int>(
      'lesson_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _assessmentCountMeta =
      const VerificationMeta('assessmentCount');
  @override
  late final GeneratedColumn<int> assessmentCount = GeneratedColumn<int>(
      'assessment_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, courseId, title, lessonCount, assessmentCount, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChaptersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('lesson_count')) {
      context.handle(
          _lessonCountMeta,
          lessonCount.isAcceptableOrUnknown(
              data['lesson_count']!, _lessonCountMeta));
    } else if (isInserting) {
      context.missing(_lessonCountMeta);
    }
    if (data.containsKey('assessment_count')) {
      context.handle(
          _assessmentCountMeta,
          assessmentCount.isAcceptableOrUnknown(
              data['assessment_count']!, _assessmentCountMeta));
    } else if (isInserting) {
      context.missing(_assessmentCountMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChaptersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}course_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      lessonCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson_count'])!,
      assessmentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assessment_count'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $ChaptersTableTable createAlias(String alias) {
    return $ChaptersTableTable(attachedDatabase, alias);
  }
}

class ChaptersTableData extends DataClass
    implements Insertable<ChaptersTableData> {
  final String id;
  final String courseId;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final int orderIndex;
  const ChaptersTableData(
      {required this.id,
      required this.courseId,
      required this.title,
      required this.lessonCount,
      required this.assessmentCount,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['lesson_count'] = Variable<int>(lessonCount);
    map['assessment_count'] = Variable<int>(assessmentCount);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  ChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ChaptersTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      lessonCount: Value(lessonCount),
      assessmentCount: Value(assessmentCount),
      orderIndex: Value(orderIndex),
    );
  }

  factory ChaptersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChaptersTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      lessonCount: serializer.fromJson<int>(json['lessonCount']),
      assessmentCount: serializer.fromJson<int>(json['assessmentCount']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'title': serializer.toJson<String>(title),
      'lessonCount': serializer.toJson<int>(lessonCount),
      'assessmentCount': serializer.toJson<int>(assessmentCount),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  ChaptersTableData copyWith(
          {String? id,
          String? courseId,
          String? title,
          int? lessonCount,
          int? assessmentCount,
          int? orderIndex}) =>
      ChaptersTableData(
        id: id ?? this.id,
        courseId: courseId ?? this.courseId,
        title: title ?? this.title,
        lessonCount: lessonCount ?? this.lessonCount,
        assessmentCount: assessmentCount ?? this.assessmentCount,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  ChaptersTableData copyWithCompanion(ChaptersTableCompanion data) {
    return ChaptersTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      lessonCount:
          data.lessonCount.present ? data.lessonCount.value : this.lessonCount,
      assessmentCount: data.assessmentCount.present
          ? data.assessmentCount.value
          : this.assessmentCount,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('assessmentCount: $assessmentCount, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, courseId, title, lessonCount, assessmentCount, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChaptersTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.lessonCount == this.lessonCount &&
          other.assessmentCount == this.assessmentCount &&
          other.orderIndex == this.orderIndex);
}

class ChaptersTableCompanion extends UpdateCompanion<ChaptersTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<int> lessonCount;
  final Value<int> assessmentCount;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.assessmentCount = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required int lessonCount,
    required int assessmentCount,
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        courseId = Value(courseId),
        title = Value(title),
        lessonCount = Value(lessonCount),
        assessmentCount = Value(assessmentCount),
        orderIndex = Value(orderIndex);
  static Insertable<ChaptersTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<int>? lessonCount,
    Expression<int>? assessmentCount,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (lessonCount != null) 'lesson_count': lessonCount,
      if (assessmentCount != null) 'assessment_count': assessmentCount,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? courseId,
      Value<String>? title,
      Value<int>? lessonCount,
      Value<int>? assessmentCount,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      lessonCount: lessonCount ?? this.lessonCount,
      assessmentCount: assessmentCount ?? this.assessmentCount,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lessonCount.present) {
      map['lesson_count'] = Variable<int>(lessonCount.value);
    }
    if (assessmentCount.present) {
      map['assessment_count'] = Variable<int>(assessmentCount.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('assessmentCount: $assessmentCount, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTableTable extends LessonsTable
    with TableInfo<$LessonsTableTable, LessonsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
      'duration', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressStatusMeta =
      const VerificationMeta('progressStatus');
  @override
  late final GeneratedColumn<String> progressStatus = GeneratedColumn<String>(
      'progress_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('notStarted'));
  static const VerificationMeta _isLockedMeta =
      const VerificationMeta('isLocked');
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
      'is_locked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_locked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chapterId,
        title,
        type,
        duration,
        progressStatus,
        isLocked,
        orderIndex
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons_table';
  @override
  VerificationContext validateIntegrity(Insertable<LessonsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('progress_status')) {
      context.handle(
          _progressStatusMeta,
          progressStatus.isAcceptableOrUnknown(
              data['progress_status']!, _progressStatusMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration'])!,
      progressStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}progress_status'])!,
      isLocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_locked'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $LessonsTableTable createAlias(String alias) {
    return $LessonsTableTable(attachedDatabase, alias);
  }
}

class LessonsTableData extends DataClass
    implements Insertable<LessonsTableData> {
  final String id;
  final String chapterId;
  final String title;

  /// Stored as string: 'video' | 'pdf' | 'assessment' | 'test'
  final String type;
  final String duration;

  /// Stored as string: 'notStarted' | 'inProgress' | 'completed'
  final String progressStatus;
  final bool isLocked;
  final int orderIndex;
  const LessonsTableData(
      {required this.id,
      required this.chapterId,
      required this.title,
      required this.type,
      required this.duration,
      required this.progressStatus,
      required this.isLocked,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['duration'] = Variable<String>(duration);
    map['progress_status'] = Variable<String>(progressStatus);
    map['is_locked'] = Variable<bool>(isLocked);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  LessonsTableCompanion toCompanion(bool nullToAbsent) {
    return LessonsTableCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      title: Value(title),
      type: Value(type),
      duration: Value(duration),
      progressStatus: Value(progressStatus),
      isLocked: Value(isLocked),
      orderIndex: Value(orderIndex),
    );
  }

  factory LessonsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonsTableData(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      duration: serializer.fromJson<String>(json['duration']),
      progressStatus: serializer.fromJson<String>(json['progressStatus']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'duration': serializer.toJson<String>(duration),
      'progressStatus': serializer.toJson<String>(progressStatus),
      'isLocked': serializer.toJson<bool>(isLocked),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  LessonsTableData copyWith(
          {String? id,
          String? chapterId,
          String? title,
          String? type,
          String? duration,
          String? progressStatus,
          bool? isLocked,
          int? orderIndex}) =>
      LessonsTableData(
        id: id ?? this.id,
        chapterId: chapterId ?? this.chapterId,
        title: title ?? this.title,
        type: type ?? this.type,
        duration: duration ?? this.duration,
        progressStatus: progressStatus ?? this.progressStatus,
        isLocked: isLocked ?? this.isLocked,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  LessonsTableData copyWithCompanion(LessonsTableCompanion data) {
    return LessonsTableData(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      duration: data.duration.present ? data.duration.value : this.duration,
      progressStatus: data.progressStatus.present
          ? data.progressStatus.value
          : this.progressStatus,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableData(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('duration: $duration, ')
          ..write('progressStatus: $progressStatus, ')
          ..write('isLocked: $isLocked, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chapterId, title, type, duration,
      progressStatus, isLocked, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonsTableData &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.title == this.title &&
          other.type == this.type &&
          other.duration == this.duration &&
          other.progressStatus == this.progressStatus &&
          other.isLocked == this.isLocked &&
          other.orderIndex == this.orderIndex);
}

class LessonsTableCompanion extends UpdateCompanion<LessonsTableData> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> title;
  final Value<String> type;
  final Value<String> duration;
  final Value<String> progressStatus;
  final Value<bool> isLocked;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const LessonsTableCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.duration = const Value.absent(),
    this.progressStatus = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsTableCompanion.insert({
    required String id,
    required String chapterId,
    required String title,
    required String type,
    required String duration,
    this.progressStatus = const Value.absent(),
    this.isLocked = const Value.absent(),
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chapterId = Value(chapterId),
        title = Value(title),
        type = Value(type),
        duration = Value(duration),
        orderIndex = Value(orderIndex);
  static Insertable<LessonsTableData> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? duration,
    Expression<String>? progressStatus,
    Expression<bool>? isLocked,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (duration != null) 'duration': duration,
      if (progressStatus != null) 'progress_status': progressStatus,
      if (isLocked != null) 'is_locked': isLocked,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? chapterId,
      Value<String>? title,
      Value<String>? type,
      Value<String>? duration,
      Value<String>? progressStatus,
      Value<bool>? isLocked,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return LessonsTableCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      progressStatus: progressStatus ?? this.progressStatus,
      isLocked: isLocked ?? this.isLocked,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (progressStatus.present) {
      map['progress_status'] = Variable<String>(progressStatus.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('duration: $duration, ')
          ..write('progressStatus: $progressStatus, ')
          ..write('isLocked: $isLocked, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LiveClassesTableTable extends LiveClassesTable
    with TableInfo<$LiveClassesTableTable, LiveClassesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiveClassesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _facultyMeta =
      const VerificationMeta('faculty');
  @override
  late final GeneratedColumn<String> faculty = GeneratedColumn<String>(
      'faculty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, subject, topic, time, faculty, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'live_classes_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LiveClassesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('faculty')) {
      context.handle(_facultyMeta,
          faculty.isAcceptableOrUnknown(data['faculty']!, _facultyMeta));
    } else if (isInserting) {
      context.missing(_facultyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LiveClassesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiveClassesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      faculty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}faculty'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $LiveClassesTableTable createAlias(String alias) {
    return $LiveClassesTableTable(attachedDatabase, alias);
  }
}

class LiveClassesTableData extends DataClass
    implements Insertable<LiveClassesTableData> {
  final String id;
  final String subject;
  final String topic;
  final String time;
  final String faculty;

  /// Stored as string: 'completed' | 'live' | 'upcoming'
  final String status;
  const LiveClassesTableData(
      {required this.id,
      required this.subject,
      required this.topic,
      required this.time,
      required this.faculty,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject'] = Variable<String>(subject);
    map['topic'] = Variable<String>(topic);
    map['time'] = Variable<String>(time);
    map['faculty'] = Variable<String>(faculty);
    map['status'] = Variable<String>(status);
    return map;
  }

  LiveClassesTableCompanion toCompanion(bool nullToAbsent) {
    return LiveClassesTableCompanion(
      id: Value(id),
      subject: Value(subject),
      topic: Value(topic),
      time: Value(time),
      faculty: Value(faculty),
      status: Value(status),
    );
  }

  factory LiveClassesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiveClassesTableData(
      id: serializer.fromJson<String>(json['id']),
      subject: serializer.fromJson<String>(json['subject']),
      topic: serializer.fromJson<String>(json['topic']),
      time: serializer.fromJson<String>(json['time']),
      faculty: serializer.fromJson<String>(json['faculty']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subject': serializer.toJson<String>(subject),
      'topic': serializer.toJson<String>(topic),
      'time': serializer.toJson<String>(time),
      'faculty': serializer.toJson<String>(faculty),
      'status': serializer.toJson<String>(status),
    };
  }

  LiveClassesTableData copyWith(
          {String? id,
          String? subject,
          String? topic,
          String? time,
          String? faculty,
          String? status}) =>
      LiveClassesTableData(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        topic: topic ?? this.topic,
        time: time ?? this.time,
        faculty: faculty ?? this.faculty,
        status: status ?? this.status,
      );
  LiveClassesTableData copyWithCompanion(LiveClassesTableCompanion data) {
    return LiveClassesTableData(
      id: data.id.present ? data.id.value : this.id,
      subject: data.subject.present ? data.subject.value : this.subject,
      topic: data.topic.present ? data.topic.value : this.topic,
      time: data.time.present ? data.time.value : this.time,
      faculty: data.faculty.present ? data.faculty.value : this.faculty,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiveClassesTableData(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('topic: $topic, ')
          ..write('time: $time, ')
          ..write('faculty: $faculty, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subject, topic, time, faculty, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiveClassesTableData &&
          other.id == this.id &&
          other.subject == this.subject &&
          other.topic == this.topic &&
          other.time == this.time &&
          other.faculty == this.faculty &&
          other.status == this.status);
}

class LiveClassesTableCompanion extends UpdateCompanion<LiveClassesTableData> {
  final Value<String> id;
  final Value<String> subject;
  final Value<String> topic;
  final Value<String> time;
  final Value<String> faculty;
  final Value<String> status;
  final Value<int> rowid;
  const LiveClassesTableCompanion({
    this.id = const Value.absent(),
    this.subject = const Value.absent(),
    this.topic = const Value.absent(),
    this.time = const Value.absent(),
    this.faculty = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiveClassesTableCompanion.insert({
    required String id,
    required String subject,
    required String topic,
    required String time,
    required String faculty,
    required String status,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subject = Value(subject),
        topic = Value(topic),
        time = Value(time),
        faculty = Value(faculty),
        status = Value(status);
  static Insertable<LiveClassesTableData> custom({
    Expression<String>? id,
    Expression<String>? subject,
    Expression<String>? topic,
    Expression<String>? time,
    Expression<String>? faculty,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subject != null) 'subject': subject,
      if (topic != null) 'topic': topic,
      if (time != null) 'time': time,
      if (faculty != null) 'faculty': faculty,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiveClassesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? subject,
      Value<String>? topic,
      Value<String>? time,
      Value<String>? faculty,
      Value<String>? status,
      Value<int>? rowid}) {
    return LiveClassesTableCompanion(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      time: time ?? this.time,
      faculty: faculty ?? this.faculty,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (faculty.present) {
      map['faculty'] = Variable<String>(faculty.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiveClassesTableCompanion(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('topic: $topic, ')
          ..write('time: $time, ')
          ..write('faculty: $faculty, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ForumThreadsTableTable extends ForumThreadsTable
    with TableInfo<$ForumThreadsTableTable, ForumThreadsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ForumThreadsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
      'course_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentNameMeta =
      const VerificationMeta('studentName');
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
      'student_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeAgoMeta =
      const VerificationMeta('timeAgo');
  @override
  late final GeneratedColumn<String> timeAgo = GeneratedColumn<String>(
      'time_ago', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _replyCountMeta =
      const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
      'reply_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        courseId,
        title,
        description,
        studentName,
        timeAgo,
        replyCount,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forum_threads_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ForumThreadsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('student_name')) {
      context.handle(
          _studentNameMeta,
          studentName.isAcceptableOrUnknown(
              data['student_name']!, _studentNameMeta));
    } else if (isInserting) {
      context.missing(_studentNameMeta);
    }
    if (data.containsKey('time_ago')) {
      context.handle(_timeAgoMeta,
          timeAgo.isAcceptableOrUnknown(data['time_ago']!, _timeAgoMeta));
    } else if (isInserting) {
      context.missing(_timeAgoMeta);
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count']!, _replyCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForumThreadsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForumThreadsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}course_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      studentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_name'])!,
      timeAgo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_ago'])!,
      replyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ForumThreadsTableTable createAlias(String alias) {
    return $ForumThreadsTableTable(attachedDatabase, alias);
  }
}

class ForumThreadsTableData extends DataClass
    implements Insertable<ForumThreadsTableData> {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String studentName;
  final String timeAgo;
  final int replyCount;

  /// Stored as string: 'answered' | 'unanswered'
  final String status;
  const ForumThreadsTableData(
      {required this.id,
      required this.courseId,
      required this.title,
      required this.description,
      required this.studentName,
      required this.timeAgo,
      required this.replyCount,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['student_name'] = Variable<String>(studentName);
    map['time_ago'] = Variable<String>(timeAgo);
    map['reply_count'] = Variable<int>(replyCount);
    map['status'] = Variable<String>(status);
    return map;
  }

  ForumThreadsTableCompanion toCompanion(bool nullToAbsent) {
    return ForumThreadsTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      description: Value(description),
      studentName: Value(studentName),
      timeAgo: Value(timeAgo),
      replyCount: Value(replyCount),
      status: Value(status),
    );
  }

  factory ForumThreadsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForumThreadsTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      studentName: serializer.fromJson<String>(json['studentName']),
      timeAgo: serializer.fromJson<String>(json['timeAgo']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'studentName': serializer.toJson<String>(studentName),
      'timeAgo': serializer.toJson<String>(timeAgo),
      'replyCount': serializer.toJson<int>(replyCount),
      'status': serializer.toJson<String>(status),
    };
  }

  ForumThreadsTableData copyWith(
          {String? id,
          String? courseId,
          String? title,
          String? description,
          String? studentName,
          String? timeAgo,
          int? replyCount,
          String? status}) =>
      ForumThreadsTableData(
        id: id ?? this.id,
        courseId: courseId ?? this.courseId,
        title: title ?? this.title,
        description: description ?? this.description,
        studentName: studentName ?? this.studentName,
        timeAgo: timeAgo ?? this.timeAgo,
        replyCount: replyCount ?? this.replyCount,
        status: status ?? this.status,
      );
  ForumThreadsTableData copyWithCompanion(ForumThreadsTableCompanion data) {
    return ForumThreadsTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      studentName:
          data.studentName.present ? data.studentName.value : this.studentName,
      timeAgo: data.timeAgo.present ? data.timeAgo.value : this.timeAgo,
      replyCount:
          data.replyCount.present ? data.replyCount.value : this.replyCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForumThreadsTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('studentName: $studentName, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('replyCount: $replyCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, title, description, studentName,
      timeAgo, replyCount, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForumThreadsTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.description == this.description &&
          other.studentName == this.studentName &&
          other.timeAgo == this.timeAgo &&
          other.replyCount == this.replyCount &&
          other.status == this.status);
}

class ForumThreadsTableCompanion
    extends UpdateCompanion<ForumThreadsTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> studentName;
  final Value<String> timeAgo;
  final Value<int> replyCount;
  final Value<String> status;
  final Value<int> rowid;
  const ForumThreadsTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.studentName = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForumThreadsTableCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required String description,
    required String studentName,
    required String timeAgo,
    this.replyCount = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        courseId = Value(courseId),
        title = Value(title),
        description = Value(description),
        studentName = Value(studentName),
        timeAgo = Value(timeAgo),
        status = Value(status);
  static Insertable<ForumThreadsTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? studentName,
    Expression<String>? timeAgo,
    Expression<int>? replyCount,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (studentName != null) 'student_name': studentName,
      if (timeAgo != null) 'time_ago': timeAgo,
      if (replyCount != null) 'reply_count': replyCount,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForumThreadsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? courseId,
      Value<String>? title,
      Value<String>? description,
      Value<String>? studentName,
      Value<String>? timeAgo,
      Value<int>? replyCount,
      Value<String>? status,
      Value<int>? rowid}) {
    return ForumThreadsTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      studentName: studentName ?? this.studentName,
      timeAgo: timeAgo ?? this.timeAgo,
      replyCount: replyCount ?? this.replyCount,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (timeAgo.present) {
      map['time_ago'] = Variable<String>(timeAgo.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForumThreadsTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('studentName: $studentName, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('replyCount: $replyCount, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTableTable extends UserProgressTable
    with TableInfo<$UserProgressTableTable, UserProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
      'course_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _percentCompleteMeta =
      const VerificationMeta('percentComplete');
  @override
  late final GeneratedColumn<int> percentComplete = GeneratedColumn<int>(
      'percent_complete', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastAccessedAtMeta =
      const VerificationMeta('lastAccessedAt');
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>('last_accessed_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, lessonId, courseId, percentComplete, lastAccessedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('percent_complete')) {
      context.handle(
          _percentCompleteMeta,
          percentComplete.isAcceptableOrUnknown(
              data['percent_complete']!, _percentCompleteMeta));
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
          _lastAccessedAtMeta,
          lastAccessedAt.isAcceptableOrUnknown(
              data['last_accessed_at']!, _lastAccessedAtMeta));
    } else if (isInserting) {
      context.missing(_lastAccessedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, lessonId};
  @override
  UserProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressTableData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}course_id'])!,
      percentComplete: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}percent_complete'])!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed_at'])!,
    );
  }

  @override
  $UserProgressTableTable createAlias(String alias) {
    return $UserProgressTableTable(attachedDatabase, alias);
  }
}

class UserProgressTableData extends DataClass
    implements Insertable<UserProgressTableData> {
  final String userId;
  final String lessonId;
  final String courseId;
  final int percentComplete;
  final DateTime lastAccessedAt;
  const UserProgressTableData(
      {required this.userId,
      required this.lessonId,
      required this.courseId,
      required this.percentComplete,
      required this.lastAccessedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['course_id'] = Variable<String>(courseId);
    map['percent_complete'] = Variable<int>(percentComplete);
    map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    return map;
  }

  UserProgressTableCompanion toCompanion(bool nullToAbsent) {
    return UserProgressTableCompanion(
      userId: Value(userId),
      lessonId: Value(lessonId),
      courseId: Value(courseId),
      percentComplete: Value(percentComplete),
      lastAccessedAt: Value(lastAccessedAt),
    );
  }

  factory UserProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressTableData(
      userId: serializer.fromJson<String>(json['userId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      courseId: serializer.fromJson<String>(json['courseId']),
      percentComplete: serializer.fromJson<int>(json['percentComplete']),
      lastAccessedAt: serializer.fromJson<DateTime>(json['lastAccessedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'lessonId': serializer.toJson<String>(lessonId),
      'courseId': serializer.toJson<String>(courseId),
      'percentComplete': serializer.toJson<int>(percentComplete),
      'lastAccessedAt': serializer.toJson<DateTime>(lastAccessedAt),
    };
  }

  UserProgressTableData copyWith(
          {String? userId,
          String? lessonId,
          String? courseId,
          int? percentComplete,
          DateTime? lastAccessedAt}) =>
      UserProgressTableData(
        userId: userId ?? this.userId,
        lessonId: lessonId ?? this.lessonId,
        courseId: courseId ?? this.courseId,
        percentComplete: percentComplete ?? this.percentComplete,
        lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      );
  UserProgressTableData copyWithCompanion(UserProgressTableCompanion data) {
    return UserProgressTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      percentComplete: data.percentComplete.present
          ? data.percentComplete.value
          : this.percentComplete,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableData(')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('courseId: $courseId, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastAccessedAt: $lastAccessedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, lessonId, courseId, percentComplete, lastAccessedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressTableData &&
          other.userId == this.userId &&
          other.lessonId == this.lessonId &&
          other.courseId == this.courseId &&
          other.percentComplete == this.percentComplete &&
          other.lastAccessedAt == this.lastAccessedAt);
}

class UserProgressTableCompanion
    extends UpdateCompanion<UserProgressTableData> {
  final Value<String> userId;
  final Value<String> lessonId;
  final Value<String> courseId;
  final Value<int> percentComplete;
  final Value<DateTime> lastAccessedAt;
  final Value<int> rowid;
  const UserProgressTableCompanion({
    this.userId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.courseId = const Value.absent(),
    this.percentComplete = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProgressTableCompanion.insert({
    required String userId,
    required String lessonId,
    required String courseId,
    this.percentComplete = const Value.absent(),
    required DateTime lastAccessedAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        lessonId = Value(lessonId),
        courseId = Value(courseId),
        lastAccessedAt = Value(lastAccessedAt);
  static Insertable<UserProgressTableData> custom({
    Expression<String>? userId,
    Expression<String>? lessonId,
    Expression<String>? courseId,
    Expression<int>? percentComplete,
    Expression<DateTime>? lastAccessedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (courseId != null) 'course_id': courseId,
      if (percentComplete != null) 'percent_complete': percentComplete,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProgressTableCompanion copyWith(
      {Value<String>? userId,
      Value<String>? lessonId,
      Value<String>? courseId,
      Value<int>? percentComplete,
      Value<DateTime>? lastAccessedAt,
      Value<int>? rowid}) {
    return UserProgressTableCompanion(
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
      percentComplete: percentComplete ?? this.percentComplete,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (percentComplete.present) {
      map['percent_complete'] = Variable<int>(percentComplete.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableCompanion(')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('courseId: $courseId, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTableTable coursesTable = $CoursesTableTable(this);
  late final $ChaptersTableTable chaptersTable = $ChaptersTableTable(this);
  late final $LessonsTableTable lessonsTable = $LessonsTableTable(this);
  late final $LiveClassesTableTable liveClassesTable =
      $LiveClassesTableTable(this);
  late final $ForumThreadsTableTable forumThreadsTable =
      $ForumThreadsTableTable(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        coursesTable,
        chaptersTable,
        lessonsTable,
        liveClassesTable,
        forumThreadsTable,
        userProgressTable
      ];
}

typedef $$CoursesTableTableCreateCompanionBuilder = CoursesTableCompanion
    Function({
  required String id,
  required String title,
  required int colorIndex,
  required int chapterCount,
  required String totalDuration,
  Value<int> progress,
  Value<int> completedLessons,
  required int totalLessons,
  Value<int> rowid,
});
typedef $$CoursesTableTableUpdateCompanionBuilder = CoursesTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<int> colorIndex,
  Value<int> chapterCount,
  Value<String> totalDuration,
  Value<int> progress,
  Value<int> completedLessons,
  Value<int> totalLessons,
  Value<int> rowid,
});

class $$CoursesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterCount => $composableBuilder(
      column: $table.chapterCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalDuration => $composableBuilder(
      column: $table.totalDuration, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons, builder: (column) => ColumnFilters(column));
}

class $$CoursesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterCount => $composableBuilder(
      column: $table.chapterCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalDuration => $composableBuilder(
      column: $table.totalDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons,
      builder: (column) => ColumnOrderings(column));
}

class $$CoursesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => column);

  GeneratedColumn<int> get chapterCount => $composableBuilder(
      column: $table.chapterCount, builder: (column) => column);

  GeneratedColumn<String> get totalDuration => $composableBuilder(
      column: $table.totalDuration, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons, builder: (column) => column);

  GeneratedColumn<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons, builder: (column) => column);
}

class $$CoursesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CoursesTableTable,
    CoursesTableData,
    $$CoursesTableTableFilterComposer,
    $$CoursesTableTableOrderingComposer,
    $$CoursesTableTableAnnotationComposer,
    $$CoursesTableTableCreateCompanionBuilder,
    $$CoursesTableTableUpdateCompanionBuilder,
    (
      CoursesTableData,
      BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>
    ),
    CoursesTableData,
    PrefetchHooks Function()> {
  $$CoursesTableTableTableManager(_$AppDatabase db, $CoursesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> colorIndex = const Value.absent(),
            Value<int> chapterCount = const Value.absent(),
            Value<String> totalDuration = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<int> completedLessons = const Value.absent(),
            Value<int> totalLessons = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CoursesTableCompanion(
            id: id,
            title: title,
            colorIndex: colorIndex,
            chapterCount: chapterCount,
            totalDuration: totalDuration,
            progress: progress,
            completedLessons: completedLessons,
            totalLessons: totalLessons,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required int colorIndex,
            required int chapterCount,
            required String totalDuration,
            Value<int> progress = const Value.absent(),
            Value<int> completedLessons = const Value.absent(),
            required int totalLessons,
            Value<int> rowid = const Value.absent(),
          }) =>
              CoursesTableCompanion.insert(
            id: id,
            title: title,
            colorIndex: colorIndex,
            chapterCount: chapterCount,
            totalDuration: totalDuration,
            progress: progress,
            completedLessons: completedLessons,
            totalLessons: totalLessons,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CoursesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CoursesTableTable,
    CoursesTableData,
    $$CoursesTableTableFilterComposer,
    $$CoursesTableTableOrderingComposer,
    $$CoursesTableTableAnnotationComposer,
    $$CoursesTableTableCreateCompanionBuilder,
    $$CoursesTableTableUpdateCompanionBuilder,
    (
      CoursesTableData,
      BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>
    ),
    CoursesTableData,
    PrefetchHooks Function()>;
typedef $$ChaptersTableTableCreateCompanionBuilder = ChaptersTableCompanion
    Function({
  required String id,
  required String courseId,
  required String title,
  required int lessonCount,
  required int assessmentCount,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$ChaptersTableTableUpdateCompanionBuilder = ChaptersTableCompanion
    Function({
  Value<String> id,
  Value<String> courseId,
  Value<String> title,
  Value<int> lessonCount,
  Value<int> assessmentCount,
  Value<int> orderIndex,
  Value<int> rowid,
});

class $$ChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assessmentCount => $composableBuilder(
      column: $table.assessmentCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));
}

class $$ChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assessmentCount => $composableBuilder(
      column: $table.assessmentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));
}

class $$ChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get lessonCount => $composableBuilder(
      column: $table.lessonCount, builder: (column) => column);

  GeneratedColumn<int> get assessmentCount => $composableBuilder(
      column: $table.assessmentCount, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);
}

class $$ChaptersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (
      ChaptersTableData,
      BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData>
    ),
    ChaptersTableData,
    PrefetchHooks Function()> {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> courseId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> lessonCount = const Value.absent(),
            Value<int> assessmentCount = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion(
            id: id,
            courseId: courseId,
            title: title,
            lessonCount: lessonCount,
            assessmentCount: assessmentCount,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String courseId,
            required String title,
            required int lessonCount,
            required int assessmentCount,
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion.insert(
            id: id,
            courseId: courseId,
            title: title,
            lessonCount: lessonCount,
            assessmentCount: assessmentCount,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChaptersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (
      ChaptersTableData,
      BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData>
    ),
    ChaptersTableData,
    PrefetchHooks Function()>;
typedef $$LessonsTableTableCreateCompanionBuilder = LessonsTableCompanion
    Function({
  required String id,
  required String chapterId,
  required String title,
  required String type,
  required String duration,
  Value<String> progressStatus,
  Value<bool> isLocked,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$LessonsTableTableUpdateCompanionBuilder = LessonsTableCompanion
    Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> title,
  Value<String> type,
  Value<String> duration,
  Value<String> progressStatus,
  Value<bool> isLocked,
  Value<int> orderIndex,
  Value<int> rowid,
});

class $$LessonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get progressStatus => $composableBuilder(
      column: $table.progressStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));
}

class $$LessonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get progressStatus => $composableBuilder(
      column: $table.progressStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get progressStatus => $composableBuilder(
      column: $table.progressStatus, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);
}

class $$LessonsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTableTable,
    LessonsTableData,
    $$LessonsTableTableFilterComposer,
    $$LessonsTableTableOrderingComposer,
    $$LessonsTableTableAnnotationComposer,
    $$LessonsTableTableCreateCompanionBuilder,
    $$LessonsTableTableUpdateCompanionBuilder,
    (
      LessonsTableData,
      BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>
    ),
    LessonsTableData,
    PrefetchHooks Function()> {
  $$LessonsTableTableTableManager(_$AppDatabase db, $LessonsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> duration = const Value.absent(),
            Value<String> progressStatus = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsTableCompanion(
            id: id,
            chapterId: chapterId,
            title: title,
            type: type,
            duration: duration,
            progressStatus: progressStatus,
            isLocked: isLocked,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chapterId,
            required String title,
            required String type,
            required String duration,
            Value<String> progressStatus = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsTableCompanion.insert(
            id: id,
            chapterId: chapterId,
            title: title,
            type: type,
            duration: duration,
            progressStatus: progressStatus,
            isLocked: isLocked,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTableTable,
    LessonsTableData,
    $$LessonsTableTableFilterComposer,
    $$LessonsTableTableOrderingComposer,
    $$LessonsTableTableAnnotationComposer,
    $$LessonsTableTableCreateCompanionBuilder,
    $$LessonsTableTableUpdateCompanionBuilder,
    (
      LessonsTableData,
      BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>
    ),
    LessonsTableData,
    PrefetchHooks Function()>;
typedef $$LiveClassesTableTableCreateCompanionBuilder
    = LiveClassesTableCompanion Function({
  required String id,
  required String subject,
  required String topic,
  required String time,
  required String faculty,
  required String status,
  Value<int> rowid,
});
typedef $$LiveClassesTableTableUpdateCompanionBuilder
    = LiveClassesTableCompanion Function({
  Value<String> id,
  Value<String> subject,
  Value<String> topic,
  Value<String> time,
  Value<String> faculty,
  Value<String> status,
  Value<int> rowid,
});

class $$LiveClassesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LiveClassesTableTable> {
  $$LiveClassesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get faculty => $composableBuilder(
      column: $table.faculty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$LiveClassesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LiveClassesTableTable> {
  $$LiveClassesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get faculty => $composableBuilder(
      column: $table.faculty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$LiveClassesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiveClassesTableTable> {
  $$LiveClassesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get faculty =>
      $composableBuilder(column: $table.faculty, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$LiveClassesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LiveClassesTableTable,
    LiveClassesTableData,
    $$LiveClassesTableTableFilterComposer,
    $$LiveClassesTableTableOrderingComposer,
    $$LiveClassesTableTableAnnotationComposer,
    $$LiveClassesTableTableCreateCompanionBuilder,
    $$LiveClassesTableTableUpdateCompanionBuilder,
    (
      LiveClassesTableData,
      BaseReferences<_$AppDatabase, $LiveClassesTableTable,
          LiveClassesTableData>
    ),
    LiveClassesTableData,
    PrefetchHooks Function()> {
  $$LiveClassesTableTableTableManager(
      _$AppDatabase db, $LiveClassesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiveClassesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiveClassesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiveClassesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> subject = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String> faculty = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LiveClassesTableCompanion(
            id: id,
            subject: subject,
            topic: topic,
            time: time,
            faculty: faculty,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String subject,
            required String topic,
            required String time,
            required String faculty,
            required String status,
            Value<int> rowid = const Value.absent(),
          }) =>
              LiveClassesTableCompanion.insert(
            id: id,
            subject: subject,
            topic: topic,
            time: time,
            faculty: faculty,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LiveClassesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LiveClassesTableTable,
    LiveClassesTableData,
    $$LiveClassesTableTableFilterComposer,
    $$LiveClassesTableTableOrderingComposer,
    $$LiveClassesTableTableAnnotationComposer,
    $$LiveClassesTableTableCreateCompanionBuilder,
    $$LiveClassesTableTableUpdateCompanionBuilder,
    (
      LiveClassesTableData,
      BaseReferences<_$AppDatabase, $LiveClassesTableTable,
          LiveClassesTableData>
    ),
    LiveClassesTableData,
    PrefetchHooks Function()>;
typedef $$ForumThreadsTableTableCreateCompanionBuilder
    = ForumThreadsTableCompanion Function({
  required String id,
  required String courseId,
  required String title,
  required String description,
  required String studentName,
  required String timeAgo,
  Value<int> replyCount,
  required String status,
  Value<int> rowid,
});
typedef $$ForumThreadsTableTableUpdateCompanionBuilder
    = ForumThreadsTableCompanion Function({
  Value<String> id,
  Value<String> courseId,
  Value<String> title,
  Value<String> description,
  Value<String> studentName,
  Value<String> timeAgo,
  Value<int> replyCount,
  Value<String> status,
  Value<int> rowid,
});

class $$ForumThreadsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ForumThreadsTableTable> {
  $$ForumThreadsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentName => $composableBuilder(
      column: $table.studentName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeAgo => $composableBuilder(
      column: $table.timeAgo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$ForumThreadsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ForumThreadsTableTable> {
  $$ForumThreadsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentName => $composableBuilder(
      column: $table.studentName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeAgo => $composableBuilder(
      column: $table.timeAgo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$ForumThreadsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ForumThreadsTableTable> {
  $$ForumThreadsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get studentName => $composableBuilder(
      column: $table.studentName, builder: (column) => column);

  GeneratedColumn<String> get timeAgo =>
      $composableBuilder(column: $table.timeAgo, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ForumThreadsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ForumThreadsTableTable,
    ForumThreadsTableData,
    $$ForumThreadsTableTableFilterComposer,
    $$ForumThreadsTableTableOrderingComposer,
    $$ForumThreadsTableTableAnnotationComposer,
    $$ForumThreadsTableTableCreateCompanionBuilder,
    $$ForumThreadsTableTableUpdateCompanionBuilder,
    (
      ForumThreadsTableData,
      BaseReferences<_$AppDatabase, $ForumThreadsTableTable,
          ForumThreadsTableData>
    ),
    ForumThreadsTableData,
    PrefetchHooks Function()> {
  $$ForumThreadsTableTableTableManager(
      _$AppDatabase db, $ForumThreadsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForumThreadsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ForumThreadsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ForumThreadsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> courseId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> studentName = const Value.absent(),
            Value<String> timeAgo = const Value.absent(),
            Value<int> replyCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ForumThreadsTableCompanion(
            id: id,
            courseId: courseId,
            title: title,
            description: description,
            studentName: studentName,
            timeAgo: timeAgo,
            replyCount: replyCount,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String courseId,
            required String title,
            required String description,
            required String studentName,
            required String timeAgo,
            Value<int> replyCount = const Value.absent(),
            required String status,
            Value<int> rowid = const Value.absent(),
          }) =>
              ForumThreadsTableCompanion.insert(
            id: id,
            courseId: courseId,
            title: title,
            description: description,
            studentName: studentName,
            timeAgo: timeAgo,
            replyCount: replyCount,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ForumThreadsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ForumThreadsTableTable,
    ForumThreadsTableData,
    $$ForumThreadsTableTableFilterComposer,
    $$ForumThreadsTableTableOrderingComposer,
    $$ForumThreadsTableTableAnnotationComposer,
    $$ForumThreadsTableTableCreateCompanionBuilder,
    $$ForumThreadsTableTableUpdateCompanionBuilder,
    (
      ForumThreadsTableData,
      BaseReferences<_$AppDatabase, $ForumThreadsTableTable,
          ForumThreadsTableData>
    ),
    ForumThreadsTableData,
    PrefetchHooks Function()>;
typedef $$UserProgressTableTableCreateCompanionBuilder
    = UserProgressTableCompanion Function({
  required String userId,
  required String lessonId,
  required String courseId,
  Value<int> percentComplete,
  required DateTime lastAccessedAt,
  Value<int> rowid,
});
typedef $$UserProgressTableTableUpdateCompanionBuilder
    = UserProgressTableCompanion Function({
  Value<String> userId,
  Value<String> lessonId,
  Value<String> courseId,
  Value<int> percentComplete,
  Value<DateTime> lastAccessedAt,
  Value<int> rowid,
});

class $$UserProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get percentComplete => $composableBuilder(
      column: $table.percentComplete,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get percentComplete => $composableBuilder(
      column: $table.percentComplete,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<int> get percentComplete => $composableBuilder(
      column: $table.percentComplete, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt, builder: (column) => column);
}

class $$UserProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressTableData,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressTableData,
      BaseReferences<_$AppDatabase, $UserProgressTableTable,
          UserProgressTableData>
    ),
    UserProgressTableData,
    PrefetchHooks Function()> {
  $$UserProgressTableTableTableManager(
      _$AppDatabase db, $UserProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> courseId = const Value.absent(),
            Value<int> percentComplete = const Value.absent(),
            Value<DateTime> lastAccessedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressTableCompanion(
            userId: userId,
            lessonId: lessonId,
            courseId: courseId,
            percentComplete: percentComplete,
            lastAccessedAt: lastAccessedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String lessonId,
            required String courseId,
            Value<int> percentComplete = const Value.absent(),
            required DateTime lastAccessedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressTableCompanion.insert(
            userId: userId,
            lessonId: lessonId,
            courseId: courseId,
            percentComplete: percentComplete,
            lastAccessedAt: lastAccessedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressTableData,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressTableData,
      BaseReferences<_$AppDatabase, $UserProgressTableTable,
          UserProgressTableData>
    ),
    UserProgressTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableTableManager get coursesTable =>
      $$CoursesTableTableTableManager(_db, _db.coursesTable);
  $$ChaptersTableTableTableManager get chaptersTable =>
      $$ChaptersTableTableTableManager(_db, _db.chaptersTable);
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db, _db.lessonsTable);
  $$LiveClassesTableTableTableManager get liveClassesTable =>
      $$LiveClassesTableTableTableManager(_db, _db.liveClassesTable);
  $$ForumThreadsTableTableTableManager get forumThreadsTable =>
      $$ForumThreadsTableTableTableManager(_db, _db.forumThreadsTable);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
}
