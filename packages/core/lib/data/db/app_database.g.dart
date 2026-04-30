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
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorIndexMeta = const VerificationMeta(
    'colorIndex',
  );
  @override
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
    'color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterCountMeta = const VerificationMeta(
    'chapterCount',
  );
  @override
  late final GeneratedColumn<int> chapterCount = GeneratedColumn<int>(
    'chapter_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDurationMeta = const VerificationMeta(
    'totalDuration',
  );
  @override
  late final GeneratedColumn<String> totalDuration = GeneratedColumn<String>(
    'total_duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalContentsMeta = const VerificationMeta(
    'totalContents',
  );
  @override
  late final GeneratedColumn<int> totalContents = GeneratedColumn<int>(
    'total_contents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedLessonsMeta = const VerificationMeta(
    'completedLessons',
  );
  @override
  late final GeneratedColumn<int> completedLessons = GeneratedColumn<int>(
    'completed_lessons',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLessonsMeta = const VerificationMeta(
    'totalLessons',
  );
  @override
  late final GeneratedColumn<int> totalLessons = GeneratedColumn<int>(
    'total_lessons',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isChaptersSyncedMeta = const VerificationMeta(
    'isChaptersSynced',
  );
  @override
  late final GeneratedColumn<bool> isChaptersSynced = GeneratedColumn<bool>(
    'is_chapters_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_chapters_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    colorIndex,
    chapterCount,
    totalDuration,
    totalContents,
    progress,
    completedLessons,
    totalLessons,
    image,
    isChaptersSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoursesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
        _colorIndexMeta,
        colorIndex.isAcceptableOrUnknown(data['color_index']!, _colorIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('chapter_count')) {
      context.handle(
        _chapterCountMeta,
        chapterCount.isAcceptableOrUnknown(
          data['chapter_count']!,
          _chapterCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterCountMeta);
    }
    if (data.containsKey('total_duration')) {
      context.handle(
        _totalDurationMeta,
        totalDuration.isAcceptableOrUnknown(
          data['total_duration']!,
          _totalDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDurationMeta);
    }
    if (data.containsKey('total_contents')) {
      context.handle(
        _totalContentsMeta,
        totalContents.isAcceptableOrUnknown(
          data['total_contents']!,
          _totalContentsMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('completed_lessons')) {
      context.handle(
        _completedLessonsMeta,
        completedLessons.isAcceptableOrUnknown(
          data['completed_lessons']!,
          _completedLessonsMeta,
        ),
      );
    }
    if (data.containsKey('total_lessons')) {
      context.handle(
        _totalLessonsMeta,
        totalLessons.isAcceptableOrUnknown(
          data['total_lessons']!,
          _totalLessonsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalLessonsMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('is_chapters_synced')) {
      context.handle(
        _isChaptersSyncedMeta,
        isChaptersSynced.isAcceptableOrUnknown(
          data['is_chapters_synced']!,
          _isChaptersSyncedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoursesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoursesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      colorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_index'],
      )!,
      chapterCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_count'],
      )!,
      totalDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_duration'],
      )!,
      totalContents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_contents'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      completedLessons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_lessons'],
      )!,
      totalLessons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_lessons'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      isChaptersSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_chapters_synced'],
      )!,
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
  final int totalContents;
  final int progress;
  final int completedLessons;
  final int totalLessons;
  final String? image;
  final bool isChaptersSynced;
  const CoursesTableData({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chapterCount,
    required this.totalDuration,
    required this.totalContents,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    this.image,
    required this.isChaptersSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['color_index'] = Variable<int>(colorIndex);
    map['chapter_count'] = Variable<int>(chapterCount);
    map['total_duration'] = Variable<String>(totalDuration);
    map['total_contents'] = Variable<int>(totalContents);
    map['progress'] = Variable<int>(progress);
    map['completed_lessons'] = Variable<int>(completedLessons);
    map['total_lessons'] = Variable<int>(totalLessons);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['is_chapters_synced'] = Variable<bool>(isChaptersSynced);
    return map;
  }

  CoursesTableCompanion toCompanion(bool nullToAbsent) {
    return CoursesTableCompanion(
      id: Value(id),
      title: Value(title),
      colorIndex: Value(colorIndex),
      chapterCount: Value(chapterCount),
      totalDuration: Value(totalDuration),
      totalContents: Value(totalContents),
      progress: Value(progress),
      completedLessons: Value(completedLessons),
      totalLessons: Value(totalLessons),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      isChaptersSynced: Value(isChaptersSynced),
    );
  }

  factory CoursesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoursesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      colorIndex: serializer.fromJson<int>(json['colorIndex']),
      chapterCount: serializer.fromJson<int>(json['chapterCount']),
      totalDuration: serializer.fromJson<String>(json['totalDuration']),
      totalContents: serializer.fromJson<int>(json['totalContents']),
      progress: serializer.fromJson<int>(json['progress']),
      completedLessons: serializer.fromJson<int>(json['completedLessons']),
      totalLessons: serializer.fromJson<int>(json['totalLessons']),
      image: serializer.fromJson<String?>(json['image']),
      isChaptersSynced: serializer.fromJson<bool>(json['isChaptersSynced']),
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
      'totalContents': serializer.toJson<int>(totalContents),
      'progress': serializer.toJson<int>(progress),
      'completedLessons': serializer.toJson<int>(completedLessons),
      'totalLessons': serializer.toJson<int>(totalLessons),
      'image': serializer.toJson<String?>(image),
      'isChaptersSynced': serializer.toJson<bool>(isChaptersSynced),
    };
  }

  CoursesTableData copyWith({
    String? id,
    String? title,
    int? colorIndex,
    int? chapterCount,
    String? totalDuration,
    int? totalContents,
    int? progress,
    int? completedLessons,
    int? totalLessons,
    Value<String?> image = const Value.absent(),
    bool? isChaptersSynced,
  }) => CoursesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    colorIndex: colorIndex ?? this.colorIndex,
    chapterCount: chapterCount ?? this.chapterCount,
    totalDuration: totalDuration ?? this.totalDuration,
    totalContents: totalContents ?? this.totalContents,
    progress: progress ?? this.progress,
    completedLessons: completedLessons ?? this.completedLessons,
    totalLessons: totalLessons ?? this.totalLessons,
    image: image.present ? image.value : this.image,
    isChaptersSynced: isChaptersSynced ?? this.isChaptersSynced,
  );
  CoursesTableData copyWithCompanion(CoursesTableCompanion data) {
    return CoursesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      colorIndex: data.colorIndex.present
          ? data.colorIndex.value
          : this.colorIndex,
      chapterCount: data.chapterCount.present
          ? data.chapterCount.value
          : this.chapterCount,
      totalDuration: data.totalDuration.present
          ? data.totalDuration.value
          : this.totalDuration,
      totalContents: data.totalContents.present
          ? data.totalContents.value
          : this.totalContents,
      progress: data.progress.present ? data.progress.value : this.progress,
      completedLessons: data.completedLessons.present
          ? data.completedLessons.value
          : this.completedLessons,
      totalLessons: data.totalLessons.present
          ? data.totalLessons.value
          : this.totalLessons,
      image: data.image.present ? data.image.value : this.image,
      isChaptersSynced: data.isChaptersSynced.present
          ? data.isChaptersSynced.value
          : this.isChaptersSynced,
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
          ..write('totalContents: $totalContents, ')
          ..write('progress: $progress, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('image: $image, ')
          ..write('isChaptersSynced: $isChaptersSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    colorIndex,
    chapterCount,
    totalDuration,
    totalContents,
    progress,
    completedLessons,
    totalLessons,
    image,
    isChaptersSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoursesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.colorIndex == this.colorIndex &&
          other.chapterCount == this.chapterCount &&
          other.totalDuration == this.totalDuration &&
          other.totalContents == this.totalContents &&
          other.progress == this.progress &&
          other.completedLessons == this.completedLessons &&
          other.totalLessons == this.totalLessons &&
          other.image == this.image &&
          other.isChaptersSynced == this.isChaptersSynced);
}

class CoursesTableCompanion extends UpdateCompanion<CoursesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> colorIndex;
  final Value<int> chapterCount;
  final Value<String> totalDuration;
  final Value<int> totalContents;
  final Value<int> progress;
  final Value<int> completedLessons;
  final Value<int> totalLessons;
  final Value<String?> image;
  final Value<bool> isChaptersSynced;
  final Value<int> rowid;
  const CoursesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.chapterCount = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.totalContents = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedLessons = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.image = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesTableCompanion.insert({
    required String id,
    required String title,
    required int colorIndex,
    required int chapterCount,
    required String totalDuration,
    this.totalContents = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedLessons = const Value.absent(),
    required int totalLessons,
    this.image = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
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
    Expression<int>? totalContents,
    Expression<int>? progress,
    Expression<int>? completedLessons,
    Expression<int>? totalLessons,
    Expression<String>? image,
    Expression<bool>? isChaptersSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (colorIndex != null) 'color_index': colorIndex,
      if (chapterCount != null) 'chapter_count': chapterCount,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (totalContents != null) 'total_contents': totalContents,
      if (progress != null) 'progress': progress,
      if (completedLessons != null) 'completed_lessons': completedLessons,
      if (totalLessons != null) 'total_lessons': totalLessons,
      if (image != null) 'image': image,
      if (isChaptersSynced != null) 'is_chapters_synced': isChaptersSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? colorIndex,
    Value<int>? chapterCount,
    Value<String>? totalDuration,
    Value<int>? totalContents,
    Value<int>? progress,
    Value<int>? completedLessons,
    Value<int>? totalLessons,
    Value<String?>? image,
    Value<bool>? isChaptersSynced,
    Value<int>? rowid,
  }) {
    return CoursesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      colorIndex: colorIndex ?? this.colorIndex,
      chapterCount: chapterCount ?? this.chapterCount,
      totalDuration: totalDuration ?? this.totalDuration,
      totalContents: totalContents ?? this.totalContents,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      image: image ?? this.image,
      isChaptersSynced: isChaptersSynced ?? this.isChaptersSynced,
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
    if (totalContents.present) {
      map['total_contents'] = Variable<int>(totalContents.value);
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
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (isChaptersSynced.present) {
      map['is_chapters_synced'] = Variable<bool>(isChaptersSynced.value);
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
          ..write('totalContents: $totalContents, ')
          ..write('progress: $progress, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('image: $image, ')
          ..write('isChaptersSynced: $isChaptersSynced, ')
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
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonCountMeta = const VerificationMeta(
    'lessonCount',
  );
  @override
  late final GeneratedColumn<int> lessonCount = GeneratedColumn<int>(
    'lesson_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assessmentCountMeta = const VerificationMeta(
    'assessmentCount',
  );
  @override
  late final GeneratedColumn<int> assessmentCount = GeneratedColumn<int>(
    'assessment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLeafMeta = const VerificationMeta('isLeaf');
  @override
  late final GeneratedColumn<bool> isLeaf = GeneratedColumn<bool>(
    'is_leaf',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_leaf" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isChaptersSyncedMeta = const VerificationMeta(
    'isChaptersSynced',
  );
  @override
  late final GeneratedColumn<bool> isChaptersSynced = GeneratedColumn<bool>(
    'is_chapters_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_chapters_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    lessonCount,
    assessmentCount,
    orderIndex,
    parentId,
    isLeaf,
    isChaptersSynced,
    image,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChaptersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('lesson_count')) {
      context.handle(
        _lessonCountMeta,
        lessonCount.isAcceptableOrUnknown(
          data['lesson_count']!,
          _lessonCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lessonCountMeta);
    }
    if (data.containsKey('assessment_count')) {
      context.handle(
        _assessmentCountMeta,
        assessmentCount.isAcceptableOrUnknown(
          data['assessment_count']!,
          _assessmentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assessmentCountMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_leaf')) {
      context.handle(
        _isLeafMeta,
        isLeaf.isAcceptableOrUnknown(data['is_leaf']!, _isLeafMeta),
      );
    }
    if (data.containsKey('is_chapters_synced')) {
      context.handle(
        _isChaptersSyncedMeta,
        isChaptersSynced.isAcceptableOrUnknown(
          data['is_chapters_synced']!,
          _isChaptersSyncedMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChaptersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      lessonCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_count'],
      )!,
      assessmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assessment_count'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      isLeaf: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_leaf'],
      )!,
      isChaptersSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_chapters_synced'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
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
  final String? parentId;
  final bool isLeaf;
  final bool isChaptersSynced;
  final String? image;
  const ChaptersTableData({
    required this.id,
    required this.courseId,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    required this.orderIndex,
    this.parentId,
    required this.isLeaf,
    required this.isChaptersSynced,
    this.image,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['lesson_count'] = Variable<int>(lessonCount);
    map['assessment_count'] = Variable<int>(assessmentCount);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_leaf'] = Variable<bool>(isLeaf);
    map['is_chapters_synced'] = Variable<bool>(isChaptersSynced);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
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
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isLeaf: Value(isLeaf),
      isChaptersSynced: Value(isChaptersSynced),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
    );
  }

  factory ChaptersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChaptersTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      lessonCount: serializer.fromJson<int>(json['lessonCount']),
      assessmentCount: serializer.fromJson<int>(json['assessmentCount']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isLeaf: serializer.fromJson<bool>(json['isLeaf']),
      isChaptersSynced: serializer.fromJson<bool>(json['isChaptersSynced']),
      image: serializer.fromJson<String?>(json['image']),
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
      'parentId': serializer.toJson<String?>(parentId),
      'isLeaf': serializer.toJson<bool>(isLeaf),
      'isChaptersSynced': serializer.toJson<bool>(isChaptersSynced),
      'image': serializer.toJson<String?>(image),
    };
  }

  ChaptersTableData copyWith({
    String? id,
    String? courseId,
    String? title,
    int? lessonCount,
    int? assessmentCount,
    int? orderIndex,
    Value<String?> parentId = const Value.absent(),
    bool? isLeaf,
    bool? isChaptersSynced,
    Value<String?> image = const Value.absent(),
  }) => ChaptersTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    lessonCount: lessonCount ?? this.lessonCount,
    assessmentCount: assessmentCount ?? this.assessmentCount,
    orderIndex: orderIndex ?? this.orderIndex,
    parentId: parentId.present ? parentId.value : this.parentId,
    isLeaf: isLeaf ?? this.isLeaf,
    isChaptersSynced: isChaptersSynced ?? this.isChaptersSynced,
    image: image.present ? image.value : this.image,
  );
  ChaptersTableData copyWithCompanion(ChaptersTableCompanion data) {
    return ChaptersTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      lessonCount: data.lessonCount.present
          ? data.lessonCount.value
          : this.lessonCount,
      assessmentCount: data.assessmentCount.present
          ? data.assessmentCount.value
          : this.assessmentCount,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isLeaf: data.isLeaf.present ? data.isLeaf.value : this.isLeaf,
      isChaptersSynced: data.isChaptersSynced.present
          ? data.isChaptersSynced.value
          : this.isChaptersSynced,
      image: data.image.present ? data.image.value : this.image,
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
          ..write('orderIndex: $orderIndex, ')
          ..write('parentId: $parentId, ')
          ..write('isLeaf: $isLeaf, ')
          ..write('isChaptersSynced: $isChaptersSynced, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    title,
    lessonCount,
    assessmentCount,
    orderIndex,
    parentId,
    isLeaf,
    isChaptersSynced,
    image,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChaptersTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.lessonCount == this.lessonCount &&
          other.assessmentCount == this.assessmentCount &&
          other.orderIndex == this.orderIndex &&
          other.parentId == this.parentId &&
          other.isLeaf == this.isLeaf &&
          other.isChaptersSynced == this.isChaptersSynced &&
          other.image == this.image);
}

class ChaptersTableCompanion extends UpdateCompanion<ChaptersTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<int> lessonCount;
  final Value<int> assessmentCount;
  final Value<int> orderIndex;
  final Value<String?> parentId;
  final Value<bool> isLeaf;
  final Value<bool> isChaptersSynced;
  final Value<String?> image;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.assessmentCount = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isLeaf = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.image = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required int lessonCount,
    required int assessmentCount,
    required int orderIndex,
    this.parentId = const Value.absent(),
    this.isLeaf = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.image = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
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
    Expression<String>? parentId,
    Expression<bool>? isLeaf,
    Expression<bool>? isChaptersSynced,
    Expression<String>? image,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (lessonCount != null) 'lesson_count': lessonCount,
      if (assessmentCount != null) 'assessment_count': assessmentCount,
      if (orderIndex != null) 'order_index': orderIndex,
      if (parentId != null) 'parent_id': parentId,
      if (isLeaf != null) 'is_leaf': isLeaf,
      if (isChaptersSynced != null) 'is_chapters_synced': isChaptersSynced,
      if (image != null) 'image': image,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? title,
    Value<int>? lessonCount,
    Value<int>? assessmentCount,
    Value<int>? orderIndex,
    Value<String?>? parentId,
    Value<bool>? isLeaf,
    Value<bool>? isChaptersSynced,
    Value<String?>? image,
    Value<int>? rowid,
  }) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      lessonCount: lessonCount ?? this.lessonCount,
      assessmentCount: assessmentCount ?? this.assessmentCount,
      orderIndex: orderIndex ?? this.orderIndex,
      parentId: parentId ?? this.parentId,
      isLeaf: isLeaf ?? this.isLeaf,
      isChaptersSynced: isChaptersSynced ?? this.isChaptersSynced,
      image: image ?? this.image,
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
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isLeaf.present) {
      map['is_leaf'] = Variable<bool>(isLeaf.value);
    }
    if (isChaptersSynced.present) {
      map['is_chapters_synced'] = Variable<bool>(isChaptersSynced.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
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
          ..write('parentId: $parentId, ')
          ..write('isLeaf: $isLeaf, ')
          ..write('isChaptersSynced: $isChaptersSynced, ')
          ..write('image: $image, ')
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
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressStatusMeta = const VerificationMeta(
    'progressStatus',
  );
  @override
  late final GeneratedColumn<String> progressStatus = GeneratedColumn<String>(
    'progress_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('notStarted'),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterTitleMeta = const VerificationMeta(
    'chapterTitle',
  );
  @override
  late final GeneratedColumn<String> chapterTitle = GeneratedColumn<String>(
    'chapter_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentUrlMeta = const VerificationMeta(
    'contentUrl',
  );
  @override
  late final GeneratedColumn<String> contentUrl = GeneratedColumn<String>(
    'content_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIndexMeta = const VerificationMeta(
    'subjectIndex',
  );
  @override
  late final GeneratedColumn<int> subjectIndex = GeneratedColumn<int>(
    'subject_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonNumberMeta = const VerificationMeta(
    'lessonNumber',
  );
  @override
  late final GeneratedColumn<int> lessonNumber = GeneratedColumn<int>(
    'lesson_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalLessonsMeta = const VerificationMeta(
    'totalLessons',
  );
  @override
  late final GeneratedColumn<int> totalLessons = GeneratedColumn<int>(
    'total_lessons',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBookmarkedMeta = const VerificationMeta(
    'isBookmarked',
  );
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
    'is_bookmarked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bookmarked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isRunningMeta = const VerificationMeta(
    'isRunning',
  );
  @override
  late final GeneratedColumn<bool> isRunning = GeneratedColumn<bool>(
    'is_running',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_running" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isUpcomingMeta = const VerificationMeta(
    'isUpcoming',
  );
  @override
  late final GeneratedColumn<bool> isUpcoming = GeneratedColumn<bool>(
    'is_upcoming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_upcoming" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAttemptsMeta = const VerificationMeta(
    'hasAttempts',
  );
  @override
  late final GeneratedColumn<bool> hasAttempts = GeneratedColumn<bool>(
    'has_attempts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_attempts" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    title,
    type,
    duration,
    progressStatus,
    isLocked,
    orderIndex,
    chapterTitle,
    contentUrl,
    subtitle,
    subjectName,
    subjectIndex,
    lessonNumber,
    totalLessons,
    isBookmarked,
    isRunning,
    isUpcoming,
    hasAttempts,
    image,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('progress_status')) {
      context.handle(
        _progressStatusMeta,
        progressStatus.isAcceptableOrUnknown(
          data['progress_status']!,
          _progressStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('chapter_title')) {
      context.handle(
        _chapterTitleMeta,
        chapterTitle.isAcceptableOrUnknown(
          data['chapter_title']!,
          _chapterTitleMeta,
        ),
      );
    }
    if (data.containsKey('content_url')) {
      context.handle(
        _contentUrlMeta,
        contentUrl.isAcceptableOrUnknown(data['content_url']!, _contentUrlMeta),
      );
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    }
    if (data.containsKey('subject_index')) {
      context.handle(
        _subjectIndexMeta,
        subjectIndex.isAcceptableOrUnknown(
          data['subject_index']!,
          _subjectIndexMeta,
        ),
      );
    }
    if (data.containsKey('lesson_number')) {
      context.handle(
        _lessonNumberMeta,
        lessonNumber.isAcceptableOrUnknown(
          data['lesson_number']!,
          _lessonNumberMeta,
        ),
      );
    }
    if (data.containsKey('total_lessons')) {
      context.handle(
        _totalLessonsMeta,
        totalLessons.isAcceptableOrUnknown(
          data['total_lessons']!,
          _totalLessonsMeta,
        ),
      );
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
        _isBookmarkedMeta,
        isBookmarked.isAcceptableOrUnknown(
          data['is_bookmarked']!,
          _isBookmarkedMeta,
        ),
      );
    }
    if (data.containsKey('is_running')) {
      context.handle(
        _isRunningMeta,
        isRunning.isAcceptableOrUnknown(data['is_running']!, _isRunningMeta),
      );
    }
    if (data.containsKey('is_upcoming')) {
      context.handle(
        _isUpcomingMeta,
        isUpcoming.isAcceptableOrUnknown(data['is_upcoming']!, _isUpcomingMeta),
      );
    }
    if (data.containsKey('has_attempts')) {
      context.handle(
        _hasAttemptsMeta,
        hasAttempts.isAcceptableOrUnknown(
          data['has_attempts']!,
          _hasAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      progressStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_status'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      chapterTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_title'],
      ),
      contentUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_url'],
      ),
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      ),
      subjectIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_index'],
      ),
      lessonNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_number'],
      ),
      totalLessons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_lessons'],
      ),
      isBookmarked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bookmarked'],
      )!,
      isRunning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_running'],
      )!,
      isUpcoming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_upcoming'],
      )!,
      hasAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_attempts'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
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
  final String? chapterTitle;
  final String? contentUrl;
  final String? subtitle;
  final String? subjectName;
  final int? subjectIndex;
  final int? lessonNumber;
  final int? totalLessons;
  final bool isBookmarked;
  final bool isRunning;
  final bool isUpcoming;
  final bool hasAttempts;
  final String? image;
  const LessonsTableData({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.type,
    required this.duration,
    required this.progressStatus,
    required this.isLocked,
    required this.orderIndex,
    this.chapterTitle,
    this.contentUrl,
    this.subtitle,
    this.subjectName,
    this.subjectIndex,
    this.lessonNumber,
    this.totalLessons,
    required this.isBookmarked,
    required this.isRunning,
    required this.isUpcoming,
    required this.hasAttempts,
    this.image,
  });
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
    if (!nullToAbsent || chapterTitle != null) {
      map['chapter_title'] = Variable<String>(chapterTitle);
    }
    if (!nullToAbsent || contentUrl != null) {
      map['content_url'] = Variable<String>(contentUrl);
    }
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || subjectName != null) {
      map['subject_name'] = Variable<String>(subjectName);
    }
    if (!nullToAbsent || subjectIndex != null) {
      map['subject_index'] = Variable<int>(subjectIndex);
    }
    if (!nullToAbsent || lessonNumber != null) {
      map['lesson_number'] = Variable<int>(lessonNumber);
    }
    if (!nullToAbsent || totalLessons != null) {
      map['total_lessons'] = Variable<int>(totalLessons);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    map['is_running'] = Variable<bool>(isRunning);
    map['is_upcoming'] = Variable<bool>(isUpcoming);
    map['has_attempts'] = Variable<bool>(hasAttempts);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
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
      chapterTitle: chapterTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterTitle),
      contentUrl: contentUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(contentUrl),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      subjectName: subjectName == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectName),
      subjectIndex: subjectIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectIndex),
      lessonNumber: lessonNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonNumber),
      totalLessons: totalLessons == null && nullToAbsent
          ? const Value.absent()
          : Value(totalLessons),
      isBookmarked: Value(isBookmarked),
      isRunning: Value(isRunning),
      isUpcoming: Value(isUpcoming),
      hasAttempts: Value(hasAttempts),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
    );
  }

  factory LessonsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      chapterTitle: serializer.fromJson<String?>(json['chapterTitle']),
      contentUrl: serializer.fromJson<String?>(json['contentUrl']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      subjectName: serializer.fromJson<String?>(json['subjectName']),
      subjectIndex: serializer.fromJson<int?>(json['subjectIndex']),
      lessonNumber: serializer.fromJson<int?>(json['lessonNumber']),
      totalLessons: serializer.fromJson<int?>(json['totalLessons']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
      isRunning: serializer.fromJson<bool>(json['isRunning']),
      isUpcoming: serializer.fromJson<bool>(json['isUpcoming']),
      hasAttempts: serializer.fromJson<bool>(json['hasAttempts']),
      image: serializer.fromJson<String?>(json['image']),
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
      'chapterTitle': serializer.toJson<String?>(chapterTitle),
      'contentUrl': serializer.toJson<String?>(contentUrl),
      'subtitle': serializer.toJson<String?>(subtitle),
      'subjectName': serializer.toJson<String?>(subjectName),
      'subjectIndex': serializer.toJson<int?>(subjectIndex),
      'lessonNumber': serializer.toJson<int?>(lessonNumber),
      'totalLessons': serializer.toJson<int?>(totalLessons),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
      'isRunning': serializer.toJson<bool>(isRunning),
      'isUpcoming': serializer.toJson<bool>(isUpcoming),
      'hasAttempts': serializer.toJson<bool>(hasAttempts),
      'image': serializer.toJson<String?>(image),
    };
  }

  LessonsTableData copyWith({
    String? id,
    String? chapterId,
    String? title,
    String? type,
    String? duration,
    String? progressStatus,
    bool? isLocked,
    int? orderIndex,
    Value<String?> chapterTitle = const Value.absent(),
    Value<String?> contentUrl = const Value.absent(),
    Value<String?> subtitle = const Value.absent(),
    Value<String?> subjectName = const Value.absent(),
    Value<int?> subjectIndex = const Value.absent(),
    Value<int?> lessonNumber = const Value.absent(),
    Value<int?> totalLessons = const Value.absent(),
    bool? isBookmarked,
    bool? isRunning,
    bool? isUpcoming,
    bool? hasAttempts,
    Value<String?> image = const Value.absent(),
  }) => LessonsTableData(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    title: title ?? this.title,
    type: type ?? this.type,
    duration: duration ?? this.duration,
    progressStatus: progressStatus ?? this.progressStatus,
    isLocked: isLocked ?? this.isLocked,
    orderIndex: orderIndex ?? this.orderIndex,
    chapterTitle: chapterTitle.present ? chapterTitle.value : this.chapterTitle,
    contentUrl: contentUrl.present ? contentUrl.value : this.contentUrl,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    subjectName: subjectName.present ? subjectName.value : this.subjectName,
    subjectIndex: subjectIndex.present ? subjectIndex.value : this.subjectIndex,
    lessonNumber: lessonNumber.present ? lessonNumber.value : this.lessonNumber,
    totalLessons: totalLessons.present ? totalLessons.value : this.totalLessons,
    isBookmarked: isBookmarked ?? this.isBookmarked,
    isRunning: isRunning ?? this.isRunning,
    isUpcoming: isUpcoming ?? this.isUpcoming,
    hasAttempts: hasAttempts ?? this.hasAttempts,
    image: image.present ? image.value : this.image,
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
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      chapterTitle: data.chapterTitle.present
          ? data.chapterTitle.value
          : this.chapterTitle,
      contentUrl: data.contentUrl.present
          ? data.contentUrl.value
          : this.contentUrl,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      subjectIndex: data.subjectIndex.present
          ? data.subjectIndex.value
          : this.subjectIndex,
      lessonNumber: data.lessonNumber.present
          ? data.lessonNumber.value
          : this.lessonNumber,
      totalLessons: data.totalLessons.present
          ? data.totalLessons.value
          : this.totalLessons,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
      isRunning: data.isRunning.present ? data.isRunning.value : this.isRunning,
      isUpcoming: data.isUpcoming.present
          ? data.isUpcoming.value
          : this.isUpcoming,
      hasAttempts: data.hasAttempts.present
          ? data.hasAttempts.value
          : this.hasAttempts,
      image: data.image.present ? data.image.value : this.image,
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
          ..write('orderIndex: $orderIndex, ')
          ..write('chapterTitle: $chapterTitle, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('subtitle: $subtitle, ')
          ..write('subjectName: $subjectName, ')
          ..write('subjectIndex: $subjectIndex, ')
          ..write('lessonNumber: $lessonNumber, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isRunning: $isRunning, ')
          ..write('isUpcoming: $isUpcoming, ')
          ..write('hasAttempts: $hasAttempts, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chapterId,
    title,
    type,
    duration,
    progressStatus,
    isLocked,
    orderIndex,
    chapterTitle,
    contentUrl,
    subtitle,
    subjectName,
    subjectIndex,
    lessonNumber,
    totalLessons,
    isBookmarked,
    isRunning,
    isUpcoming,
    hasAttempts,
    image,
  );
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
          other.orderIndex == this.orderIndex &&
          other.chapterTitle == this.chapterTitle &&
          other.contentUrl == this.contentUrl &&
          other.subtitle == this.subtitle &&
          other.subjectName == this.subjectName &&
          other.subjectIndex == this.subjectIndex &&
          other.lessonNumber == this.lessonNumber &&
          other.totalLessons == this.totalLessons &&
          other.isBookmarked == this.isBookmarked &&
          other.isRunning == this.isRunning &&
          other.isUpcoming == this.isUpcoming &&
          other.hasAttempts == this.hasAttempts &&
          other.image == this.image);
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
  final Value<String?> chapterTitle;
  final Value<String?> contentUrl;
  final Value<String?> subtitle;
  final Value<String?> subjectName;
  final Value<int?> subjectIndex;
  final Value<int?> lessonNumber;
  final Value<int?> totalLessons;
  final Value<bool> isBookmarked;
  final Value<bool> isRunning;
  final Value<bool> isUpcoming;
  final Value<bool> hasAttempts;
  final Value<String?> image;
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
    this.chapterTitle = const Value.absent(),
    this.contentUrl = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.subjectIndex = const Value.absent(),
    this.lessonNumber = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.isUpcoming = const Value.absent(),
    this.hasAttempts = const Value.absent(),
    this.image = const Value.absent(),
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
    this.chapterTitle = const Value.absent(),
    this.contentUrl = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.subjectIndex = const Value.absent(),
    this.lessonNumber = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.isUpcoming = const Value.absent(),
    this.hasAttempts = const Value.absent(),
    this.image = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
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
    Expression<String>? chapterTitle,
    Expression<String>? contentUrl,
    Expression<String>? subtitle,
    Expression<String>? subjectName,
    Expression<int>? subjectIndex,
    Expression<int>? lessonNumber,
    Expression<int>? totalLessons,
    Expression<bool>? isBookmarked,
    Expression<bool>? isRunning,
    Expression<bool>? isUpcoming,
    Expression<bool>? hasAttempts,
    Expression<String>? image,
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
      if (chapterTitle != null) 'chapter_title': chapterTitle,
      if (contentUrl != null) 'content_url': contentUrl,
      if (subtitle != null) 'subtitle': subtitle,
      if (subjectName != null) 'subject_name': subjectName,
      if (subjectIndex != null) 'subject_index': subjectIndex,
      if (lessonNumber != null) 'lesson_number': lessonNumber,
      if (totalLessons != null) 'total_lessons': totalLessons,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (isRunning != null) 'is_running': isRunning,
      if (isUpcoming != null) 'is_upcoming': isUpcoming,
      if (hasAttempts != null) 'has_attempts': hasAttempts,
      if (image != null) 'image': image,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? title,
    Value<String>? type,
    Value<String>? duration,
    Value<String>? progressStatus,
    Value<bool>? isLocked,
    Value<int>? orderIndex,
    Value<String?>? chapterTitle,
    Value<String?>? contentUrl,
    Value<String?>? subtitle,
    Value<String?>? subjectName,
    Value<int?>? subjectIndex,
    Value<int?>? lessonNumber,
    Value<int?>? totalLessons,
    Value<bool>? isBookmarked,
    Value<bool>? isRunning,
    Value<bool>? isUpcoming,
    Value<bool>? hasAttempts,
    Value<String?>? image,
    Value<int>? rowid,
  }) {
    return LessonsTableCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      progressStatus: progressStatus ?? this.progressStatus,
      isLocked: isLocked ?? this.isLocked,
      orderIndex: orderIndex ?? this.orderIndex,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      contentUrl: contentUrl ?? this.contentUrl,
      subtitle: subtitle ?? this.subtitle,
      subjectName: subjectName ?? this.subjectName,
      subjectIndex: subjectIndex ?? this.subjectIndex,
      lessonNumber: lessonNumber ?? this.lessonNumber,
      totalLessons: totalLessons ?? this.totalLessons,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRunning: isRunning ?? this.isRunning,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      hasAttempts: hasAttempts ?? this.hasAttempts,
      image: image ?? this.image,
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
    if (chapterTitle.present) {
      map['chapter_title'] = Variable<String>(chapterTitle.value);
    }
    if (contentUrl.present) {
      map['content_url'] = Variable<String>(contentUrl.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (subjectIndex.present) {
      map['subject_index'] = Variable<int>(subjectIndex.value);
    }
    if (lessonNumber.present) {
      map['lesson_number'] = Variable<int>(lessonNumber.value);
    }
    if (totalLessons.present) {
      map['total_lessons'] = Variable<int>(totalLessons.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (isRunning.present) {
      map['is_running'] = Variable<bool>(isRunning.value);
    }
    if (isUpcoming.present) {
      map['is_upcoming'] = Variable<bool>(isUpcoming.value);
    }
    if (hasAttempts.present) {
      map['has_attempts'] = Variable<bool>(hasAttempts.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
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
          ..write('chapterTitle: $chapterTitle, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('subtitle: $subtitle, ')
          ..write('subjectName: $subjectName, ')
          ..write('subjectIndex: $subjectIndex, ')
          ..write('lessonNumber: $lessonNumber, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isRunning: $isRunning, ')
          ..write('isUpcoming: $isUpcoming, ')
          ..write('hasAttempts: $hasAttempts, ')
          ..write('image: $image, ')
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
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facultyMeta = const VerificationMeta(
    'faculty',
  );
  @override
  late final GeneratedColumn<String> faculty = GeneratedColumn<String>(
    'faculty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subject,
    topic,
    time,
    faculty,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'live_classes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LiveClassesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('faculty')) {
      context.handle(
        _facultyMeta,
        faculty.isAcceptableOrUnknown(data['faculty']!, _facultyMeta),
      );
    } else if (isInserting) {
      context.missing(_facultyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      faculty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculty'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
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
  const LiveClassesTableData({
    required this.id,
    required this.subject,
    required this.topic,
    required this.time,
    required this.faculty,
    required this.status,
  });
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

  factory LiveClassesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  LiveClassesTableData copyWith({
    String? id,
    String? subject,
    String? topic,
    String? time,
    String? faculty,
    String? status,
  }) => LiveClassesTableData(
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
  }) : id = Value(id),
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

  LiveClassesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? subject,
    Value<String>? topic,
    Value<String>? time,
    Value<String>? faculty,
    Value<String>? status,
    Value<int>? rowid,
  }) {
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
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorAvatarMeta = const VerificationMeta(
    'authorAvatar',
  );
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
    'author_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeAgoMeta = const VerificationMeta(
    'timeAgo',
  );
  @override
  late final GeneratedColumn<String> timeAgo = GeneratedColumn<String>(
    'time_ago',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _replyCountMeta = const VerificationMeta(
    'replyCount',
  );
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
    'reply_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _upvotesMeta = const VerificationMeta(
    'upvotes',
  );
  @override
  late final GeneratedColumn<int> upvotes = GeneratedColumn<int>(
    'upvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downvotesMeta = const VerificationMeta(
    'downvotes',
  );
  @override
  late final GeneratedColumn<int> downvotes = GeneratedColumn<int>(
    'downvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    description,
    authorName,
    authorAvatar,
    timeAgo,
    replyCount,
    upvotes,
    downvotes,
    status,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forum_threads_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ForumThreadsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
        _authorAvatarMeta,
        authorAvatar.isAcceptableOrUnknown(
          data['author_avatar']!,
          _authorAvatarMeta,
        ),
      );
    }
    if (data.containsKey('time_ago')) {
      context.handle(
        _timeAgoMeta,
        timeAgo.isAcceptableOrUnknown(data['time_ago']!, _timeAgoMeta),
      );
    } else if (isInserting) {
      context.missing(_timeAgoMeta);
    }
    if (data.containsKey('reply_count')) {
      context.handle(
        _replyCountMeta,
        replyCount.isAcceptableOrUnknown(data['reply_count']!, _replyCountMeta),
      );
    }
    if (data.containsKey('upvotes')) {
      context.handle(
        _upvotesMeta,
        upvotes.isAcceptableOrUnknown(data['upvotes']!, _upvotesMeta),
      );
    }
    if (data.containsKey('downvotes')) {
      context.handle(
        _downvotesMeta,
        downvotes.isAcceptableOrUnknown(data['downvotes']!, _downvotesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForumThreadsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForumThreadsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      authorAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar'],
      ),
      timeAgo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_ago'],
      )!,
      replyCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reply_count'],
      )!,
      upvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}upvotes'],
      )!,
      downvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downvotes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
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
  final String authorName;
  final String? authorAvatar;
  final String timeAgo;
  final int replyCount;
  final int upvotes;
  final int downvotes;

  /// Stored as string: 'answered' | 'unanswered'
  final String status;
  final String? imageUrl;
  const ForumThreadsTableData({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorAvatar,
    required this.timeAgo,
    required this.replyCount,
    required this.upvotes,
    required this.downvotes,
    required this.status,
    this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['time_ago'] = Variable<String>(timeAgo);
    map['reply_count'] = Variable<int>(replyCount);
    map['upvotes'] = Variable<int>(upvotes);
    map['downvotes'] = Variable<int>(downvotes);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  ForumThreadsTableCompanion toCompanion(bool nullToAbsent) {
    return ForumThreadsTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      description: Value(description),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      timeAgo: Value(timeAgo),
      replyCount: Value(replyCount),
      upvotes: Value(upvotes),
      downvotes: Value(downvotes),
      status: Value(status),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory ForumThreadsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForumThreadsTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      timeAgo: serializer.fromJson<String>(json['timeAgo']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      upvotes: serializer.fromJson<int>(json['upvotes']),
      downvotes: serializer.fromJson<int>(json['downvotes']),
      status: serializer.fromJson<String>(json['status']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
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
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'timeAgo': serializer.toJson<String>(timeAgo),
      'replyCount': serializer.toJson<int>(replyCount),
      'upvotes': serializer.toJson<int>(upvotes),
      'downvotes': serializer.toJson<int>(downvotes),
      'status': serializer.toJson<String>(status),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  ForumThreadsTableData copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    String? authorName,
    Value<String?> authorAvatar = const Value.absent(),
    String? timeAgo,
    int? replyCount,
    int? upvotes,
    int? downvotes,
    String? status,
    Value<String?> imageUrl = const Value.absent(),
  }) => ForumThreadsTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    description: description ?? this.description,
    authorName: authorName ?? this.authorName,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    timeAgo: timeAgo ?? this.timeAgo,
    replyCount: replyCount ?? this.replyCount,
    upvotes: upvotes ?? this.upvotes,
    downvotes: downvotes ?? this.downvotes,
    status: status ?? this.status,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
  );
  ForumThreadsTableData copyWithCompanion(ForumThreadsTableCompanion data) {
    return ForumThreadsTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      timeAgo: data.timeAgo.present ? data.timeAgo.value : this.timeAgo,
      replyCount: data.replyCount.present
          ? data.replyCount.value
          : this.replyCount,
      upvotes: data.upvotes.present ? data.upvotes.value : this.upvotes,
      downvotes: data.downvotes.present ? data.downvotes.value : this.downvotes,
      status: data.status.present ? data.status.value : this.status,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForumThreadsTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('replyCount: $replyCount, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('status: $status, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    title,
    description,
    authorName,
    authorAvatar,
    timeAgo,
    replyCount,
    upvotes,
    downvotes,
    status,
    imageUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForumThreadsTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.description == this.description &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.timeAgo == this.timeAgo &&
          other.replyCount == this.replyCount &&
          other.upvotes == this.upvotes &&
          other.downvotes == this.downvotes &&
          other.status == this.status &&
          other.imageUrl == this.imageUrl);
}

class ForumThreadsTableCompanion
    extends UpdateCompanion<ForumThreadsTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> timeAgo;
  final Value<int> replyCount;
  final Value<int> upvotes;
  final Value<int> downvotes;
  final Value<String> status;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const ForumThreadsTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.status = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForumThreadsTableCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required String description,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String timeAgo,
    this.replyCount = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    required String status,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       title = Value(title),
       description = Value(description),
       authorName = Value(authorName),
       timeAgo = Value(timeAgo),
       status = Value(status);
  static Insertable<ForumThreadsTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? timeAgo,
    Expression<int>? replyCount,
    Expression<int>? upvotes,
    Expression<int>? downvotes,
    Expression<String>? status,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (timeAgo != null) 'time_ago': timeAgo,
      if (replyCount != null) 'reply_count': replyCount,
      if (upvotes != null) 'upvotes': upvotes,
      if (downvotes != null) 'downvotes': downvotes,
      if (status != null) 'status': status,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForumThreadsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? authorName,
    Value<String?>? authorAvatar,
    Value<String>? timeAgo,
    Value<int>? replyCount,
    Value<int>? upvotes,
    Value<int>? downvotes,
    Value<String>? status,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return ForumThreadsTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      timeAgo: timeAgo ?? this.timeAgo,
      replyCount: replyCount ?? this.replyCount,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
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
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (timeAgo.present) {
      map['time_ago'] = Variable<String>(timeAgo.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (upvotes.present) {
      map['upvotes'] = Variable<int>(upvotes.value);
    }
    if (downvotes.present) {
      map['downvotes'] = Variable<int>(downvotes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
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
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('replyCount: $replyCount, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('status: $status, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ForumCommentsTableTable extends ForumCommentsTable
    with TableInfo<$ForumCommentsTableTable, ForumCommentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ForumCommentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorAvatarMeta = const VerificationMeta(
    'authorAvatar',
  );
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
    'author_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeAgoMeta = const VerificationMeta(
    'timeAgo',
  );
  @override
  late final GeneratedColumn<String> timeAgo = GeneratedColumn<String>(
    'time_ago',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _upvotesMeta = const VerificationMeta(
    'upvotes',
  );
  @override
  late final GeneratedColumn<int> upvotes = GeneratedColumn<int>(
    'upvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downvotesMeta = const VerificationMeta(
    'downvotes',
  );
  @override
  late final GeneratedColumn<int> downvotes = GeneratedColumn<int>(
    'downvotes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isInstructorMeta = const VerificationMeta(
    'isInstructor',
  );
  @override
  late final GeneratedColumn<bool> isInstructor = GeneratedColumn<bool>(
    'is_instructor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_instructor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    threadId,
    authorName,
    authorAvatar,
    content,
    timeAgo,
    upvotes,
    downvotes,
    isInstructor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forum_comments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ForumCommentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
        _authorAvatarMeta,
        authorAvatar.isAcceptableOrUnknown(
          data['author_avatar']!,
          _authorAvatarMeta,
        ),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('time_ago')) {
      context.handle(
        _timeAgoMeta,
        timeAgo.isAcceptableOrUnknown(data['time_ago']!, _timeAgoMeta),
      );
    } else if (isInserting) {
      context.missing(_timeAgoMeta);
    }
    if (data.containsKey('upvotes')) {
      context.handle(
        _upvotesMeta,
        upvotes.isAcceptableOrUnknown(data['upvotes']!, _upvotesMeta),
      );
    }
    if (data.containsKey('downvotes')) {
      context.handle(
        _downvotesMeta,
        downvotes.isAcceptableOrUnknown(data['downvotes']!, _downvotesMeta),
      );
    }
    if (data.containsKey('is_instructor')) {
      context.handle(
        _isInstructorMeta,
        isInstructor.isAcceptableOrUnknown(
          data['is_instructor']!,
          _isInstructorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForumCommentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForumCommentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      authorAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timeAgo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_ago'],
      )!,
      upvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}upvotes'],
      )!,
      downvotes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downvotes'],
      )!,
      isInstructor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_instructor'],
      )!,
    );
  }

  @override
  $ForumCommentsTableTable createAlias(String alias) {
    return $ForumCommentsTableTable(attachedDatabase, alias);
  }
}

class ForumCommentsTableData extends DataClass
    implements Insertable<ForumCommentsTableData> {
  final String id;
  final String threadId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String timeAgo;
  final int upvotes;
  final int downvotes;
  final bool isInstructor;
  const ForumCommentsTableData({
    required this.id,
    required this.threadId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.timeAgo,
    required this.upvotes,
    required this.downvotes,
    required this.isInstructor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['content'] = Variable<String>(content);
    map['time_ago'] = Variable<String>(timeAgo);
    map['upvotes'] = Variable<int>(upvotes);
    map['downvotes'] = Variable<int>(downvotes);
    map['is_instructor'] = Variable<bool>(isInstructor);
    return map;
  }

  ForumCommentsTableCompanion toCompanion(bool nullToAbsent) {
    return ForumCommentsTableCompanion(
      id: Value(id),
      threadId: Value(threadId),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      content: Value(content),
      timeAgo: Value(timeAgo),
      upvotes: Value(upvotes),
      downvotes: Value(downvotes),
      isInstructor: Value(isInstructor),
    );
  }

  factory ForumCommentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForumCommentsTableData(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      content: serializer.fromJson<String>(json['content']),
      timeAgo: serializer.fromJson<String>(json['timeAgo']),
      upvotes: serializer.fromJson<int>(json['upvotes']),
      downvotes: serializer.fromJson<int>(json['downvotes']),
      isInstructor: serializer.fromJson<bool>(json['isInstructor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'content': serializer.toJson<String>(content),
      'timeAgo': serializer.toJson<String>(timeAgo),
      'upvotes': serializer.toJson<int>(upvotes),
      'downvotes': serializer.toJson<int>(downvotes),
      'isInstructor': serializer.toJson<bool>(isInstructor),
    };
  }

  ForumCommentsTableData copyWith({
    String? id,
    String? threadId,
    String? authorName,
    Value<String?> authorAvatar = const Value.absent(),
    String? content,
    String? timeAgo,
    int? upvotes,
    int? downvotes,
    bool? isInstructor,
  }) => ForumCommentsTableData(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    authorName: authorName ?? this.authorName,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    content: content ?? this.content,
    timeAgo: timeAgo ?? this.timeAgo,
    upvotes: upvotes ?? this.upvotes,
    downvotes: downvotes ?? this.downvotes,
    isInstructor: isInstructor ?? this.isInstructor,
  );
  ForumCommentsTableData copyWithCompanion(ForumCommentsTableCompanion data) {
    return ForumCommentsTableData(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      content: data.content.present ? data.content.value : this.content,
      timeAgo: data.timeAgo.present ? data.timeAgo.value : this.timeAgo,
      upvotes: data.upvotes.present ? data.upvotes.value : this.upvotes,
      downvotes: data.downvotes.present ? data.downvotes.value : this.downvotes,
      isInstructor: data.isInstructor.present
          ? data.isInstructor.value
          : this.isInstructor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForumCommentsTableData(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('isInstructor: $isInstructor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    threadId,
    authorName,
    authorAvatar,
    content,
    timeAgo,
    upvotes,
    downvotes,
    isInstructor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForumCommentsTableData &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.content == this.content &&
          other.timeAgo == this.timeAgo &&
          other.upvotes == this.upvotes &&
          other.downvotes == this.downvotes &&
          other.isInstructor == this.isInstructor);
}

class ForumCommentsTableCompanion
    extends UpdateCompanion<ForumCommentsTableData> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> content;
  final Value<String> timeAgo;
  final Value<int> upvotes;
  final Value<int> downvotes;
  final Value<bool> isInstructor;
  final Value<int> rowid;
  const ForumCommentsTableCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.content = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.isInstructor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForumCommentsTableCompanion.insert({
    required String id,
    required String threadId,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String content,
    required String timeAgo,
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.isInstructor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       authorName = Value(authorName),
       content = Value(content),
       timeAgo = Value(timeAgo);
  static Insertable<ForumCommentsTableData> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? content,
    Expression<String>? timeAgo,
    Expression<int>? upvotes,
    Expression<int>? downvotes,
    Expression<bool>? isInstructor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (content != null) 'content': content,
      if (timeAgo != null) 'time_ago': timeAgo,
      if (upvotes != null) 'upvotes': upvotes,
      if (downvotes != null) 'downvotes': downvotes,
      if (isInstructor != null) 'is_instructor': isInstructor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForumCommentsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? authorName,
    Value<String?>? authorAvatar,
    Value<String>? content,
    Value<String>? timeAgo,
    Value<int>? upvotes,
    Value<int>? downvotes,
    Value<bool>? isInstructor,
    Value<int>? rowid,
  }) {
    return ForumCommentsTableCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      isInstructor: isInstructor ?? this.isInstructor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timeAgo.present) {
      map['time_ago'] = Variable<String>(timeAgo.value);
    }
    if (upvotes.present) {
      map['upvotes'] = Variable<int>(upvotes.value);
    }
    if (downvotes.present) {
      map['downvotes'] = Variable<int>(downvotes.value);
    }
    if (isInstructor.present) {
      map['is_instructor'] = Variable<bool>(isInstructor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForumCommentsTableCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('isInstructor: $isInstructor, ')
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
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentCompleteMeta = const VerificationMeta(
    'percentComplete',
  );
  @override
  late final GeneratedColumn<int> percentComplete = GeneratedColumn<int>(
    'percent_complete',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAccessedAtMeta = const VerificationMeta(
    'lastAccessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>(
        'last_accessed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    lessonId,
    courseId,
    percentComplete,
    lastAccessedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('percent_complete')) {
      context.handle(
        _percentCompleteMeta,
        percentComplete.isAcceptableOrUnknown(
          data['percent_complete']!,
          _percentCompleteMeta,
        ),
      );
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
        _lastAccessedAtMeta,
        lastAccessedAt.isAcceptableOrUnknown(
          data['last_accessed_at']!,
          _lastAccessedAtMeta,
        ),
      );
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
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      percentComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent_complete'],
      )!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_accessed_at'],
      )!,
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
  const UserProgressTableData({
    required this.userId,
    required this.lessonId,
    required this.courseId,
    required this.percentComplete,
    required this.lastAccessedAt,
  });
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

  factory UserProgressTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  UserProgressTableData copyWith({
    String? userId,
    String? lessonId,
    String? courseId,
    int? percentComplete,
    DateTime? lastAccessedAt,
  }) => UserProgressTableData(
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
  }) : userId = Value(userId),
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

  UserProgressTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? lessonId,
    Value<String>? courseId,
    Value<int>? percentComplete,
    Value<DateTime>? lastAccessedAt,
    Value<int>? rowid,
  }) {
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

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appearanceModeMeta = const VerificationMeta(
    'appearanceMode',
  );
  @override
  late final GeneratedColumn<String> appearanceMode = GeneratedColumn<String>(
    'appearance_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppSettingsDefaults.appearanceMode),
  );
  static const VerificationMeta _videoQualityMeta = const VerificationMeta(
    'videoQuality',
  );
  @override
  late final GeneratedColumn<String> videoQuality = GeneratedColumn<String>(
    'video_quality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppSettingsDefaults.videoQuality),
  );
  static const VerificationMeta _autoPlayNextMeta = const VerificationMeta(
    'autoPlayNext',
  );
  @override
  late final GeneratedColumn<bool> autoPlayNext = GeneratedColumn<bool>(
    'auto_play_next',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_play_next" IN (0, 1))',
    ),
    defaultValue: const Constant(AppSettingsDefaults.autoPlayNext),
  );
  static const VerificationMeta _textSizeMeta = const VerificationMeta(
    'textSize',
  );
  @override
  late final GeneratedColumn<String> textSize = GeneratedColumn<String>(
    'text_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppSettingsDefaults.textSize),
  );
  static const VerificationMeta _highContrastMeta = const VerificationMeta(
    'highContrast',
  );
  @override
  late final GeneratedColumn<bool> highContrast = GeneratedColumn<bool>(
    'high_contrast',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("high_contrast" IN (0, 1))',
    ),
    defaultValue: const Constant(AppSettingsDefaults.highContrast),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appearanceMode,
    videoQuality,
    autoPlayNext,
    textSize,
    highContrast,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('appearance_mode')) {
      context.handle(
        _appearanceModeMeta,
        appearanceMode.isAcceptableOrUnknown(
          data['appearance_mode']!,
          _appearanceModeMeta,
        ),
      );
    }
    if (data.containsKey('video_quality')) {
      context.handle(
        _videoQualityMeta,
        videoQuality.isAcceptableOrUnknown(
          data['video_quality']!,
          _videoQualityMeta,
        ),
      );
    }
    if (data.containsKey('auto_play_next')) {
      context.handle(
        _autoPlayNextMeta,
        autoPlayNext.isAcceptableOrUnknown(
          data['auto_play_next']!,
          _autoPlayNextMeta,
        ),
      );
    }
    if (data.containsKey('text_size')) {
      context.handle(
        _textSizeMeta,
        textSize.isAcceptableOrUnknown(data['text_size']!, _textSizeMeta),
      );
    }
    if (data.containsKey('high_contrast')) {
      context.handle(
        _highContrastMeta,
        highContrast.isAcceptableOrUnknown(
          data['high_contrast']!,
          _highContrastMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      appearanceMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance_mode'],
      )!,
      videoQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_quality'],
      )!,
      autoPlayNext: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_play_next'],
      )!,
      textSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_size'],
      )!,
      highContrast: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}high_contrast'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final String appearanceMode;
  final String videoQuality;
  final bool autoPlayNext;
  final String textSize;
  final bool highContrast;
  const AppSettingsTableData({
    required this.id,
    required this.appearanceMode,
    required this.videoQuality,
    required this.autoPlayNext,
    required this.textSize,
    required this.highContrast,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['appearance_mode'] = Variable<String>(appearanceMode);
    map['video_quality'] = Variable<String>(videoQuality);
    map['auto_play_next'] = Variable<bool>(autoPlayNext);
    map['text_size'] = Variable<String>(textSize);
    map['high_contrast'] = Variable<bool>(highContrast);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      appearanceMode: Value(appearanceMode),
      videoQuality: Value(videoQuality),
      autoPlayNext: Value(autoPlayNext),
      textSize: Value(textSize),
      highContrast: Value(highContrast),
    );
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      appearanceMode: serializer.fromJson<String>(json['appearanceMode']),
      videoQuality: serializer.fromJson<String>(json['videoQuality']),
      autoPlayNext: serializer.fromJson<bool>(json['autoPlayNext']),
      textSize: serializer.fromJson<String>(json['textSize']),
      highContrast: serializer.fromJson<bool>(json['highContrast']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appearanceMode': serializer.toJson<String>(appearanceMode),
      'videoQuality': serializer.toJson<String>(videoQuality),
      'autoPlayNext': serializer.toJson<bool>(autoPlayNext),
      'textSize': serializer.toJson<String>(textSize),
      'highContrast': serializer.toJson<bool>(highContrast),
    };
  }

  AppSettingsTableData copyWith({
    int? id,
    String? appearanceMode,
    String? videoQuality,
    bool? autoPlayNext,
    String? textSize,
    bool? highContrast,
  }) => AppSettingsTableData(
    id: id ?? this.id,
    appearanceMode: appearanceMode ?? this.appearanceMode,
    videoQuality: videoQuality ?? this.videoQuality,
    autoPlayNext: autoPlayNext ?? this.autoPlayNext,
    textSize: textSize ?? this.textSize,
    highContrast: highContrast ?? this.highContrast,
  );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      appearanceMode: data.appearanceMode.present
          ? data.appearanceMode.value
          : this.appearanceMode,
      videoQuality: data.videoQuality.present
          ? data.videoQuality.value
          : this.videoQuality,
      autoPlayNext: data.autoPlayNext.present
          ? data.autoPlayNext.value
          : this.autoPlayNext,
      textSize: data.textSize.present ? data.textSize.value : this.textSize,
      highContrast: data.highContrast.present
          ? data.highContrast.value
          : this.highContrast,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('appearanceMode: $appearanceMode, ')
          ..write('videoQuality: $videoQuality, ')
          ..write('autoPlayNext: $autoPlayNext, ')
          ..write('textSize: $textSize, ')
          ..write('highContrast: $highContrast')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appearanceMode,
    videoQuality,
    autoPlayNext,
    textSize,
    highContrast,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.appearanceMode == this.appearanceMode &&
          other.videoQuality == this.videoQuality &&
          other.autoPlayNext == this.autoPlayNext &&
          other.textSize == this.textSize &&
          other.highContrast == this.highContrast);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<String> appearanceMode;
  final Value<String> videoQuality;
  final Value<bool> autoPlayNext;
  final Value<String> textSize;
  final Value<bool> highContrast;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.appearanceMode = const Value.absent(),
    this.videoQuality = const Value.absent(),
    this.autoPlayNext = const Value.absent(),
    this.textSize = const Value.absent(),
    this.highContrast = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.appearanceMode = const Value.absent(),
    this.videoQuality = const Value.absent(),
    this.autoPlayNext = const Value.absent(),
    this.textSize = const Value.absent(),
    this.highContrast = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? appearanceMode,
    Expression<String>? videoQuality,
    Expression<bool>? autoPlayNext,
    Expression<String>? textSize,
    Expression<bool>? highContrast,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appearanceMode != null) 'appearance_mode': appearanceMode,
      if (videoQuality != null) 'video_quality': videoQuality,
      if (autoPlayNext != null) 'auto_play_next': autoPlayNext,
      if (textSize != null) 'text_size': textSize,
      if (highContrast != null) 'high_contrast': highContrast,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? appearanceMode,
    Value<String>? videoQuality,
    Value<bool>? autoPlayNext,
    Value<String>? textSize,
    Value<bool>? highContrast,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      appearanceMode: appearanceMode ?? this.appearanceMode,
      videoQuality: videoQuality ?? this.videoQuality,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      textSize: textSize ?? this.textSize,
      highContrast: highContrast ?? this.highContrast,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appearanceMode.present) {
      map['appearance_mode'] = Variable<String>(appearanceMode.value);
    }
    if (videoQuality.present) {
      map['video_quality'] = Variable<String>(videoQuality.value);
    }
    if (autoPlayNext.present) {
      map['auto_play_next'] = Variable<bool>(autoPlayNext.value);
    }
    if (textSize.present) {
      map['text_size'] = Variable<String>(textSize.value);
    }
    if (highContrast.present) {
      map['high_contrast'] = Variable<bool>(highContrast.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('appearanceMode: $appearanceMode, ')
          ..write('videoQuality: $videoQuality, ')
          ..write('autoPlayNext: $autoPlayNext, ')
          ..write('textSize: $textSize, ')
          ..write('highContrast: $highContrast')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joinedDateMeta = const VerificationMeta(
    'joinedDate',
  );
  @override
  late final GeneratedColumn<DateTime> joinedDate = GeneratedColumn<DateTime>(
    'joined_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    username,
    firstName,
    lastName,
    email,
    phone,
    avatar,
    joinedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('joined_date')) {
      context.handle(
        _joinedDateMeta,
        joinedDate.isAcceptableOrUnknown(data['joined_date']!, _joinedDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      joinedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_date'],
      ),
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String? name;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? avatar;
  final DateTime? joinedDate;
  const UsersTableData({
    required this.id,
    this.name,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.joinedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || joinedDate != null) {
      map['joined_date'] = Variable<DateTime>(joinedDate);
    }
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      joinedDate: joinedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedDate),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      username: serializer.fromJson<String?>(json['username']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      joinedDate: serializer.fromJson<DateTime?>(json['joinedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'username': serializer.toJson<String?>(username),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'avatar': serializer.toJson<String?>(avatar),
      'joinedDate': serializer.toJson<DateTime?>(joinedDate),
    };
  }

  UsersTableData copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> firstName = const Value.absent(),
    Value<String?> lastName = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> avatar = const Value.absent(),
    Value<DateTime?> joinedDate = const Value.absent(),
  }) => UsersTableData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    username: username.present ? username.value : this.username,
    firstName: firstName.present ? firstName.value : this.firstName,
    lastName: lastName.present ? lastName.value : this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    avatar: avatar.present ? avatar.value : this.avatar,
    joinedDate: joinedDate.present ? joinedDate.value : this.joinedDate,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      joinedDate: data.joinedDate.present
          ? data.joinedDate.value
          : this.joinedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('joinedDate: $joinedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    username,
    firstName,
    lastName,
    email,
    phone,
    avatar,
    joinedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.username == this.username &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.avatar == this.avatar &&
          other.joinedDate == this.joinedDate);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> username;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> avatar;
  final Value<DateTime?> joinedDate;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.joinedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.joinedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? avatar,
    Expression<DateTime>? joinedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (joinedDate != null) 'joined_date': joinedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? username,
    Value<String?>? firstName,
    Value<String?>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? avatar,
    Value<DateTime?>? joinedDate,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      joinedDate: joinedDate ?? this.joinedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (joinedDate.present) {
      map['joined_date'] = Variable<DateTime>(joinedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('joinedDate: $joinedDate, ')
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
  late final $LiveClassesTableTable liveClassesTable = $LiveClassesTableTable(
    this,
  );
  late final $ForumThreadsTableTable forumThreadsTable =
      $ForumThreadsTableTable(this);
  late final $ForumCommentsTableTable forumCommentsTable =
      $ForumCommentsTableTable(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $UsersTableTable usersTable = $UsersTableTable(this);
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
    forumCommentsTable,
    userProgressTable,
    appSettingsTable,
    usersTable,
  ];
}

typedef $$CoursesTableTableCreateCompanionBuilder =
    CoursesTableCompanion Function({
      required String id,
      required String title,
      required int colorIndex,
      required int chapterCount,
      required String totalDuration,
      Value<int> totalContents,
      Value<int> progress,
      Value<int> completedLessons,
      required int totalLessons,
      Value<String?> image,
      Value<bool> isChaptersSynced,
      Value<int> rowid,
    });
typedef $$CoursesTableTableUpdateCompanionBuilder =
    CoursesTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> colorIndex,
      Value<int> chapterCount,
      Value<String> totalDuration,
      Value<int> totalContents,
      Value<int> progress,
      Value<int> completedLessons,
      Value<int> totalLessons,
      Value<String?> image,
      Value<bool> isChaptersSynced,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalContents => $composableBuilder(
    column: $table.totalContents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedLessons => $composableBuilder(
    column: $table.completedLessons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalContents => $composableBuilder(
    column: $table.totalContents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedLessons => $composableBuilder(
    column: $table.completedLessons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.colorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalContents => $composableBuilder(
    column: $table.totalContents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get completedLessons => $composableBuilder(
    column: $table.completedLessons,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => column,
  );
}

class $$CoursesTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>,
          ),
          CoursesTableData,
          PrefetchHooks Function()
        > {
  $$CoursesTableTableTableManager(_$AppDatabase db, $CoursesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> colorIndex = const Value.absent(),
                Value<int> chapterCount = const Value.absent(),
                Value<String> totalDuration = const Value.absent(),
                Value<int> totalContents = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> completedLessons = const Value.absent(),
                Value<int> totalLessons = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<bool> isChaptersSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion(
                id: id,
                title: title,
                colorIndex: colorIndex,
                chapterCount: chapterCount,
                totalDuration: totalDuration,
                totalContents: totalContents,
                progress: progress,
                completedLessons: completedLessons,
                totalLessons: totalLessons,
                image: image,
                isChaptersSynced: isChaptersSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int colorIndex,
                required int chapterCount,
                required String totalDuration,
                Value<int> totalContents = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> completedLessons = const Value.absent(),
                required int totalLessons,
                Value<String?> image = const Value.absent(),
                Value<bool> isChaptersSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion.insert(
                id: id,
                title: title,
                colorIndex: colorIndex,
                chapterCount: chapterCount,
                totalDuration: totalDuration,
                totalContents: totalContents,
                progress: progress,
                completedLessons: completedLessons,
                totalLessons: totalLessons,
                image: image,
                isChaptersSynced: isChaptersSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoursesTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>,
      ),
      CoursesTableData,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableTableCreateCompanionBuilder =
    ChaptersTableCompanion Function({
      required String id,
      required String courseId,
      required String title,
      required int lessonCount,
      required int assessmentCount,
      required int orderIndex,
      Value<String?> parentId,
      Value<bool> isLeaf,
      Value<bool> isChaptersSynced,
      Value<String?> image,
      Value<int> rowid,
    });
typedef $$ChaptersTableTableUpdateCompanionBuilder =
    ChaptersTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> title,
      Value<int> lessonCount,
      Value<int> assessmentCount,
      Value<int> orderIndex,
      Value<String?> parentId,
      Value<bool> isLeaf,
      Value<bool> isChaptersSynced,
      Value<String?> image,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonCount => $composableBuilder(
    column: $table.lessonCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assessmentCount => $composableBuilder(
    column: $table.assessmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonCount => $composableBuilder(
    column: $table.lessonCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assessmentCount => $composableBuilder(
    column: $table.assessmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.lessonCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assessmentCount => $composableBuilder(
    column: $table.assessmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<bool> get isLeaf =>
      $composableBuilder(column: $table.isLeaf, builder: (column) => column);

  GeneratedColumn<bool> get isChaptersSynced => $composableBuilder(
    column: $table.isChaptersSynced,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);
}

class $$ChaptersTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $ChaptersTableTable,
              ChaptersTableData
            >,
          ),
          ChaptersTableData,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> lessonCount = const Value.absent(),
                Value<int> assessmentCount = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<bool> isLeaf = const Value.absent(),
                Value<bool> isChaptersSynced = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion(
                id: id,
                courseId: courseId,
                title: title,
                lessonCount: lessonCount,
                assessmentCount: assessmentCount,
                orderIndex: orderIndex,
                parentId: parentId,
                isLeaf: isLeaf,
                isChaptersSynced: isChaptersSynced,
                image: image,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String title,
                required int lessonCount,
                required int assessmentCount,
                required int orderIndex,
                Value<String?> parentId = const Value.absent(),
                Value<bool> isLeaf = const Value.absent(),
                Value<bool> isChaptersSynced = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                lessonCount: lessonCount,
                assessmentCount: assessmentCount,
                orderIndex: orderIndex,
                parentId: parentId,
                isLeaf: isLeaf,
                isChaptersSynced: isChaptersSynced,
                image: image,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData>,
      ),
      ChaptersTableData,
      PrefetchHooks Function()
    >;
typedef $$LessonsTableTableCreateCompanionBuilder =
    LessonsTableCompanion Function({
      required String id,
      required String chapterId,
      required String title,
      required String type,
      required String duration,
      Value<String> progressStatus,
      Value<bool> isLocked,
      required int orderIndex,
      Value<String?> chapterTitle,
      Value<String?> contentUrl,
      Value<String?> subtitle,
      Value<String?> subjectName,
      Value<int?> subjectIndex,
      Value<int?> lessonNumber,
      Value<int?> totalLessons,
      Value<bool> isBookmarked,
      Value<bool> isRunning,
      Value<bool> isUpcoming,
      Value<bool> hasAttempts,
      Value<String?> image,
      Value<int> rowid,
    });
typedef $$LessonsTableTableUpdateCompanionBuilder =
    LessonsTableCompanion Function({
      Value<String> id,
      Value<String> chapterId,
      Value<String> title,
      Value<String> type,
      Value<String> duration,
      Value<String> progressStatus,
      Value<bool> isLocked,
      Value<int> orderIndex,
      Value<String?> chapterTitle,
      Value<String?> contentUrl,
      Value<String?> subtitle,
      Value<String?> subjectName,
      Value<int?> subjectIndex,
      Value<int?> lessonNumber,
      Value<int?> totalLessons,
      Value<bool> isBookmarked,
      Value<bool> isRunning,
      Value<bool> isUpcoming,
      Value<bool> hasAttempts,
      Value<String?> image,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressStatus => $composableBuilder(
    column: $table.progressStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectIndex => $composableBuilder(
    column: $table.subjectIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonNumber => $composableBuilder(
    column: $table.lessonNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUpcoming => $composableBuilder(
    column: $table.isUpcoming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAttempts => $composableBuilder(
    column: $table.hasAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressStatus => $composableBuilder(
    column: $table.progressStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectIndex => $composableBuilder(
    column: $table.subjectIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonNumber => $composableBuilder(
    column: $table.lessonNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUpcoming => $composableBuilder(
    column: $table.isUpcoming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAttempts => $composableBuilder(
    column: $table.hasAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.progressStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subjectIndex => $composableBuilder(
    column: $table.subjectIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lessonNumber => $composableBuilder(
    column: $table.lessonNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLessons => $composableBuilder(
    column: $table.totalLessons,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRunning =>
      $composableBuilder(column: $table.isRunning, builder: (column) => column);

  GeneratedColumn<bool> get isUpcoming => $composableBuilder(
    column: $table.isUpcoming,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAttempts => $composableBuilder(
    column: $table.hasAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);
}

class $$LessonsTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>,
          ),
          LessonsTableData,
          PrefetchHooks Function()
        > {
  $$LessonsTableTableTableManager(_$AppDatabase db, $LessonsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<String> progressStatus = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> chapterTitle = const Value.absent(),
                Value<String?> contentUrl = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> subjectName = const Value.absent(),
                Value<int?> subjectIndex = const Value.absent(),
                Value<int?> lessonNumber = const Value.absent(),
                Value<int?> totalLessons = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<bool> isUpcoming = const Value.absent(),
                Value<bool> hasAttempts = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion(
                id: id,
                chapterId: chapterId,
                title: title,
                type: type,
                duration: duration,
                progressStatus: progressStatus,
                isLocked: isLocked,
                orderIndex: orderIndex,
                chapterTitle: chapterTitle,
                contentUrl: contentUrl,
                subtitle: subtitle,
                subjectName: subjectName,
                subjectIndex: subjectIndex,
                lessonNumber: lessonNumber,
                totalLessons: totalLessons,
                isBookmarked: isBookmarked,
                isRunning: isRunning,
                isUpcoming: isUpcoming,
                hasAttempts: hasAttempts,
                image: image,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String title,
                required String type,
                required String duration,
                Value<String> progressStatus = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                required int orderIndex,
                Value<String?> chapterTitle = const Value.absent(),
                Value<String?> contentUrl = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> subjectName = const Value.absent(),
                Value<int?> subjectIndex = const Value.absent(),
                Value<int?> lessonNumber = const Value.absent(),
                Value<int?> totalLessons = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<bool> isUpcoming = const Value.absent(),
                Value<bool> hasAttempts = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion.insert(
                id: id,
                chapterId: chapterId,
                title: title,
                type: type,
                duration: duration,
                progressStatus: progressStatus,
                isLocked: isLocked,
                orderIndex: orderIndex,
                chapterTitle: chapterTitle,
                contentUrl: contentUrl,
                subtitle: subtitle,
                subjectName: subjectName,
                subjectIndex: subjectIndex,
                lessonNumber: lessonNumber,
                totalLessons: totalLessons,
                isBookmarked: isBookmarked,
                isRunning: isRunning,
                isUpcoming: isUpcoming,
                hasAttempts: hasAttempts,
                image: image,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonsTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>,
      ),
      LessonsTableData,
      PrefetchHooks Function()
    >;
typedef $$LiveClassesTableTableCreateCompanionBuilder =
    LiveClassesTableCompanion Function({
      required String id,
      required String subject,
      required String topic,
      required String time,
      required String faculty,
      required String status,
      Value<int> rowid,
    });
typedef $$LiveClassesTableTableUpdateCompanionBuilder =
    LiveClassesTableCompanion Function({
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faculty => $composableBuilder(
    column: $table.faculty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faculty => $composableBuilder(
    column: $table.faculty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
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

class $$LiveClassesTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $LiveClassesTableTable,
              LiveClassesTableData
            >,
          ),
          LiveClassesTableData,
          PrefetchHooks Function()
        > {
  $$LiveClassesTableTableTableManager(
    _$AppDatabase db,
    $LiveClassesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiveClassesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiveClassesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiveClassesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<String> faculty = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LiveClassesTableCompanion(
                id: id,
                subject: subject,
                topic: topic,
                time: time,
                faculty: faculty,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subject,
                required String topic,
                required String time,
                required String faculty,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => LiveClassesTableCompanion.insert(
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
        ),
      );
}

typedef $$LiveClassesTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<
          _$AppDatabase,
          $LiveClassesTableTable,
          LiveClassesTableData
        >,
      ),
      LiveClassesTableData,
      PrefetchHooks Function()
    >;
typedef $$ForumThreadsTableTableCreateCompanionBuilder =
    ForumThreadsTableCompanion Function({
      required String id,
      required String courseId,
      required String title,
      required String description,
      required String authorName,
      Value<String?> authorAvatar,
      required String timeAgo,
      Value<int> replyCount,
      Value<int> upvotes,
      Value<int> downvotes,
      required String status,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$ForumThreadsTableTableUpdateCompanionBuilder =
    ForumThreadsTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> title,
      Value<String> description,
      Value<String> authorName,
      Value<String?> authorAvatar,
      Value<String> timeAgo,
      Value<int> replyCount,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<String> status,
      Value<String?> imageUrl,
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeAgo =>
      $composableBuilder(column: $table.timeAgo, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get upvotes =>
      $composableBuilder(column: $table.upvotes, builder: (column) => column);

  GeneratedColumn<int> get downvotes =>
      $composableBuilder(column: $table.downvotes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$ForumThreadsTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $ForumThreadsTableTable,
              ForumThreadsTableData
            >,
          ),
          ForumThreadsTableData,
          PrefetchHooks Function()
        > {
  $$ForumThreadsTableTableTableManager(
    _$AppDatabase db,
    $ForumThreadsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForumThreadsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ForumThreadsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ForumThreadsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<String> timeAgo = const Value.absent(),
                Value<int> replyCount = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumThreadsTableCompanion(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                authorName: authorName,
                authorAvatar: authorAvatar,
                timeAgo: timeAgo,
                replyCount: replyCount,
                upvotes: upvotes,
                downvotes: downvotes,
                status: status,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String title,
                required String description,
                required String authorName,
                Value<String?> authorAvatar = const Value.absent(),
                required String timeAgo,
                Value<int> replyCount = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                required String status,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumThreadsTableCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                authorName: authorName,
                authorAvatar: authorAvatar,
                timeAgo: timeAgo,
                replyCount: replyCount,
                upvotes: upvotes,
                downvotes: downvotes,
                status: status,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ForumThreadsTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<
          _$AppDatabase,
          $ForumThreadsTableTable,
          ForumThreadsTableData
        >,
      ),
      ForumThreadsTableData,
      PrefetchHooks Function()
    >;
typedef $$ForumCommentsTableTableCreateCompanionBuilder =
    ForumCommentsTableCompanion Function({
      required String id,
      required String threadId,
      required String authorName,
      Value<String?> authorAvatar,
      required String content,
      required String timeAgo,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<bool> isInstructor,
      Value<int> rowid,
    });
typedef $$ForumCommentsTableTableUpdateCompanionBuilder =
    ForumCommentsTableCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> authorName,
      Value<String?> authorAvatar,
      Value<String> content,
      Value<String> timeAgo,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<bool> isInstructor,
      Value<int> rowid,
    });

class $$ForumCommentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ForumCommentsTableTable> {
  $$ForumCommentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInstructor => $composableBuilder(
    column: $table.isInstructor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ForumCommentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ForumCommentsTableTable> {
  $$ForumCommentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeAgo => $composableBuilder(
    column: $table.timeAgo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get upvotes => $composableBuilder(
    column: $table.upvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downvotes => $composableBuilder(
    column: $table.downvotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInstructor => $composableBuilder(
    column: $table.isInstructor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ForumCommentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ForumCommentsTableTable> {
  $$ForumCommentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get timeAgo =>
      $composableBuilder(column: $table.timeAgo, builder: (column) => column);

  GeneratedColumn<int> get upvotes =>
      $composableBuilder(column: $table.upvotes, builder: (column) => column);

  GeneratedColumn<int> get downvotes =>
      $composableBuilder(column: $table.downvotes, builder: (column) => column);

  GeneratedColumn<bool> get isInstructor => $composableBuilder(
    column: $table.isInstructor,
    builder: (column) => column,
  );
}

class $$ForumCommentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ForumCommentsTableTable,
          ForumCommentsTableData,
          $$ForumCommentsTableTableFilterComposer,
          $$ForumCommentsTableTableOrderingComposer,
          $$ForumCommentsTableTableAnnotationComposer,
          $$ForumCommentsTableTableCreateCompanionBuilder,
          $$ForumCommentsTableTableUpdateCompanionBuilder,
          (
            ForumCommentsTableData,
            BaseReferences<
              _$AppDatabase,
              $ForumCommentsTableTable,
              ForumCommentsTableData
            >,
          ),
          ForumCommentsTableData,
          PrefetchHooks Function()
        > {
  $$ForumCommentsTableTableTableManager(
    _$AppDatabase db,
    $ForumCommentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForumCommentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ForumCommentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ForumCommentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> timeAgo = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<bool> isInstructor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumCommentsTableCompanion(
                id: id,
                threadId: threadId,
                authorName: authorName,
                authorAvatar: authorAvatar,
                content: content,
                timeAgo: timeAgo,
                upvotes: upvotes,
                downvotes: downvotes,
                isInstructor: isInstructor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String authorName,
                Value<String?> authorAvatar = const Value.absent(),
                required String content,
                required String timeAgo,
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<bool> isInstructor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumCommentsTableCompanion.insert(
                id: id,
                threadId: threadId,
                authorName: authorName,
                authorAvatar: authorAvatar,
                content: content,
                timeAgo: timeAgo,
                upvotes: upvotes,
                downvotes: downvotes,
                isInstructor: isInstructor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ForumCommentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ForumCommentsTableTable,
      ForumCommentsTableData,
      $$ForumCommentsTableTableFilterComposer,
      $$ForumCommentsTableTableOrderingComposer,
      $$ForumCommentsTableTableAnnotationComposer,
      $$ForumCommentsTableTableCreateCompanionBuilder,
      $$ForumCommentsTableTableUpdateCompanionBuilder,
      (
        ForumCommentsTableData,
        BaseReferences<
          _$AppDatabase,
          $ForumCommentsTableTable,
          ForumCommentsTableData
        >,
      ),
      ForumCommentsTableData,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableTableCreateCompanionBuilder =
    UserProgressTableCompanion Function({
      required String userId,
      required String lessonId,
      required String courseId,
      Value<int> percentComplete,
      required DateTime lastAccessedAt,
      Value<int> rowid,
    });
typedef $$UserProgressTableTableUpdateCompanionBuilder =
    UserProgressTableCompanion Function({
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
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.percentComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => column,
  );
}

class $$UserProgressTableTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $UserProgressTableTable,
              UserProgressTableData
            >,
          ),
          UserProgressTableData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableTableManager(
    _$AppDatabase db,
    $UserProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<int> percentComplete = const Value.absent(),
                Value<DateTime> lastAccessedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProgressTableCompanion(
                userId: userId,
                lessonId: lessonId,
                courseId: courseId,
                percentComplete: percentComplete,
                lastAccessedAt: lastAccessedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String lessonId,
                required String courseId,
                Value<int> percentComplete = const Value.absent(),
                required DateTime lastAccessedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProgressTableCompanion.insert(
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
        ),
      );
}

typedef $$UserProgressTableTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<
          _$AppDatabase,
          $UserProgressTableTable,
          UserProgressTableData
        >,
      ),
      UserProgressTableData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> appearanceMode,
      Value<String> videoQuality,
      Value<bool> autoPlayNext,
      Value<String> textSize,
      Value<bool> highContrast,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> appearanceMode,
      Value<String> videoQuality,
      Value<bool> autoPlayNext,
      Value<String> textSize,
      Value<bool> highContrast,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearanceMode => $composableBuilder(
    column: $table.appearanceMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoQuality => $composableBuilder(
    column: $table.videoQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPlayNext => $composableBuilder(
    column: $table.autoPlayNext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textSize => $composableBuilder(
    column: $table.textSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get highContrast => $composableBuilder(
    column: $table.highContrast,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearanceMode => $composableBuilder(
    column: $table.appearanceMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoQuality => $composableBuilder(
    column: $table.videoQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPlayNext => $composableBuilder(
    column: $table.autoPlayNext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textSize => $composableBuilder(
    column: $table.textSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get highContrast => $composableBuilder(
    column: $table.highContrast,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appearanceMode => $composableBuilder(
    column: $table.appearanceMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get videoQuality => $composableBuilder(
    column: $table.videoQuality,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoPlayNext => $composableBuilder(
    column: $table.autoPlayNext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textSize =>
      $composableBuilder(column: $table.textSize, builder: (column) => column);

  GeneratedColumn<bool> get highContrast => $composableBuilder(
    column: $table.highContrast,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> appearanceMode = const Value.absent(),
                Value<String> videoQuality = const Value.absent(),
                Value<bool> autoPlayNext = const Value.absent(),
                Value<String> textSize = const Value.absent(),
                Value<bool> highContrast = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                appearanceMode: appearanceMode,
                videoQuality: videoQuality,
                autoPlayNext: autoPlayNext,
                textSize: textSize,
                highContrast: highContrast,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> appearanceMode = const Value.absent(),
                Value<String> videoQuality = const Value.absent(),
                Value<bool> autoPlayNext = const Value.absent(),
                Value<String> textSize = const Value.absent(),
                Value<bool> highContrast = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                id: id,
                appearanceMode: appearanceMode,
                videoQuality: videoQuality,
                autoPlayNext: autoPlayNext,
                textSize: textSize,
                highContrast: highContrast,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> username,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> avatar,
      Value<DateTime?> joinedDate,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> username,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> avatar,
      Value<DateTime?> joinedDate,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedDate => $composableBuilder(
    column: $table.joinedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedDate => $composableBuilder(
    column: $table.joinedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedDate => $composableBuilder(
    column: $table.joinedDate,
    builder: (column) => column,
  );
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UsersTableData,
            BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
          ),
          UsersTableData,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<DateTime?> joinedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                name: name,
                username: username,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                avatar: avatar,
                joinedDate: joinedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<DateTime?> joinedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                name: name,
                username: username,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                avatar: avatar,
                joinedDate: joinedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UsersTableData,
        BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
      ),
      UsersTableData,
      PrefetchHooks Function()
    >;

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
  $$ForumCommentsTableTableTableManager get forumCommentsTable =>
      $$ForumCommentsTableTableTableManager(_db, _db.forumCommentsTable);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
}
