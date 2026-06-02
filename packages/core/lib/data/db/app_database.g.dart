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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowedDevicesMeta = const VerificationMeta(
    'allowedDevices',
  );
  @override
  late final GeneratedColumn<String> allowedDevices = GeneratedColumn<String>(
    'allowed_devices',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examsCountMeta = const VerificationMeta(
    'examsCount',
  );
  @override
  late final GeneratedColumn<int> examsCount = GeneratedColumn<int>(
    'exams_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    tags,
    allowedDevices,
    examsCount,
    orderIndex,
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
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('allowed_devices')) {
      context.handle(
        _allowedDevicesMeta,
        allowedDevices.isAcceptableOrUnknown(
          data['allowed_devices']!,
          _allowedDevicesMeta,
        ),
      );
    }
    if (data.containsKey('exams_count')) {
      context.handle(
        _examsCountMeta,
        examsCount.isAcceptableOrUnknown(data['exams_count']!, _examsCountMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
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
      ),
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
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      allowedDevices: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allowed_devices'],
      ),
      examsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exams_count'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
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
  final String? totalDuration;
  final int totalContents;
  final int progress;
  final int completedLessons;
  final int totalLessons;
  final String? image;
  final String? tags;
  final String? allowedDevices;
  final int examsCount;
  final int orderIndex;
  final bool isChaptersSynced;
  const CoursesTableData({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chapterCount,
    this.totalDuration,
    required this.totalContents,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    this.image,
    this.tags,
    this.allowedDevices,
    required this.examsCount,
    required this.orderIndex,
    required this.isChaptersSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['color_index'] = Variable<int>(colorIndex);
    map['chapter_count'] = Variable<int>(chapterCount);
    if (!nullToAbsent || totalDuration != null) {
      map['total_duration'] = Variable<String>(totalDuration);
    }
    map['total_contents'] = Variable<int>(totalContents);
    map['progress'] = Variable<int>(progress);
    map['completed_lessons'] = Variable<int>(completedLessons);
    map['total_lessons'] = Variable<int>(totalLessons);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || allowedDevices != null) {
      map['allowed_devices'] = Variable<String>(allowedDevices);
    }
    map['exams_count'] = Variable<int>(examsCount);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_chapters_synced'] = Variable<bool>(isChaptersSynced);
    return map;
  }

  CoursesTableCompanion toCompanion(bool nullToAbsent) {
    return CoursesTableCompanion(
      id: Value(id),
      title: Value(title),
      colorIndex: Value(colorIndex),
      chapterCount: Value(chapterCount),
      totalDuration: totalDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDuration),
      totalContents: Value(totalContents),
      progress: Value(progress),
      completedLessons: Value(completedLessons),
      totalLessons: Value(totalLessons),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      allowedDevices: allowedDevices == null && nullToAbsent
          ? const Value.absent()
          : Value(allowedDevices),
      examsCount: Value(examsCount),
      orderIndex: Value(orderIndex),
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
      totalDuration: serializer.fromJson<String?>(json['totalDuration']),
      totalContents: serializer.fromJson<int>(json['totalContents']),
      progress: serializer.fromJson<int>(json['progress']),
      completedLessons: serializer.fromJson<int>(json['completedLessons']),
      totalLessons: serializer.fromJson<int>(json['totalLessons']),
      image: serializer.fromJson<String?>(json['image']),
      tags: serializer.fromJson<String?>(json['tags']),
      allowedDevices: serializer.fromJson<String?>(json['allowedDevices']),
      examsCount: serializer.fromJson<int>(json['examsCount']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
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
      'totalDuration': serializer.toJson<String?>(totalDuration),
      'totalContents': serializer.toJson<int>(totalContents),
      'progress': serializer.toJson<int>(progress),
      'completedLessons': serializer.toJson<int>(completedLessons),
      'totalLessons': serializer.toJson<int>(totalLessons),
      'image': serializer.toJson<String?>(image),
      'tags': serializer.toJson<String?>(tags),
      'allowedDevices': serializer.toJson<String?>(allowedDevices),
      'examsCount': serializer.toJson<int>(examsCount),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isChaptersSynced': serializer.toJson<bool>(isChaptersSynced),
    };
  }

  CoursesTableData copyWith({
    String? id,
    String? title,
    int? colorIndex,
    int? chapterCount,
    Value<String?> totalDuration = const Value.absent(),
    int? totalContents,
    int? progress,
    int? completedLessons,
    int? totalLessons,
    Value<String?> image = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> allowedDevices = const Value.absent(),
    int? examsCount,
    int? orderIndex,
    bool? isChaptersSynced,
  }) => CoursesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    colorIndex: colorIndex ?? this.colorIndex,
    chapterCount: chapterCount ?? this.chapterCount,
    totalDuration: totalDuration.present
        ? totalDuration.value
        : this.totalDuration,
    totalContents: totalContents ?? this.totalContents,
    progress: progress ?? this.progress,
    completedLessons: completedLessons ?? this.completedLessons,
    totalLessons: totalLessons ?? this.totalLessons,
    image: image.present ? image.value : this.image,
    tags: tags.present ? tags.value : this.tags,
    allowedDevices: allowedDevices.present
        ? allowedDevices.value
        : this.allowedDevices,
    examsCount: examsCount ?? this.examsCount,
    orderIndex: orderIndex ?? this.orderIndex,
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
      tags: data.tags.present ? data.tags.value : this.tags,
      allowedDevices: data.allowedDevices.present
          ? data.allowedDevices.value
          : this.allowedDevices,
      examsCount: data.examsCount.present
          ? data.examsCount.value
          : this.examsCount,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
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
          ..write('tags: $tags, ')
          ..write('allowedDevices: $allowedDevices, ')
          ..write('examsCount: $examsCount, ')
          ..write('orderIndex: $orderIndex, ')
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
    tags,
    allowedDevices,
    examsCount,
    orderIndex,
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
          other.tags == this.tags &&
          other.allowedDevices == this.allowedDevices &&
          other.examsCount == this.examsCount &&
          other.orderIndex == this.orderIndex &&
          other.isChaptersSynced == this.isChaptersSynced);
}

class CoursesTableCompanion extends UpdateCompanion<CoursesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> colorIndex;
  final Value<int> chapterCount;
  final Value<String?> totalDuration;
  final Value<int> totalContents;
  final Value<int> progress;
  final Value<int> completedLessons;
  final Value<int> totalLessons;
  final Value<String?> image;
  final Value<String?> tags;
  final Value<String?> allowedDevices;
  final Value<int> examsCount;
  final Value<int> orderIndex;
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
    this.tags = const Value.absent(),
    this.allowedDevices = const Value.absent(),
    this.examsCount = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesTableCompanion.insert({
    required String id,
    required String title,
    required int colorIndex,
    required int chapterCount,
    this.totalDuration = const Value.absent(),
    this.totalContents = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedLessons = const Value.absent(),
    required int totalLessons,
    this.image = const Value.absent(),
    this.tags = const Value.absent(),
    this.allowedDevices = const Value.absent(),
    this.examsCount = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isChaptersSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       colorIndex = Value(colorIndex),
       chapterCount = Value(chapterCount),
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
    Expression<String>? tags,
    Expression<String>? allowedDevices,
    Expression<int>? examsCount,
    Expression<int>? orderIndex,
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
      if (tags != null) 'tags': tags,
      if (allowedDevices != null) 'allowed_devices': allowedDevices,
      if (examsCount != null) 'exams_count': examsCount,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isChaptersSynced != null) 'is_chapters_synced': isChaptersSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? colorIndex,
    Value<int>? chapterCount,
    Value<String?>? totalDuration,
    Value<int>? totalContents,
    Value<int>? progress,
    Value<int>? completedLessons,
    Value<int>? totalLessons,
    Value<String?>? image,
    Value<String?>? tags,
    Value<String?>? allowedDevices,
    Value<int>? examsCount,
    Value<int>? orderIndex,
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
      tags: tags ?? this.tags,
      allowedDevices: allowedDevices ?? this.allowedDevices,
      examsCount: examsCount ?? this.examsCount,
      orderIndex: orderIndex ?? this.orderIndex,
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
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (allowedDevices.present) {
      map['allowed_devices'] = Variable<String>(allowedDevices.value);
    }
    if (examsCount.present) {
      map['exams_count'] = Variable<int>(examsCount.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
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
          ..write('tags: $tags, ')
          ..write('allowedDevices: $allowedDevices, ')
          ..write('examsCount: $examsCount, ')
          ..write('orderIndex: $orderIndex, ')
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
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ancestorChapterIdsMeta =
      const VerificationMeta('ancestorChapterIds');
  @override
  late final GeneratedColumn<String> ancestorChapterIds =
      GeneratedColumn<String>(
        'ancestor_chapter_ids',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
  static const VerificationMeta _bookmarkIdMeta = const VerificationMeta(
    'bookmarkId',
  );
  @override
  late final GeneratedColumn<int> bookmarkId = GeneratedColumn<int>(
    'bookmark_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nextContentIdMeta = const VerificationMeta(
    'nextContentId',
  );
  @override
  late final GeneratedColumn<String> nextContentId = GeneratedColumn<String>(
    'next_content_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousContentIdMeta = const VerificationMeta(
    'previousContentId',
  );
  @override
  late final GeneratedColumn<String> previousContentId =
      GeneratedColumn<String>(
        'previous_content_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _htmlContentMeta = const VerificationMeta(
    'htmlContent',
  );
  @override
  late final GeneratedColumn<String> htmlContent = GeneratedColumn<String>(
    'html_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chatEmbedUrlMeta = const VerificationMeta(
    'chatEmbedUrl',
  );
  @override
  late final GeneratedColumn<String> chatEmbedUrl = GeneratedColumn<String>(
    'chat_embed_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streamStatusMeta = const VerificationMeta(
    'streamStatus',
  );
  @override
  late final GeneratedColumn<String> streamStatus = GeneratedColumn<String>(
    'stream_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _showRecordedVideoMeta = const VerificationMeta(
    'showRecordedVideo',
  );
  @override
  late final GeneratedColumn<bool> showRecordedVideo = GeneratedColumn<bool>(
    'show_recorded_video',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_recorded_video" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDetailFetchedMeta = const VerificationMeta(
    'isDetailFetched',
  );
  @override
  late final GeneratedColumn<bool> isDetailFetched = GeneratedColumn<bool>(
    'is_detail_fetched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_detail_fetched" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isScheduledMeta = const VerificationMeta(
    'isScheduled',
  );
  @override
  late final GeneratedColumn<bool> isScheduled = GeneratedColumn<bool>(
    'is_scheduled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_scheduled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scheduledMessageMeta = const VerificationMeta(
    'scheduledMessage',
  );
  @override
  late final GeneratedColumn<String> scheduledMessage = GeneratedColumn<String>(
    'scheduled_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsUrlMeta = const VerificationMeta(
    'attemptsUrl',
  );
  @override
  late final GeneratedColumn<String> attemptsUrl = GeneratedColumn<String>(
    'attempts_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examMetadataJsonMeta = const VerificationMeta(
    'examMetadataJson',
  );
  @override
  late final GeneratedColumn<String> examMetadataJson = GeneratedColumn<String>(
    'exam_metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enableTranscriptMeta = const VerificationMeta(
    'enableTranscript',
  );
  @override
  late final GeneratedColumn<bool> enableTranscript = GeneratedColumn<bool>(
    'enable_transcript',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_transcript" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _videoSubtitleUrlMeta = const VerificationMeta(
    'videoSubtitleUrl',
  );
  @override
  late final GeneratedColumn<String> videoSubtitleUrl = GeneratedColumn<String>(
    'video_subtitle_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAiEnabledMeta = const VerificationMeta(
    'isAiEnabled',
  );
  @override
  late final GeneratedColumn<bool> isAiEnabled = GeneratedColumn<bool>(
    'is_ai_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ai_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aiNotesUrlMeta = const VerificationMeta(
    'aiNotesUrl',
  );
  @override
  late final GeneratedColumn<String> aiNotesUrl = GeneratedColumn<String>(
    'ai_notes_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    courseId,
    ancestorChapterIds,
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
    bookmarkId,
    isRunning,
    isUpcoming,
    hasAttempts,
    image,
    nextContentId,
    previousContentId,
    htmlContent,
    chatEmbedUrl,
    streamStatus,
    showRecordedVideo,
    isDetailFetched,
    isScheduled,
    scheduledMessage,
    attemptsUrl,
    slug,
    description,
    examMetadataJson,
    enableTranscript,
    videoSubtitleUrl,
    isAiEnabled,
    aiNotesUrl,
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
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    }
    if (data.containsKey('ancestor_chapter_ids')) {
      context.handle(
        _ancestorChapterIdsMeta,
        ancestorChapterIds.isAcceptableOrUnknown(
          data['ancestor_chapter_ids']!,
          _ancestorChapterIdsMeta,
        ),
      );
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
    if (data.containsKey('bookmark_id')) {
      context.handle(
        _bookmarkIdMeta,
        bookmarkId.isAcceptableOrUnknown(data['bookmark_id']!, _bookmarkIdMeta),
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
    if (data.containsKey('next_content_id')) {
      context.handle(
        _nextContentIdMeta,
        nextContentId.isAcceptableOrUnknown(
          data['next_content_id']!,
          _nextContentIdMeta,
        ),
      );
    }
    if (data.containsKey('previous_content_id')) {
      context.handle(
        _previousContentIdMeta,
        previousContentId.isAcceptableOrUnknown(
          data['previous_content_id']!,
          _previousContentIdMeta,
        ),
      );
    }
    if (data.containsKey('html_content')) {
      context.handle(
        _htmlContentMeta,
        htmlContent.isAcceptableOrUnknown(
          data['html_content']!,
          _htmlContentMeta,
        ),
      );
    }
    if (data.containsKey('chat_embed_url')) {
      context.handle(
        _chatEmbedUrlMeta,
        chatEmbedUrl.isAcceptableOrUnknown(
          data['chat_embed_url']!,
          _chatEmbedUrlMeta,
        ),
      );
    }
    if (data.containsKey('stream_status')) {
      context.handle(
        _streamStatusMeta,
        streamStatus.isAcceptableOrUnknown(
          data['stream_status']!,
          _streamStatusMeta,
        ),
      );
    }
    if (data.containsKey('show_recorded_video')) {
      context.handle(
        _showRecordedVideoMeta,
        showRecordedVideo.isAcceptableOrUnknown(
          data['show_recorded_video']!,
          _showRecordedVideoMeta,
        ),
      );
    }
    if (data.containsKey('is_detail_fetched')) {
      context.handle(
        _isDetailFetchedMeta,
        isDetailFetched.isAcceptableOrUnknown(
          data['is_detail_fetched']!,
          _isDetailFetchedMeta,
        ),
      );
    }
    if (data.containsKey('is_scheduled')) {
      context.handle(
        _isScheduledMeta,
        isScheduled.isAcceptableOrUnknown(
          data['is_scheduled']!,
          _isScheduledMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_message')) {
      context.handle(
        _scheduledMessageMeta,
        scheduledMessage.isAcceptableOrUnknown(
          data['scheduled_message']!,
          _scheduledMessageMeta,
        ),
      );
    }
    if (data.containsKey('attempts_url')) {
      context.handle(
        _attemptsUrlMeta,
        attemptsUrl.isAcceptableOrUnknown(
          data['attempts_url']!,
          _attemptsUrlMeta,
        ),
      );
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('exam_metadata_json')) {
      context.handle(
        _examMetadataJsonMeta,
        examMetadataJson.isAcceptableOrUnknown(
          data['exam_metadata_json']!,
          _examMetadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('enable_transcript')) {
      context.handle(
        _enableTranscriptMeta,
        enableTranscript.isAcceptableOrUnknown(
          data['enable_transcript']!,
          _enableTranscriptMeta,
        ),
      );
    }
    if (data.containsKey('video_subtitle_url')) {
      context.handle(
        _videoSubtitleUrlMeta,
        videoSubtitleUrl.isAcceptableOrUnknown(
          data['video_subtitle_url']!,
          _videoSubtitleUrlMeta,
        ),
      );
    }
    if (data.containsKey('is_ai_enabled')) {
      context.handle(
        _isAiEnabledMeta,
        isAiEnabled.isAcceptableOrUnknown(
          data['is_ai_enabled']!,
          _isAiEnabledMeta,
        ),
      );
    }
    if (data.containsKey('ai_notes_url')) {
      context.handle(
        _aiNotesUrlMeta,
        aiNotesUrl.isAcceptableOrUnknown(
          data['ai_notes_url']!,
          _aiNotesUrlMeta,
        ),
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
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      ),
      ancestorChapterIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ancestor_chapter_ids'],
      ),
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
      bookmarkId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bookmark_id'],
      ),
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
      nextContentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_content_id'],
      ),
      previousContentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_content_id'],
      ),
      htmlContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}html_content'],
      ),
      chatEmbedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_embed_url'],
      ),
      streamStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream_status'],
      ),
      showRecordedVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_recorded_video'],
      )!,
      isDetailFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_detail_fetched'],
      )!,
      isScheduled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_scheduled'],
      )!,
      scheduledMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_message'],
      ),
      attemptsUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempts_url'],
      ),
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      examMetadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_metadata_json'],
      ),
      enableTranscript: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_transcript'],
      )!,
      videoSubtitleUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_subtitle_url'],
      ),
      isAiEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ai_enabled'],
      )!,
      aiNotesUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_notes_url'],
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
  final String? courseId;
  final String? ancestorChapterIds;
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
  final int? bookmarkId;
  final bool isRunning;
  final bool isUpcoming;
  final bool hasAttempts;
  final String? image;
  final String? nextContentId;
  final String? previousContentId;
  final String? htmlContent;
  final String? chatEmbedUrl;
  final String? streamStatus;
  final bool showRecordedVideo;
  final bool isDetailFetched;
  final bool isScheduled;
  final String? scheduledMessage;
  final String? attemptsUrl;
  final String? slug;
  final String? description;
  final String? examMetadataJson;
  final bool enableTranscript;
  final String? videoSubtitleUrl;
  final bool isAiEnabled;
  final String? aiNotesUrl;
  const LessonsTableData({
    required this.id,
    required this.chapterId,
    this.courseId,
    this.ancestorChapterIds,
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
    this.bookmarkId,
    required this.isRunning,
    required this.isUpcoming,
    required this.hasAttempts,
    this.image,
    this.nextContentId,
    this.previousContentId,
    this.htmlContent,
    this.chatEmbedUrl,
    this.streamStatus,
    required this.showRecordedVideo,
    required this.isDetailFetched,
    required this.isScheduled,
    this.scheduledMessage,
    this.attemptsUrl,
    this.slug,
    this.description,
    this.examMetadataJson,
    required this.enableTranscript,
    this.videoSubtitleUrl,
    required this.isAiEnabled,
    this.aiNotesUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    if (!nullToAbsent || courseId != null) {
      map['course_id'] = Variable<String>(courseId);
    }
    if (!nullToAbsent || ancestorChapterIds != null) {
      map['ancestor_chapter_ids'] = Variable<String>(ancestorChapterIds);
    }
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
    if (!nullToAbsent || bookmarkId != null) {
      map['bookmark_id'] = Variable<int>(bookmarkId);
    }
    map['is_running'] = Variable<bool>(isRunning);
    map['is_upcoming'] = Variable<bool>(isUpcoming);
    map['has_attempts'] = Variable<bool>(hasAttempts);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || nextContentId != null) {
      map['next_content_id'] = Variable<String>(nextContentId);
    }
    if (!nullToAbsent || previousContentId != null) {
      map['previous_content_id'] = Variable<String>(previousContentId);
    }
    if (!nullToAbsent || htmlContent != null) {
      map['html_content'] = Variable<String>(htmlContent);
    }
    if (!nullToAbsent || chatEmbedUrl != null) {
      map['chat_embed_url'] = Variable<String>(chatEmbedUrl);
    }
    if (!nullToAbsent || streamStatus != null) {
      map['stream_status'] = Variable<String>(streamStatus);
    }
    map['show_recorded_video'] = Variable<bool>(showRecordedVideo);
    map['is_detail_fetched'] = Variable<bool>(isDetailFetched);
    map['is_scheduled'] = Variable<bool>(isScheduled);
    if (!nullToAbsent || scheduledMessage != null) {
      map['scheduled_message'] = Variable<String>(scheduledMessage);
    }
    if (!nullToAbsent || attemptsUrl != null) {
      map['attempts_url'] = Variable<String>(attemptsUrl);
    }
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || examMetadataJson != null) {
      map['exam_metadata_json'] = Variable<String>(examMetadataJson);
    }
    map['enable_transcript'] = Variable<bool>(enableTranscript);
    if (!nullToAbsent || videoSubtitleUrl != null) {
      map['video_subtitle_url'] = Variable<String>(videoSubtitleUrl);
    }
    map['is_ai_enabled'] = Variable<bool>(isAiEnabled);
    if (!nullToAbsent || aiNotesUrl != null) {
      map['ai_notes_url'] = Variable<String>(aiNotesUrl);
    }
    return map;
  }

  LessonsTableCompanion toCompanion(bool nullToAbsent) {
    return LessonsTableCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      ancestorChapterIds: ancestorChapterIds == null && nullToAbsent
          ? const Value.absent()
          : Value(ancestorChapterIds),
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
      bookmarkId: bookmarkId == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarkId),
      isRunning: Value(isRunning),
      isUpcoming: Value(isUpcoming),
      hasAttempts: Value(hasAttempts),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      nextContentId: nextContentId == null && nullToAbsent
          ? const Value.absent()
          : Value(nextContentId),
      previousContentId: previousContentId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousContentId),
      htmlContent: htmlContent == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlContent),
      chatEmbedUrl: chatEmbedUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(chatEmbedUrl),
      streamStatus: streamStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(streamStatus),
      showRecordedVideo: Value(showRecordedVideo),
      isDetailFetched: Value(isDetailFetched),
      isScheduled: Value(isScheduled),
      scheduledMessage: scheduledMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledMessage),
      attemptsUrl: attemptsUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(attemptsUrl),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      examMetadataJson: examMetadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(examMetadataJson),
      enableTranscript: Value(enableTranscript),
      videoSubtitleUrl: videoSubtitleUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoSubtitleUrl),
      isAiEnabled: Value(isAiEnabled),
      aiNotesUrl: aiNotesUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(aiNotesUrl),
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
      courseId: serializer.fromJson<String?>(json['courseId']),
      ancestorChapterIds: serializer.fromJson<String?>(
        json['ancestorChapterIds'],
      ),
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
      bookmarkId: serializer.fromJson<int?>(json['bookmarkId']),
      isRunning: serializer.fromJson<bool>(json['isRunning']),
      isUpcoming: serializer.fromJson<bool>(json['isUpcoming']),
      hasAttempts: serializer.fromJson<bool>(json['hasAttempts']),
      image: serializer.fromJson<String?>(json['image']),
      nextContentId: serializer.fromJson<String?>(json['nextContentId']),
      previousContentId: serializer.fromJson<String?>(
        json['previousContentId'],
      ),
      htmlContent: serializer.fromJson<String?>(json['htmlContent']),
      chatEmbedUrl: serializer.fromJson<String?>(json['chatEmbedUrl']),
      streamStatus: serializer.fromJson<String?>(json['streamStatus']),
      showRecordedVideo: serializer.fromJson<bool>(json['showRecordedVideo']),
      isDetailFetched: serializer.fromJson<bool>(json['isDetailFetched']),
      isScheduled: serializer.fromJson<bool>(json['isScheduled']),
      scheduledMessage: serializer.fromJson<String?>(json['scheduledMessage']),
      attemptsUrl: serializer.fromJson<String?>(json['attemptsUrl']),
      slug: serializer.fromJson<String?>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      examMetadataJson: serializer.fromJson<String?>(json['examMetadataJson']),
      enableTranscript: serializer.fromJson<bool>(json['enableTranscript']),
      videoSubtitleUrl: serializer.fromJson<String?>(json['videoSubtitleUrl']),
      isAiEnabled: serializer.fromJson<bool>(json['isAiEnabled']),
      aiNotesUrl: serializer.fromJson<String?>(json['aiNotesUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'courseId': serializer.toJson<String?>(courseId),
      'ancestorChapterIds': serializer.toJson<String?>(ancestorChapterIds),
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
      'bookmarkId': serializer.toJson<int?>(bookmarkId),
      'isRunning': serializer.toJson<bool>(isRunning),
      'isUpcoming': serializer.toJson<bool>(isUpcoming),
      'hasAttempts': serializer.toJson<bool>(hasAttempts),
      'image': serializer.toJson<String?>(image),
      'nextContentId': serializer.toJson<String?>(nextContentId),
      'previousContentId': serializer.toJson<String?>(previousContentId),
      'htmlContent': serializer.toJson<String?>(htmlContent),
      'chatEmbedUrl': serializer.toJson<String?>(chatEmbedUrl),
      'streamStatus': serializer.toJson<String?>(streamStatus),
      'showRecordedVideo': serializer.toJson<bool>(showRecordedVideo),
      'isDetailFetched': serializer.toJson<bool>(isDetailFetched),
      'isScheduled': serializer.toJson<bool>(isScheduled),
      'scheduledMessage': serializer.toJson<String?>(scheduledMessage),
      'attemptsUrl': serializer.toJson<String?>(attemptsUrl),
      'slug': serializer.toJson<String?>(slug),
      'description': serializer.toJson<String?>(description),
      'examMetadataJson': serializer.toJson<String?>(examMetadataJson),
      'enableTranscript': serializer.toJson<bool>(enableTranscript),
      'videoSubtitleUrl': serializer.toJson<String?>(videoSubtitleUrl),
      'isAiEnabled': serializer.toJson<bool>(isAiEnabled),
      'aiNotesUrl': serializer.toJson<String?>(aiNotesUrl),
    };
  }

  LessonsTableData copyWith({
    String? id,
    String? chapterId,
    Value<String?> courseId = const Value.absent(),
    Value<String?> ancestorChapterIds = const Value.absent(),
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
    Value<int?> bookmarkId = const Value.absent(),
    bool? isRunning,
    bool? isUpcoming,
    bool? hasAttempts,
    Value<String?> image = const Value.absent(),
    Value<String?> nextContentId = const Value.absent(),
    Value<String?> previousContentId = const Value.absent(),
    Value<String?> htmlContent = const Value.absent(),
    Value<String?> chatEmbedUrl = const Value.absent(),
    Value<String?> streamStatus = const Value.absent(),
    bool? showRecordedVideo,
    bool? isDetailFetched,
    bool? isScheduled,
    Value<String?> scheduledMessage = const Value.absent(),
    Value<String?> attemptsUrl = const Value.absent(),
    Value<String?> slug = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> examMetadataJson = const Value.absent(),
    bool? enableTranscript,
    Value<String?> videoSubtitleUrl = const Value.absent(),
    bool? isAiEnabled,
    Value<String?> aiNotesUrl = const Value.absent(),
  }) => LessonsTableData(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    courseId: courseId.present ? courseId.value : this.courseId,
    ancestorChapterIds: ancestorChapterIds.present
        ? ancestorChapterIds.value
        : this.ancestorChapterIds,
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
    bookmarkId: bookmarkId.present ? bookmarkId.value : this.bookmarkId,
    isRunning: isRunning ?? this.isRunning,
    isUpcoming: isUpcoming ?? this.isUpcoming,
    hasAttempts: hasAttempts ?? this.hasAttempts,
    image: image.present ? image.value : this.image,
    nextContentId: nextContentId.present
        ? nextContentId.value
        : this.nextContentId,
    previousContentId: previousContentId.present
        ? previousContentId.value
        : this.previousContentId,
    htmlContent: htmlContent.present ? htmlContent.value : this.htmlContent,
    chatEmbedUrl: chatEmbedUrl.present ? chatEmbedUrl.value : this.chatEmbedUrl,
    streamStatus: streamStatus.present ? streamStatus.value : this.streamStatus,
    showRecordedVideo: showRecordedVideo ?? this.showRecordedVideo,
    isDetailFetched: isDetailFetched ?? this.isDetailFetched,
    isScheduled: isScheduled ?? this.isScheduled,
    scheduledMessage: scheduledMessage.present
        ? scheduledMessage.value
        : this.scheduledMessage,
    attemptsUrl: attemptsUrl.present ? attemptsUrl.value : this.attemptsUrl,
    slug: slug.present ? slug.value : this.slug,
    description: description.present ? description.value : this.description,
    examMetadataJson: examMetadataJson.present
        ? examMetadataJson.value
        : this.examMetadataJson,
    enableTranscript: enableTranscript ?? this.enableTranscript,
    videoSubtitleUrl: videoSubtitleUrl.present
        ? videoSubtitleUrl.value
        : this.videoSubtitleUrl,
    isAiEnabled: isAiEnabled ?? this.isAiEnabled,
    aiNotesUrl: aiNotesUrl.present ? aiNotesUrl.value : this.aiNotesUrl,
  );
  LessonsTableData copyWithCompanion(LessonsTableCompanion data) {
    return LessonsTableData(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      ancestorChapterIds: data.ancestorChapterIds.present
          ? data.ancestorChapterIds.value
          : this.ancestorChapterIds,
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
      bookmarkId: data.bookmarkId.present
          ? data.bookmarkId.value
          : this.bookmarkId,
      isRunning: data.isRunning.present ? data.isRunning.value : this.isRunning,
      isUpcoming: data.isUpcoming.present
          ? data.isUpcoming.value
          : this.isUpcoming,
      hasAttempts: data.hasAttempts.present
          ? data.hasAttempts.value
          : this.hasAttempts,
      image: data.image.present ? data.image.value : this.image,
      nextContentId: data.nextContentId.present
          ? data.nextContentId.value
          : this.nextContentId,
      previousContentId: data.previousContentId.present
          ? data.previousContentId.value
          : this.previousContentId,
      htmlContent: data.htmlContent.present
          ? data.htmlContent.value
          : this.htmlContent,
      chatEmbedUrl: data.chatEmbedUrl.present
          ? data.chatEmbedUrl.value
          : this.chatEmbedUrl,
      streamStatus: data.streamStatus.present
          ? data.streamStatus.value
          : this.streamStatus,
      showRecordedVideo: data.showRecordedVideo.present
          ? data.showRecordedVideo.value
          : this.showRecordedVideo,
      isDetailFetched: data.isDetailFetched.present
          ? data.isDetailFetched.value
          : this.isDetailFetched,
      isScheduled: data.isScheduled.present
          ? data.isScheduled.value
          : this.isScheduled,
      scheduledMessage: data.scheduledMessage.present
          ? data.scheduledMessage.value
          : this.scheduledMessage,
      attemptsUrl: data.attemptsUrl.present
          ? data.attemptsUrl.value
          : this.attemptsUrl,
      slug: data.slug.present ? data.slug.value : this.slug,
      description: data.description.present
          ? data.description.value
          : this.description,
      examMetadataJson: data.examMetadataJson.present
          ? data.examMetadataJson.value
          : this.examMetadataJson,
      enableTranscript: data.enableTranscript.present
          ? data.enableTranscript.value
          : this.enableTranscript,
      videoSubtitleUrl: data.videoSubtitleUrl.present
          ? data.videoSubtitleUrl.value
          : this.videoSubtitleUrl,
      isAiEnabled: data.isAiEnabled.present
          ? data.isAiEnabled.value
          : this.isAiEnabled,
      aiNotesUrl: data.aiNotesUrl.present
          ? data.aiNotesUrl.value
          : this.aiNotesUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableData(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('courseId: $courseId, ')
          ..write('ancestorChapterIds: $ancestorChapterIds, ')
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
          ..write('bookmarkId: $bookmarkId, ')
          ..write('isRunning: $isRunning, ')
          ..write('isUpcoming: $isUpcoming, ')
          ..write('hasAttempts: $hasAttempts, ')
          ..write('image: $image, ')
          ..write('nextContentId: $nextContentId, ')
          ..write('previousContentId: $previousContentId, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('chatEmbedUrl: $chatEmbedUrl, ')
          ..write('streamStatus: $streamStatus, ')
          ..write('showRecordedVideo: $showRecordedVideo, ')
          ..write('isDetailFetched: $isDetailFetched, ')
          ..write('isScheduled: $isScheduled, ')
          ..write('scheduledMessage: $scheduledMessage, ')
          ..write('attemptsUrl: $attemptsUrl, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('examMetadataJson: $examMetadataJson, ')
          ..write('enableTranscript: $enableTranscript, ')
          ..write('videoSubtitleUrl: $videoSubtitleUrl, ')
          ..write('isAiEnabled: $isAiEnabled, ')
          ..write('aiNotesUrl: $aiNotesUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    chapterId,
    courseId,
    ancestorChapterIds,
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
    bookmarkId,
    isRunning,
    isUpcoming,
    hasAttempts,
    image,
    nextContentId,
    previousContentId,
    htmlContent,
    chatEmbedUrl,
    streamStatus,
    showRecordedVideo,
    isDetailFetched,
    isScheduled,
    scheduledMessage,
    attemptsUrl,
    slug,
    description,
    examMetadataJson,
    enableTranscript,
    videoSubtitleUrl,
    isAiEnabled,
    aiNotesUrl,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonsTableData &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.courseId == this.courseId &&
          other.ancestorChapterIds == this.ancestorChapterIds &&
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
          other.bookmarkId == this.bookmarkId &&
          other.isRunning == this.isRunning &&
          other.isUpcoming == this.isUpcoming &&
          other.hasAttempts == this.hasAttempts &&
          other.image == this.image &&
          other.nextContentId == this.nextContentId &&
          other.previousContentId == this.previousContentId &&
          other.htmlContent == this.htmlContent &&
          other.chatEmbedUrl == this.chatEmbedUrl &&
          other.streamStatus == this.streamStatus &&
          other.showRecordedVideo == this.showRecordedVideo &&
          other.isDetailFetched == this.isDetailFetched &&
          other.isScheduled == this.isScheduled &&
          other.scheduledMessage == this.scheduledMessage &&
          other.attemptsUrl == this.attemptsUrl &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.examMetadataJson == this.examMetadataJson &&
          other.enableTranscript == this.enableTranscript &&
          other.videoSubtitleUrl == this.videoSubtitleUrl &&
          other.isAiEnabled == this.isAiEnabled &&
          other.aiNotesUrl == this.aiNotesUrl);
}

class LessonsTableCompanion extends UpdateCompanion<LessonsTableData> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String?> courseId;
  final Value<String?> ancestorChapterIds;
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
  final Value<int?> bookmarkId;
  final Value<bool> isRunning;
  final Value<bool> isUpcoming;
  final Value<bool> hasAttempts;
  final Value<String?> image;
  final Value<String?> nextContentId;
  final Value<String?> previousContentId;
  final Value<String?> htmlContent;
  final Value<String?> chatEmbedUrl;
  final Value<String?> streamStatus;
  final Value<bool> showRecordedVideo;
  final Value<bool> isDetailFetched;
  final Value<bool> isScheduled;
  final Value<String?> scheduledMessage;
  final Value<String?> attemptsUrl;
  final Value<String?> slug;
  final Value<String?> description;
  final Value<String?> examMetadataJson;
  final Value<bool> enableTranscript;
  final Value<String?> videoSubtitleUrl;
  final Value<bool> isAiEnabled;
  final Value<String?> aiNotesUrl;
  final Value<int> rowid;
  const LessonsTableCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.courseId = const Value.absent(),
    this.ancestorChapterIds = const Value.absent(),
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
    this.bookmarkId = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.isUpcoming = const Value.absent(),
    this.hasAttempts = const Value.absent(),
    this.image = const Value.absent(),
    this.nextContentId = const Value.absent(),
    this.previousContentId = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.chatEmbedUrl = const Value.absent(),
    this.streamStatus = const Value.absent(),
    this.showRecordedVideo = const Value.absent(),
    this.isDetailFetched = const Value.absent(),
    this.isScheduled = const Value.absent(),
    this.scheduledMessage = const Value.absent(),
    this.attemptsUrl = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.examMetadataJson = const Value.absent(),
    this.enableTranscript = const Value.absent(),
    this.videoSubtitleUrl = const Value.absent(),
    this.isAiEnabled = const Value.absent(),
    this.aiNotesUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsTableCompanion.insert({
    required String id,
    required String chapterId,
    this.courseId = const Value.absent(),
    this.ancestorChapterIds = const Value.absent(),
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
    this.bookmarkId = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.isUpcoming = const Value.absent(),
    this.hasAttempts = const Value.absent(),
    this.image = const Value.absent(),
    this.nextContentId = const Value.absent(),
    this.previousContentId = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.chatEmbedUrl = const Value.absent(),
    this.streamStatus = const Value.absent(),
    this.showRecordedVideo = const Value.absent(),
    this.isDetailFetched = const Value.absent(),
    this.isScheduled = const Value.absent(),
    this.scheduledMessage = const Value.absent(),
    this.attemptsUrl = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.examMetadataJson = const Value.absent(),
    this.enableTranscript = const Value.absent(),
    this.videoSubtitleUrl = const Value.absent(),
    this.isAiEnabled = const Value.absent(),
    this.aiNotesUrl = const Value.absent(),
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
    Expression<String>? courseId,
    Expression<String>? ancestorChapterIds,
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
    Expression<int>? bookmarkId,
    Expression<bool>? isRunning,
    Expression<bool>? isUpcoming,
    Expression<bool>? hasAttempts,
    Expression<String>? image,
    Expression<String>? nextContentId,
    Expression<String>? previousContentId,
    Expression<String>? htmlContent,
    Expression<String>? chatEmbedUrl,
    Expression<String>? streamStatus,
    Expression<bool>? showRecordedVideo,
    Expression<bool>? isDetailFetched,
    Expression<bool>? isScheduled,
    Expression<String>? scheduledMessage,
    Expression<String>? attemptsUrl,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? examMetadataJson,
    Expression<bool>? enableTranscript,
    Expression<String>? videoSubtitleUrl,
    Expression<bool>? isAiEnabled,
    Expression<String>? aiNotesUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (courseId != null) 'course_id': courseId,
      if (ancestorChapterIds != null)
        'ancestor_chapter_ids': ancestorChapterIds,
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
      if (bookmarkId != null) 'bookmark_id': bookmarkId,
      if (isRunning != null) 'is_running': isRunning,
      if (isUpcoming != null) 'is_upcoming': isUpcoming,
      if (hasAttempts != null) 'has_attempts': hasAttempts,
      if (image != null) 'image': image,
      if (nextContentId != null) 'next_content_id': nextContentId,
      if (previousContentId != null) 'previous_content_id': previousContentId,
      if (htmlContent != null) 'html_content': htmlContent,
      if (chatEmbedUrl != null) 'chat_embed_url': chatEmbedUrl,
      if (streamStatus != null) 'stream_status': streamStatus,
      if (showRecordedVideo != null) 'show_recorded_video': showRecordedVideo,
      if (isDetailFetched != null) 'is_detail_fetched': isDetailFetched,
      if (isScheduled != null) 'is_scheduled': isScheduled,
      if (scheduledMessage != null) 'scheduled_message': scheduledMessage,
      if (attemptsUrl != null) 'attempts_url': attemptsUrl,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (examMetadataJson != null) 'exam_metadata_json': examMetadataJson,
      if (enableTranscript != null) 'enable_transcript': enableTranscript,
      if (videoSubtitleUrl != null) 'video_subtitle_url': videoSubtitleUrl,
      if (isAiEnabled != null) 'is_ai_enabled': isAiEnabled,
      if (aiNotesUrl != null) 'ai_notes_url': aiNotesUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String?>? courseId,
    Value<String?>? ancestorChapterIds,
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
    Value<int?>? bookmarkId,
    Value<bool>? isRunning,
    Value<bool>? isUpcoming,
    Value<bool>? hasAttempts,
    Value<String?>? image,
    Value<String?>? nextContentId,
    Value<String?>? previousContentId,
    Value<String?>? htmlContent,
    Value<String?>? chatEmbedUrl,
    Value<String?>? streamStatus,
    Value<bool>? showRecordedVideo,
    Value<bool>? isDetailFetched,
    Value<bool>? isScheduled,
    Value<String?>? scheduledMessage,
    Value<String?>? attemptsUrl,
    Value<String?>? slug,
    Value<String?>? description,
    Value<String?>? examMetadataJson,
    Value<bool>? enableTranscript,
    Value<String?>? videoSubtitleUrl,
    Value<bool>? isAiEnabled,
    Value<String?>? aiNotesUrl,
    Value<int>? rowid,
  }) {
    return LessonsTableCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      courseId: courseId ?? this.courseId,
      ancestorChapterIds: ancestorChapterIds ?? this.ancestorChapterIds,
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
      bookmarkId: bookmarkId ?? this.bookmarkId,
      isRunning: isRunning ?? this.isRunning,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      hasAttempts: hasAttempts ?? this.hasAttempts,
      image: image ?? this.image,
      nextContentId: nextContentId ?? this.nextContentId,
      previousContentId: previousContentId ?? this.previousContentId,
      htmlContent: htmlContent ?? this.htmlContent,
      chatEmbedUrl: chatEmbedUrl ?? this.chatEmbedUrl,
      streamStatus: streamStatus ?? this.streamStatus,
      showRecordedVideo: showRecordedVideo ?? this.showRecordedVideo,
      isDetailFetched: isDetailFetched ?? this.isDetailFetched,
      isScheduled: isScheduled ?? this.isScheduled,
      scheduledMessage: scheduledMessage ?? this.scheduledMessage,
      attemptsUrl: attemptsUrl ?? this.attemptsUrl,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      examMetadataJson: examMetadataJson ?? this.examMetadataJson,
      enableTranscript: enableTranscript ?? this.enableTranscript,
      videoSubtitleUrl: videoSubtitleUrl ?? this.videoSubtitleUrl,
      isAiEnabled: isAiEnabled ?? this.isAiEnabled,
      aiNotesUrl: aiNotesUrl ?? this.aiNotesUrl,
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
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (ancestorChapterIds.present) {
      map['ancestor_chapter_ids'] = Variable<String>(ancestorChapterIds.value);
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
    if (bookmarkId.present) {
      map['bookmark_id'] = Variable<int>(bookmarkId.value);
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
    if (nextContentId.present) {
      map['next_content_id'] = Variable<String>(nextContentId.value);
    }
    if (previousContentId.present) {
      map['previous_content_id'] = Variable<String>(previousContentId.value);
    }
    if (htmlContent.present) {
      map['html_content'] = Variable<String>(htmlContent.value);
    }
    if (chatEmbedUrl.present) {
      map['chat_embed_url'] = Variable<String>(chatEmbedUrl.value);
    }
    if (streamStatus.present) {
      map['stream_status'] = Variable<String>(streamStatus.value);
    }
    if (showRecordedVideo.present) {
      map['show_recorded_video'] = Variable<bool>(showRecordedVideo.value);
    }
    if (isDetailFetched.present) {
      map['is_detail_fetched'] = Variable<bool>(isDetailFetched.value);
    }
    if (isScheduled.present) {
      map['is_scheduled'] = Variable<bool>(isScheduled.value);
    }
    if (scheduledMessage.present) {
      map['scheduled_message'] = Variable<String>(scheduledMessage.value);
    }
    if (attemptsUrl.present) {
      map['attempts_url'] = Variable<String>(attemptsUrl.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (examMetadataJson.present) {
      map['exam_metadata_json'] = Variable<String>(examMetadataJson.value);
    }
    if (enableTranscript.present) {
      map['enable_transcript'] = Variable<bool>(enableTranscript.value);
    }
    if (videoSubtitleUrl.present) {
      map['video_subtitle_url'] = Variable<String>(videoSubtitleUrl.value);
    }
    if (isAiEnabled.present) {
      map['is_ai_enabled'] = Variable<bool>(isAiEnabled.value);
    }
    if (aiNotesUrl.present) {
      map['ai_notes_url'] = Variable<String>(aiNotesUrl.value);
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
          ..write('courseId: $courseId, ')
          ..write('ancestorChapterIds: $ancestorChapterIds, ')
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
          ..write('bookmarkId: $bookmarkId, ')
          ..write('isRunning: $isRunning, ')
          ..write('isUpcoming: $isUpcoming, ')
          ..write('hasAttempts: $hasAttempts, ')
          ..write('image: $image, ')
          ..write('nextContentId: $nextContentId, ')
          ..write('previousContentId: $previousContentId, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('chatEmbedUrl: $chatEmbedUrl, ')
          ..write('streamStatus: $streamStatus, ')
          ..write('showRecordedVideo: $showRecordedVideo, ')
          ..write('isDetailFetched: $isDetailFetched, ')
          ..write('isScheduled: $isScheduled, ')
          ..write('scheduledMessage: $scheduledMessage, ')
          ..write('attemptsUrl: $attemptsUrl, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('examMetadataJson: $examMetadataJson, ')
          ..write('enableTranscript: $enableTranscript, ')
          ..write('videoSubtitleUrl: $videoSubtitleUrl, ')
          ..write('isAiEnabled: $isAiEnabled, ')
          ..write('aiNotesUrl: $aiNotesUrl, ')
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
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
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<int> threadId = GeneratedColumn<int>(
    'thread_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _categorySlugMeta = const VerificationMeta(
    'categorySlug',
  );
  @override
  late final GeneratedColumn<String> categorySlug = GeneratedColumn<String>(
    'category_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentHtmlMeta = const VerificationMeta(
    'contentHtml',
  );
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
    'content_html',
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
    createdAt,
    replyCount,
    upvotes,
    downvotes,
    threadId,
    status,
    imageUrl,
    categorySlug,
    contentHtml,
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
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
    if (data.containsKey('category_slug')) {
      context.handle(
        _categorySlugMeta,
        categorySlug.isAcceptableOrUnknown(
          data['category_slug']!,
          _categorySlugMeta,
        ),
      );
    }
    if (data.containsKey('content_html')) {
      context.handle(
        _contentHtmlMeta,
        contentHtml.isAcceptableOrUnknown(
          data['content_html']!,
          _contentHtmlMeta,
        ),
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
      ),
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
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
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}thread_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      categorySlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_slug'],
      ),
      contentHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_html'],
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
  final String? courseId;
  final String title;
  final String description;
  final String authorName;
  final String? authorAvatar;
  final String createdAt;
  final int replyCount;
  final int upvotes;
  final int downvotes;

  /// Stored as string: 'answered' | 'unanswered'
  final int? threadId;

  /// Stored as string: 'answered' | 'unanswered'
  final String status;
  final String? imageUrl;
  final String? categorySlug;
  final String? contentHtml;
  const ForumThreadsTableData({
    required this.id,
    this.courseId,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    required this.replyCount,
    required this.upvotes,
    required this.downvotes,
    this.threadId,
    required this.status,
    this.imageUrl,
    this.categorySlug,
    this.contentHtml,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || courseId != null) {
      map['course_id'] = Variable<String>(courseId);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['reply_count'] = Variable<int>(replyCount);
    map['upvotes'] = Variable<int>(upvotes);
    map['downvotes'] = Variable<int>(downvotes);
    if (!nullToAbsent || threadId != null) {
      map['thread_id'] = Variable<int>(threadId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || categorySlug != null) {
      map['category_slug'] = Variable<String>(categorySlug);
    }
    if (!nullToAbsent || contentHtml != null) {
      map['content_html'] = Variable<String>(contentHtml);
    }
    return map;
  }

  ForumThreadsTableCompanion toCompanion(bool nullToAbsent) {
    return ForumThreadsTableCompanion(
      id: Value(id),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      title: Value(title),
      description: Value(description),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      createdAt: Value(createdAt),
      replyCount: Value(replyCount),
      upvotes: Value(upvotes),
      downvotes: Value(downvotes),
      threadId: threadId == null && nullToAbsent
          ? const Value.absent()
          : Value(threadId),
      status: Value(status),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      categorySlug: categorySlug == null && nullToAbsent
          ? const Value.absent()
          : Value(categorySlug),
      contentHtml: contentHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHtml),
    );
  }

  factory ForumThreadsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForumThreadsTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String?>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      upvotes: serializer.fromJson<int>(json['upvotes']),
      downvotes: serializer.fromJson<int>(json['downvotes']),
      threadId: serializer.fromJson<int?>(json['threadId']),
      status: serializer.fromJson<String>(json['status']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      categorySlug: serializer.fromJson<String?>(json['categorySlug']),
      contentHtml: serializer.fromJson<String?>(json['contentHtml']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String?>(courseId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'createdAt': serializer.toJson<String>(createdAt),
      'replyCount': serializer.toJson<int>(replyCount),
      'upvotes': serializer.toJson<int>(upvotes),
      'downvotes': serializer.toJson<int>(downvotes),
      'threadId': serializer.toJson<int?>(threadId),
      'status': serializer.toJson<String>(status),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'categorySlug': serializer.toJson<String?>(categorySlug),
      'contentHtml': serializer.toJson<String?>(contentHtml),
    };
  }

  ForumThreadsTableData copyWith({
    String? id,
    Value<String?> courseId = const Value.absent(),
    String? title,
    String? description,
    String? authorName,
    Value<String?> authorAvatar = const Value.absent(),
    String? createdAt,
    int? replyCount,
    int? upvotes,
    int? downvotes,
    Value<int?> threadId = const Value.absent(),
    String? status,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> categorySlug = const Value.absent(),
    Value<String?> contentHtml = const Value.absent(),
  }) => ForumThreadsTableData(
    id: id ?? this.id,
    courseId: courseId.present ? courseId.value : this.courseId,
    title: title ?? this.title,
    description: description ?? this.description,
    authorName: authorName ?? this.authorName,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    createdAt: createdAt ?? this.createdAt,
    replyCount: replyCount ?? this.replyCount,
    upvotes: upvotes ?? this.upvotes,
    downvotes: downvotes ?? this.downvotes,
    threadId: threadId.present ? threadId.value : this.threadId,
    status: status ?? this.status,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    categorySlug: categorySlug.present ? categorySlug.value : this.categorySlug,
    contentHtml: contentHtml.present ? contentHtml.value : this.contentHtml,
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
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      replyCount: data.replyCount.present
          ? data.replyCount.value
          : this.replyCount,
      upvotes: data.upvotes.present ? data.upvotes.value : this.upvotes,
      downvotes: data.downvotes.present ? data.downvotes.value : this.downvotes,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      status: data.status.present ? data.status.value : this.status,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      categorySlug: data.categorySlug.present
          ? data.categorySlug.value
          : this.categorySlug,
      contentHtml: data.contentHtml.present
          ? data.contentHtml.value
          : this.contentHtml,
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
          ..write('createdAt: $createdAt, ')
          ..write('replyCount: $replyCount, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('threadId: $threadId, ')
          ..write('status: $status, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('contentHtml: $contentHtml')
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
    createdAt,
    replyCount,
    upvotes,
    downvotes,
    threadId,
    status,
    imageUrl,
    categorySlug,
    contentHtml,
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
          other.createdAt == this.createdAt &&
          other.replyCount == this.replyCount &&
          other.upvotes == this.upvotes &&
          other.downvotes == this.downvotes &&
          other.threadId == this.threadId &&
          other.status == this.status &&
          other.imageUrl == this.imageUrl &&
          other.categorySlug == this.categorySlug &&
          other.contentHtml == this.contentHtml);
}

class ForumThreadsTableCompanion
    extends UpdateCompanion<ForumThreadsTableData> {
  final Value<String> id;
  final Value<String?> courseId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> createdAt;
  final Value<int> replyCount;
  final Value<int> upvotes;
  final Value<int> downvotes;
  final Value<int?> threadId;
  final Value<String> status;
  final Value<String?> imageUrl;
  final Value<String?> categorySlug;
  final Value<String?> contentHtml;
  final Value<int> rowid;
  const ForumThreadsTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.threadId = const Value.absent(),
    this.status = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.categorySlug = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForumThreadsTableCompanion.insert({
    required String id,
    this.courseId = const Value.absent(),
    required String title,
    required String description,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String createdAt,
    this.replyCount = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.threadId = const Value.absent(),
    required String status,
    this.imageUrl = const Value.absent(),
    this.categorySlug = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       authorName = Value(authorName),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<ForumThreadsTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? createdAt,
    Expression<int>? replyCount,
    Expression<int>? upvotes,
    Expression<int>? downvotes,
    Expression<int>? threadId,
    Expression<String>? status,
    Expression<String>? imageUrl,
    Expression<String>? categorySlug,
    Expression<String>? contentHtml,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (createdAt != null) 'created_at': createdAt,
      if (replyCount != null) 'reply_count': replyCount,
      if (upvotes != null) 'upvotes': upvotes,
      if (downvotes != null) 'downvotes': downvotes,
      if (threadId != null) 'thread_id': threadId,
      if (status != null) 'status': status,
      if (imageUrl != null) 'image_url': imageUrl,
      if (categorySlug != null) 'category_slug': categorySlug,
      if (contentHtml != null) 'content_html': contentHtml,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForumThreadsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? courseId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? authorName,
    Value<String?>? authorAvatar,
    Value<String>? createdAt,
    Value<int>? replyCount,
    Value<int>? upvotes,
    Value<int>? downvotes,
    Value<int?>? threadId,
    Value<String>? status,
    Value<String?>? imageUrl,
    Value<String?>? categorySlug,
    Value<String?>? contentHtml,
    Value<int>? rowid,
  }) {
    return ForumThreadsTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      replyCount: replyCount ?? this.replyCount,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      threadId: threadId ?? this.threadId,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      categorySlug: categorySlug ?? this.categorySlug,
      contentHtml: contentHtml ?? this.contentHtml,
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
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
    if (threadId.present) {
      map['thread_id'] = Variable<int>(threadId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (categorySlug.present) {
      map['category_slug'] = Variable<String>(categorySlug.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('replyCount: $replyCount, ')
          ..write('upvotes: $upvotes, ')
          ..write('downvotes: $downvotes, ')
          ..write('threadId: $threadId, ')
          ..write('status: $status, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('categorySlug: $categorySlug, ')
          ..write('contentHtml: $contentHtml, ')
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
  late final GeneratedColumn<int> threadId = GeneratedColumn<int>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
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
    createdAt,
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
        DriftSqlType.int,
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
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
  final int threadId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String createdAt;
  final int upvotes;
  final int downvotes;
  final bool isInstructor;
  const ForumCommentsTableData({
    required this.id,
    required this.threadId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.isInstructor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<int>(threadId);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<String>(createdAt);
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
      createdAt: Value(createdAt),
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
      threadId: serializer.fromJson<int>(json['threadId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
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
      'threadId': serializer.toJson<int>(threadId),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<String>(createdAt),
      'upvotes': serializer.toJson<int>(upvotes),
      'downvotes': serializer.toJson<int>(downvotes),
      'isInstructor': serializer.toJson<bool>(isInstructor),
    };
  }

  ForumCommentsTableData copyWith({
    String? id,
    int? threadId,
    String? authorName,
    Value<String?> authorAvatar = const Value.absent(),
    String? content,
    String? createdAt,
    int? upvotes,
    int? downvotes,
    bool? isInstructor,
  }) => ForumCommentsTableData(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    authorName: authorName ?? this.authorName,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
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
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('createdAt: $createdAt, ')
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
    createdAt,
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
          other.createdAt == this.createdAt &&
          other.upvotes == this.upvotes &&
          other.downvotes == this.downvotes &&
          other.isInstructor == this.isInstructor);
}

class ForumCommentsTableCompanion
    extends UpdateCompanion<ForumCommentsTableData> {
  final Value<String> id;
  final Value<int> threadId;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> content;
  final Value<String> createdAt;
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
    this.createdAt = const Value.absent(),
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.isInstructor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForumCommentsTableCompanion.insert({
    required String id,
    required int threadId,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String content,
    required String createdAt,
    this.upvotes = const Value.absent(),
    this.downvotes = const Value.absent(),
    this.isInstructor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       authorName = Value(authorName),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ForumCommentsTableData> custom({
    Expression<String>? id,
    Expression<int>? threadId,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? content,
    Expression<String>? createdAt,
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
      if (createdAt != null) 'created_at': createdAt,
      if (upvotes != null) 'upvotes': upvotes,
      if (downvotes != null) 'downvotes': downvotes,
      if (isInstructor != null) 'is_instructor': isInstructor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForumCommentsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? threadId,
    Value<String>? authorName,
    Value<String?>? authorAvatar,
    Value<String>? content,
    Value<String>? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
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
      map['thread_id'] = Variable<int>(threadId.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
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
          ..write('createdAt: $createdAt, ')
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

class $DashboardBannersTableTable extends DashboardBannersTable
    with TableInfo<$DashboardBannersTableTable, DashboardBannersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardBannersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bgColorMeta = const VerificationMeta(
    'bgColor',
  );
  @override
  late final GeneratedColumn<int> bgColor = GeneratedColumn<int>(
    'bg_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textColorMeta = const VerificationMeta(
    'textColor',
  );
  @override
  late final GeneratedColumn<int> textColor = GeneratedColumn<int>(
    'text_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imageUrl,
    title,
    link,
    description,
    bgColor,
    textColor,
    tag,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_banners_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashboardBannersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('bg_color')) {
      context.handle(
        _bgColorMeta,
        bgColor.isAcceptableOrUnknown(data['bg_color']!, _bgColorMeta),
      );
    }
    if (data.containsKey('text_color')) {
      context.handle(
        _textColorMeta,
        textColor.isAcceptableOrUnknown(data['text_color']!, _textColorMeta),
      );
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DashboardBannersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardBannersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      bgColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bg_color'],
      ),
      textColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}text_color'],
      ),
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      ),
    );
  }

  @override
  $DashboardBannersTableTable createAlias(String alias) {
    return $DashboardBannersTableTable(attachedDatabase, alias);
  }
}

class DashboardBannersTableData extends DataClass
    implements Insertable<DashboardBannersTableData> {
  final String id;
  final String imageUrl;
  final String? title;
  final String? link;
  final String? description;
  final int? bgColor;
  final int? textColor;
  final String? tag;
  const DashboardBannersTableData({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    this.description,
    this.bgColor,
    this.textColor,
    this.tag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['image_url'] = Variable<String>(imageUrl);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || bgColor != null) {
      map['bg_color'] = Variable<int>(bgColor);
    }
    if (!nullToAbsent || textColor != null) {
      map['text_color'] = Variable<int>(textColor);
    }
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    return map;
  }

  DashboardBannersTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardBannersTableCompanion(
      id: Value(id),
      imageUrl: Value(imageUrl),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      bgColor: bgColor == null && nullToAbsent
          ? const Value.absent()
          : Value(bgColor),
      textColor: textColor == null && nullToAbsent
          ? const Value.absent()
          : Value(textColor),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
    );
  }

  factory DashboardBannersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardBannersTableData(
      id: serializer.fromJson<String>(json['id']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      title: serializer.fromJson<String?>(json['title']),
      link: serializer.fromJson<String?>(json['link']),
      description: serializer.fromJson<String?>(json['description']),
      bgColor: serializer.fromJson<int?>(json['bgColor']),
      textColor: serializer.fromJson<int?>(json['textColor']),
      tag: serializer.fromJson<String?>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'title': serializer.toJson<String?>(title),
      'link': serializer.toJson<String?>(link),
      'description': serializer.toJson<String?>(description),
      'bgColor': serializer.toJson<int?>(bgColor),
      'textColor': serializer.toJson<int?>(textColor),
      'tag': serializer.toJson<String?>(tag),
    };
  }

  DashboardBannersTableData copyWith({
    String? id,
    String? imageUrl,
    Value<String?> title = const Value.absent(),
    Value<String?> link = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<int?> bgColor = const Value.absent(),
    Value<int?> textColor = const Value.absent(),
    Value<String?> tag = const Value.absent(),
  }) => DashboardBannersTableData(
    id: id ?? this.id,
    imageUrl: imageUrl ?? this.imageUrl,
    title: title.present ? title.value : this.title,
    link: link.present ? link.value : this.link,
    description: description.present ? description.value : this.description,
    bgColor: bgColor.present ? bgColor.value : this.bgColor,
    textColor: textColor.present ? textColor.value : this.textColor,
    tag: tag.present ? tag.value : this.tag,
  );
  DashboardBannersTableData copyWithCompanion(
    DashboardBannersTableCompanion data,
  ) {
    return DashboardBannersTableData(
      id: data.id.present ? data.id.value : this.id,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      title: data.title.present ? data.title.value : this.title,
      link: data.link.present ? data.link.value : this.link,
      description: data.description.present
          ? data.description.value
          : this.description,
      bgColor: data.bgColor.present ? data.bgColor.value : this.bgColor,
      textColor: data.textColor.present ? data.textColor.value : this.textColor,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardBannersTableData(')
          ..write('id: $id, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('description: $description, ')
          ..write('bgColor: $bgColor, ')
          ..write('textColor: $textColor, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    imageUrl,
    title,
    link,
    description,
    bgColor,
    textColor,
    tag,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardBannersTableData &&
          other.id == this.id &&
          other.imageUrl == this.imageUrl &&
          other.title == this.title &&
          other.link == this.link &&
          other.description == this.description &&
          other.bgColor == this.bgColor &&
          other.textColor == this.textColor &&
          other.tag == this.tag);
}

class DashboardBannersTableCompanion
    extends UpdateCompanion<DashboardBannersTableData> {
  final Value<String> id;
  final Value<String> imageUrl;
  final Value<String?> title;
  final Value<String?> link;
  final Value<String?> description;
  final Value<int?> bgColor;
  final Value<int?> textColor;
  final Value<String?> tag;
  final Value<int> rowid;
  const DashboardBannersTableCompanion({
    this.id = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.description = const Value.absent(),
    this.bgColor = const Value.absent(),
    this.textColor = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardBannersTableCompanion.insert({
    required String id,
    required String imageUrl,
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.description = const Value.absent(),
    this.bgColor = const Value.absent(),
    this.textColor = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       imageUrl = Value(imageUrl);
  static Insertable<DashboardBannersTableData> custom({
    Expression<String>? id,
    Expression<String>? imageUrl,
    Expression<String>? title,
    Expression<String>? link,
    Expression<String>? description,
    Expression<int>? bgColor,
    Expression<int>? textColor,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imageUrl != null) 'image_url': imageUrl,
      if (title != null) 'title': title,
      if (link != null) 'link': link,
      if (description != null) 'description': description,
      if (bgColor != null) 'bg_color': bgColor,
      if (textColor != null) 'text_color': textColor,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardBannersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? imageUrl,
    Value<String?>? title,
    Value<String?>? link,
    Value<String?>? description,
    Value<int?>? bgColor,
    Value<int?>? textColor,
    Value<String?>? tag,
    Value<int>? rowid,
  }) {
    return DashboardBannersTableCompanion(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      bgColor: bgColor ?? this.bgColor,
      textColor: textColor ?? this.textColor,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bgColor.present) {
      map['bg_color'] = Variable<int>(bgColor.value);
    }
    if (textColor.present) {
      map['text_color'] = Variable<int>(textColor.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardBannersTableCompanion(')
          ..write('id: $id, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('description: $description, ')
          ..write('bgColor: $bgColor, ')
          ..write('textColor: $textColor, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyLeaderboardTableTable extends WeeklyLeaderboardTable
    with TableInfo<$WeeklyLeaderboardTableTable, WeeklyLeaderboardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyLeaderboardTableTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<double> points = GeneratedColumn<double>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coursesCompletedMeta = const VerificationMeta(
    'coursesCompleted',
  );
  @override
  late final GeneratedColumn<int> coursesCompleted = GeneratedColumn<int>(
    'courses_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_leaderboard';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyLeaderboardData> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('courses_completed')) {
      context.handle(
        _coursesCompletedMeta,
        coursesCompleted.isAcceptableOrUnknown(
          data['courses_completed']!,
          _coursesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyLeaderboardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyLeaderboardData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}points'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      coursesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}courses_completed'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
    );
  }

  @override
  $WeeklyLeaderboardTableTable createAlias(String alias) {
    return $WeeklyLeaderboardTableTable(attachedDatabase, alias);
  }
}

class WeeklyLeaderboardData extends DataClass
    implements Insertable<WeeklyLeaderboardData> {
  final String id;
  final String name;
  final String? avatar;
  final double points;
  final int rank;
  final int coursesCompleted;
  final int streakDays;
  final int page;
  const WeeklyLeaderboardData({
    required this.id,
    required this.name,
    this.avatar,
    required this.points,
    required this.rank,
    required this.coursesCompleted,
    required this.streakDays,
    required this.page,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['points'] = Variable<double>(points);
    map['rank'] = Variable<int>(rank);
    map['courses_completed'] = Variable<int>(coursesCompleted);
    map['streak_days'] = Variable<int>(streakDays);
    map['page'] = Variable<int>(page);
    return map;
  }

  WeeklyLeaderboardTableCompanion toCompanion(bool nullToAbsent) {
    return WeeklyLeaderboardTableCompanion(
      id: Value(id),
      name: Value(name),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      points: Value(points),
      rank: Value(rank),
      coursesCompleted: Value(coursesCompleted),
      streakDays: Value(streakDays),
      page: Value(page),
    );
  }

  factory WeeklyLeaderboardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyLeaderboardData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      points: serializer.fromJson<double>(json['points']),
      rank: serializer.fromJson<int>(json['rank']),
      coursesCompleted: serializer.fromJson<int>(json['coursesCompleted']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      page: serializer.fromJson<int>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'points': serializer.toJson<double>(points),
      'rank': serializer.toJson<int>(rank),
      'coursesCompleted': serializer.toJson<int>(coursesCompleted),
      'streakDays': serializer.toJson<int>(streakDays),
      'page': serializer.toJson<int>(page),
    };
  }

  WeeklyLeaderboardData copyWith({
    String? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    double? points,
    int? rank,
    int? coursesCompleted,
    int? streakDays,
    int? page,
  }) => WeeklyLeaderboardData(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar.present ? avatar.value : this.avatar,
    points: points ?? this.points,
    rank: rank ?? this.rank,
    coursesCompleted: coursesCompleted ?? this.coursesCompleted,
    streakDays: streakDays ?? this.streakDays,
    page: page ?? this.page,
  );
  WeeklyLeaderboardData copyWithCompanion(
    WeeklyLeaderboardTableCompanion data,
  ) {
    return WeeklyLeaderboardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      points: data.points.present ? data.points.value : this.points,
      rank: data.rank.present ? data.rank.value : this.rank,
      coursesCompleted: data.coursesCompleted.present
          ? data.coursesCompleted.value
          : this.coursesCompleted,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyLeaderboardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyLeaderboardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.points == this.points &&
          other.rank == this.rank &&
          other.coursesCompleted == this.coursesCompleted &&
          other.streakDays == this.streakDays &&
          other.page == this.page);
}

class WeeklyLeaderboardTableCompanion
    extends UpdateCompanion<WeeklyLeaderboardData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<double> points;
  final Value<int> rank;
  final Value<int> coursesCompleted;
  final Value<int> streakDays;
  final Value<int> page;
  final Value<int> rowid;
  const WeeklyLeaderboardTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.points = const Value.absent(),
    this.rank = const Value.absent(),
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyLeaderboardTableCompanion.insert({
    required String id,
    required String name,
    this.avatar = const Value.absent(),
    required double points,
    required int rank,
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       points = Value(points),
       rank = Value(rank);
  static Insertable<WeeklyLeaderboardData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<double>? points,
    Expression<int>? rank,
    Expression<int>? coursesCompleted,
    Expression<int>? streakDays,
    Expression<int>? page,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (points != null) 'points': points,
      if (rank != null) 'rank': rank,
      if (coursesCompleted != null) 'courses_completed': coursesCompleted,
      if (streakDays != null) 'streak_days': streakDays,
      if (page != null) 'page': page,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyLeaderboardTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<double>? points,
    Value<int>? rank,
    Value<int>? coursesCompleted,
    Value<int>? streakDays,
    Value<int>? page,
    Value<int>? rowid,
  }) {
    return WeeklyLeaderboardTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      streakDays: streakDays ?? this.streakDays,
      page: page ?? this.page,
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
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (points.present) {
      map['points'] = Variable<double>(points.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (coursesCompleted.present) {
      map['courses_completed'] = Variable<int>(coursesCompleted.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyLeaderboardTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthlyLeaderboardTableTable extends MonthlyLeaderboardTable
    with TableInfo<$MonthlyLeaderboardTableTable, MonthlyLeaderboardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyLeaderboardTableTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<double> points = GeneratedColumn<double>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coursesCompletedMeta = const VerificationMeta(
    'coursesCompleted',
  );
  @override
  late final GeneratedColumn<int> coursesCompleted = GeneratedColumn<int>(
    'courses_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_leaderboard';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyLeaderboardData> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('courses_completed')) {
      context.handle(
        _coursesCompletedMeta,
        coursesCompleted.isAcceptableOrUnknown(
          data['courses_completed']!,
          _coursesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyLeaderboardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyLeaderboardData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}points'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      coursesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}courses_completed'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
    );
  }

  @override
  $MonthlyLeaderboardTableTable createAlias(String alias) {
    return $MonthlyLeaderboardTableTable(attachedDatabase, alias);
  }
}

class MonthlyLeaderboardData extends DataClass
    implements Insertable<MonthlyLeaderboardData> {
  final String id;
  final String name;
  final String? avatar;
  final double points;
  final int rank;
  final int coursesCompleted;
  final int streakDays;
  final int page;
  const MonthlyLeaderboardData({
    required this.id,
    required this.name,
    this.avatar,
    required this.points,
    required this.rank,
    required this.coursesCompleted,
    required this.streakDays,
    required this.page,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['points'] = Variable<double>(points);
    map['rank'] = Variable<int>(rank);
    map['courses_completed'] = Variable<int>(coursesCompleted);
    map['streak_days'] = Variable<int>(streakDays);
    map['page'] = Variable<int>(page);
    return map;
  }

  MonthlyLeaderboardTableCompanion toCompanion(bool nullToAbsent) {
    return MonthlyLeaderboardTableCompanion(
      id: Value(id),
      name: Value(name),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      points: Value(points),
      rank: Value(rank),
      coursesCompleted: Value(coursesCompleted),
      streakDays: Value(streakDays),
      page: Value(page),
    );
  }

  factory MonthlyLeaderboardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyLeaderboardData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      points: serializer.fromJson<double>(json['points']),
      rank: serializer.fromJson<int>(json['rank']),
      coursesCompleted: serializer.fromJson<int>(json['coursesCompleted']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      page: serializer.fromJson<int>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'points': serializer.toJson<double>(points),
      'rank': serializer.toJson<int>(rank),
      'coursesCompleted': serializer.toJson<int>(coursesCompleted),
      'streakDays': serializer.toJson<int>(streakDays),
      'page': serializer.toJson<int>(page),
    };
  }

  MonthlyLeaderboardData copyWith({
    String? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    double? points,
    int? rank,
    int? coursesCompleted,
    int? streakDays,
    int? page,
  }) => MonthlyLeaderboardData(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar.present ? avatar.value : this.avatar,
    points: points ?? this.points,
    rank: rank ?? this.rank,
    coursesCompleted: coursesCompleted ?? this.coursesCompleted,
    streakDays: streakDays ?? this.streakDays,
    page: page ?? this.page,
  );
  MonthlyLeaderboardData copyWithCompanion(
    MonthlyLeaderboardTableCompanion data,
  ) {
    return MonthlyLeaderboardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      points: data.points.present ? data.points.value : this.points,
      rank: data.rank.present ? data.rank.value : this.rank,
      coursesCompleted: data.coursesCompleted.present
          ? data.coursesCompleted.value
          : this.coursesCompleted,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyLeaderboardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyLeaderboardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.points == this.points &&
          other.rank == this.rank &&
          other.coursesCompleted == this.coursesCompleted &&
          other.streakDays == this.streakDays &&
          other.page == this.page);
}

class MonthlyLeaderboardTableCompanion
    extends UpdateCompanion<MonthlyLeaderboardData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<double> points;
  final Value<int> rank;
  final Value<int> coursesCompleted;
  final Value<int> streakDays;
  final Value<int> page;
  final Value<int> rowid;
  const MonthlyLeaderboardTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.points = const Value.absent(),
    this.rank = const Value.absent(),
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthlyLeaderboardTableCompanion.insert({
    required String id,
    required String name,
    this.avatar = const Value.absent(),
    required double points,
    required int rank,
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       points = Value(points),
       rank = Value(rank);
  static Insertable<MonthlyLeaderboardData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<double>? points,
    Expression<int>? rank,
    Expression<int>? coursesCompleted,
    Expression<int>? streakDays,
    Expression<int>? page,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (points != null) 'points': points,
      if (rank != null) 'rank': rank,
      if (coursesCompleted != null) 'courses_completed': coursesCompleted,
      if (streakDays != null) 'streak_days': streakDays,
      if (page != null) 'page': page,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthlyLeaderboardTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<double>? points,
    Value<int>? rank,
    Value<int>? coursesCompleted,
    Value<int>? streakDays,
    Value<int>? page,
    Value<int>? rowid,
  }) {
    return MonthlyLeaderboardTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      streakDays: streakDays ?? this.streakDays,
      page: page ?? this.page,
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
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (points.present) {
      map['points'] = Variable<double>(points.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (coursesCompleted.present) {
      map['courses_completed'] = Variable<int>(coursesCompleted.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyLeaderboardTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllTimeLeaderboardTableTable extends AllTimeLeaderboardTable
    with TableInfo<$AllTimeLeaderboardTableTable, AllTimeLeaderboardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllTimeLeaderboardTableTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<double> points = GeneratedColumn<double>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coursesCompletedMeta = const VerificationMeta(
    'coursesCompleted',
  );
  @override
  late final GeneratedColumn<int> coursesCompleted = GeneratedColumn<int>(
    'courses_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'all_time_leaderboard';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllTimeLeaderboardData> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('courses_completed')) {
      context.handle(
        _coursesCompletedMeta,
        coursesCompleted.isAcceptableOrUnknown(
          data['courses_completed']!,
          _coursesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllTimeLeaderboardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllTimeLeaderboardData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}points'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      coursesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}courses_completed'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
    );
  }

  @override
  $AllTimeLeaderboardTableTable createAlias(String alias) {
    return $AllTimeLeaderboardTableTable(attachedDatabase, alias);
  }
}

class AllTimeLeaderboardData extends DataClass
    implements Insertable<AllTimeLeaderboardData> {
  final String id;
  final String name;
  final String? avatar;
  final double points;
  final int rank;
  final int coursesCompleted;
  final int streakDays;
  final int page;
  const AllTimeLeaderboardData({
    required this.id,
    required this.name,
    this.avatar,
    required this.points,
    required this.rank,
    required this.coursesCompleted,
    required this.streakDays,
    required this.page,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['points'] = Variable<double>(points);
    map['rank'] = Variable<int>(rank);
    map['courses_completed'] = Variable<int>(coursesCompleted);
    map['streak_days'] = Variable<int>(streakDays);
    map['page'] = Variable<int>(page);
    return map;
  }

  AllTimeLeaderboardTableCompanion toCompanion(bool nullToAbsent) {
    return AllTimeLeaderboardTableCompanion(
      id: Value(id),
      name: Value(name),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      points: Value(points),
      rank: Value(rank),
      coursesCompleted: Value(coursesCompleted),
      streakDays: Value(streakDays),
      page: Value(page),
    );
  }

  factory AllTimeLeaderboardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllTimeLeaderboardData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      points: serializer.fromJson<double>(json['points']),
      rank: serializer.fromJson<int>(json['rank']),
      coursesCompleted: serializer.fromJson<int>(json['coursesCompleted']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      page: serializer.fromJson<int>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'points': serializer.toJson<double>(points),
      'rank': serializer.toJson<int>(rank),
      'coursesCompleted': serializer.toJson<int>(coursesCompleted),
      'streakDays': serializer.toJson<int>(streakDays),
      'page': serializer.toJson<int>(page),
    };
  }

  AllTimeLeaderboardData copyWith({
    String? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    double? points,
    int? rank,
    int? coursesCompleted,
    int? streakDays,
    int? page,
  }) => AllTimeLeaderboardData(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar.present ? avatar.value : this.avatar,
    points: points ?? this.points,
    rank: rank ?? this.rank,
    coursesCompleted: coursesCompleted ?? this.coursesCompleted,
    streakDays: streakDays ?? this.streakDays,
    page: page ?? this.page,
  );
  AllTimeLeaderboardData copyWithCompanion(
    AllTimeLeaderboardTableCompanion data,
  ) {
    return AllTimeLeaderboardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      points: data.points.present ? data.points.value : this.points,
      rank: data.rank.present ? data.rank.value : this.rank,
      coursesCompleted: data.coursesCompleted.present
          ? data.coursesCompleted.value
          : this.coursesCompleted,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllTimeLeaderboardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    points,
    rank,
    coursesCompleted,
    streakDays,
    page,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllTimeLeaderboardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.points == this.points &&
          other.rank == this.rank &&
          other.coursesCompleted == this.coursesCompleted &&
          other.streakDays == this.streakDays &&
          other.page == this.page);
}

class AllTimeLeaderboardTableCompanion
    extends UpdateCompanion<AllTimeLeaderboardData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<double> points;
  final Value<int> rank;
  final Value<int> coursesCompleted;
  final Value<int> streakDays;
  final Value<int> page;
  final Value<int> rowid;
  const AllTimeLeaderboardTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.points = const Value.absent(),
    this.rank = const Value.absent(),
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllTimeLeaderboardTableCompanion.insert({
    required String id,
    required String name,
    this.avatar = const Value.absent(),
    required double points,
    required int rank,
    this.coursesCompleted = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       points = Value(points),
       rank = Value(rank);
  static Insertable<AllTimeLeaderboardData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<double>? points,
    Expression<int>? rank,
    Expression<int>? coursesCompleted,
    Expression<int>? streakDays,
    Expression<int>? page,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (points != null) 'points': points,
      if (rank != null) 'rank': rank,
      if (coursesCompleted != null) 'courses_completed': coursesCompleted,
      if (streakDays != null) 'streak_days': streakDays,
      if (page != null) 'page': page,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllTimeLeaderboardTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<double>? points,
    Value<int>? rank,
    Value<int>? coursesCompleted,
    Value<int>? streakDays,
    Value<int>? page,
    Value<int>? rowid,
  }) {
    return AllTimeLeaderboardTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      streakDays: streakDays ?? this.streakDays,
      page: page ?? this.page,
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
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (points.present) {
      map['points'] = Variable<double>(points.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (coursesCompleted.present) {
      map['courses_completed'] = Variable<int>(coursesCompleted.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllTimeLeaderboardTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('coursesCompleted: $coursesCompleted, ')
          ..write('streakDays: $streakDays, ')
          ..write('page: $page, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardContentsTableTable extends DashboardContentsTable
    with TableInfo<$DashboardContentsTableTable, DashboardContentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardContentsTableTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<DashboardSectionType, int>
  sectionType =
      GeneratedColumn<int>(
        'section_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DashboardSectionType>(
        $DashboardContentsTableTable.$convertersectionType,
      );
  @override
  late final GeneratedColumnWithTypeConverter<DashboardContentType, int>
  lessonType =
      GeneratedColumn<int>(
        'lesson_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DashboardContentType>(
        $DashboardContentsTableTable.$converterlessonType,
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
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _totalDurationMeta = const VerificationMeta(
    'totalDuration',
  );
  @override
  late final GeneratedColumn<String> totalDuration = GeneratedColumn<String>(
    'total_duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingDurationMeta = const VerificationMeta(
    'remainingDuration',
  );
  @override
  late final GeneratedColumn<String> remainingDuration =
      GeneratedColumn<String>(
        'remaining_duration',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _coverImageMeta = const VerificationMeta(
    'coverImage',
  );
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
    'cover_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    sectionType,
    lessonType,
    title,
    chapterId,
    chapterTitle,
    totalDuration,
    remainingDuration,
    coverImage,
    progress,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_contents_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashboardContentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
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
    if (data.containsKey('total_duration')) {
      context.handle(
        _totalDurationMeta,
        totalDuration.isAcceptableOrUnknown(
          data['total_duration']!,
          _totalDurationMeta,
        ),
      );
    }
    if (data.containsKey('remaining_duration')) {
      context.handle(
        _remainingDurationMeta,
        remainingDuration.isAcceptableOrUnknown(
          data['remaining_duration']!,
          _remainingDurationMeta,
        ),
      );
    }
    if (data.containsKey('cover_image')) {
      context.handle(
        _coverImageMeta,
        coverImage.isAcceptableOrUnknown(data['cover_image']!, _coverImageMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, sectionType};
  @override
  DashboardContentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardContentData(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      sectionType: $DashboardContentsTableTable.$convertersectionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}section_type'],
        )!,
      ),
      lessonType: $DashboardContentsTableTable.$converterlessonType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}lesson_type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      ),
      chapterTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_title'],
      ),
      totalDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_duration'],
      ),
      remainingDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remaining_duration'],
      ),
      coverImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $DashboardContentsTableTable createAlias(String alias) {
    return $DashboardContentsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DashboardSectionType, int, int>
  $convertersectionType = const EnumIndexConverter<DashboardSectionType>(
    DashboardSectionType.values,
  );
  static JsonTypeConverter2<DashboardContentType, int, int>
  $converterlessonType = const EnumIndexConverter<DashboardContentType>(
    DashboardContentType.values,
  );
}

class DashboardContentData extends DataClass
    implements Insertable<DashboardContentData> {
  final String lessonId;
  final DashboardSectionType sectionType;
  final DashboardContentType lessonType;
  final String title;
  final String? chapterId;
  final String? chapterTitle;
  final String? totalDuration;
  final String? remainingDuration;
  final String? coverImage;
  final double? progress;
  final int displayOrder;
  const DashboardContentData({
    required this.lessonId,
    required this.sectionType,
    required this.lessonType,
    required this.title,
    this.chapterId,
    this.chapterTitle,
    this.totalDuration,
    this.remainingDuration,
    this.coverImage,
    this.progress,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    {
      map['section_type'] = Variable<int>(
        $DashboardContentsTableTable.$convertersectionType.toSql(sectionType),
      );
    }
    {
      map['lesson_type'] = Variable<int>(
        $DashboardContentsTableTable.$converterlessonType.toSql(lessonType),
      );
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    if (!nullToAbsent || chapterTitle != null) {
      map['chapter_title'] = Variable<String>(chapterTitle);
    }
    if (!nullToAbsent || totalDuration != null) {
      map['total_duration'] = Variable<String>(totalDuration);
    }
    if (!nullToAbsent || remainingDuration != null) {
      map['remaining_duration'] = Variable<String>(remainingDuration);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<double>(progress);
    }
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  DashboardContentsTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardContentsTableCompanion(
      lessonId: Value(lessonId),
      sectionType: Value(sectionType),
      lessonType: Value(lessonType),
      title: Value(title),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      chapterTitle: chapterTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterTitle),
      totalDuration: totalDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDuration),
      remainingDuration: remainingDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingDuration),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      displayOrder: Value(displayOrder),
    );
  }

  factory DashboardContentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardContentData(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      sectionType: $DashboardContentsTableTable.$convertersectionType.fromJson(
        serializer.fromJson<int>(json['sectionType']),
      ),
      lessonType: $DashboardContentsTableTable.$converterlessonType.fromJson(
        serializer.fromJson<int>(json['lessonType']),
      ),
      title: serializer.fromJson<String>(json['title']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      chapterTitle: serializer.fromJson<String?>(json['chapterTitle']),
      totalDuration: serializer.fromJson<String?>(json['totalDuration']),
      remainingDuration: serializer.fromJson<String?>(
        json['remainingDuration'],
      ),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      progress: serializer.fromJson<double?>(json['progress']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'sectionType': serializer.toJson<int>(
        $DashboardContentsTableTable.$convertersectionType.toJson(sectionType),
      ),
      'lessonType': serializer.toJson<int>(
        $DashboardContentsTableTable.$converterlessonType.toJson(lessonType),
      ),
      'title': serializer.toJson<String>(title),
      'chapterId': serializer.toJson<String?>(chapterId),
      'chapterTitle': serializer.toJson<String?>(chapterTitle),
      'totalDuration': serializer.toJson<String?>(totalDuration),
      'remainingDuration': serializer.toJson<String?>(remainingDuration),
      'coverImage': serializer.toJson<String?>(coverImage),
      'progress': serializer.toJson<double?>(progress),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  DashboardContentData copyWith({
    String? lessonId,
    DashboardSectionType? sectionType,
    DashboardContentType? lessonType,
    String? title,
    Value<String?> chapterId = const Value.absent(),
    Value<String?> chapterTitle = const Value.absent(),
    Value<String?> totalDuration = const Value.absent(),
    Value<String?> remainingDuration = const Value.absent(),
    Value<String?> coverImage = const Value.absent(),
    Value<double?> progress = const Value.absent(),
    int? displayOrder,
  }) => DashboardContentData(
    lessonId: lessonId ?? this.lessonId,
    sectionType: sectionType ?? this.sectionType,
    lessonType: lessonType ?? this.lessonType,
    title: title ?? this.title,
    chapterId: chapterId.present ? chapterId.value : this.chapterId,
    chapterTitle: chapterTitle.present ? chapterTitle.value : this.chapterTitle,
    totalDuration: totalDuration.present
        ? totalDuration.value
        : this.totalDuration,
    remainingDuration: remainingDuration.present
        ? remainingDuration.value
        : this.remainingDuration,
    coverImage: coverImage.present ? coverImage.value : this.coverImage,
    progress: progress.present ? progress.value : this.progress,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  DashboardContentData copyWithCompanion(DashboardContentsTableCompanion data) {
    return DashboardContentData(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      sectionType: data.sectionType.present
          ? data.sectionType.value
          : this.sectionType,
      lessonType: data.lessonType.present
          ? data.lessonType.value
          : this.lessonType,
      title: data.title.present ? data.title.value : this.title,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      chapterTitle: data.chapterTitle.present
          ? data.chapterTitle.value
          : this.chapterTitle,
      totalDuration: data.totalDuration.present
          ? data.totalDuration.value
          : this.totalDuration,
      remainingDuration: data.remainingDuration.present
          ? data.remainingDuration.value
          : this.remainingDuration,
      coverImage: data.coverImage.present
          ? data.coverImage.value
          : this.coverImage,
      progress: data.progress.present ? data.progress.value : this.progress,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardContentData(')
          ..write('lessonId: $lessonId, ')
          ..write('sectionType: $sectionType, ')
          ..write('lessonType: $lessonType, ')
          ..write('title: $title, ')
          ..write('chapterId: $chapterId, ')
          ..write('chapterTitle: $chapterTitle, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('remainingDuration: $remainingDuration, ')
          ..write('coverImage: $coverImage, ')
          ..write('progress: $progress, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    lessonId,
    sectionType,
    lessonType,
    title,
    chapterId,
    chapterTitle,
    totalDuration,
    remainingDuration,
    coverImage,
    progress,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardContentData &&
          other.lessonId == this.lessonId &&
          other.sectionType == this.sectionType &&
          other.lessonType == this.lessonType &&
          other.title == this.title &&
          other.chapterId == this.chapterId &&
          other.chapterTitle == this.chapterTitle &&
          other.totalDuration == this.totalDuration &&
          other.remainingDuration == this.remainingDuration &&
          other.coverImage == this.coverImage &&
          other.progress == this.progress &&
          other.displayOrder == this.displayOrder);
}

class DashboardContentsTableCompanion
    extends UpdateCompanion<DashboardContentData> {
  final Value<String> lessonId;
  final Value<DashboardSectionType> sectionType;
  final Value<DashboardContentType> lessonType;
  final Value<String> title;
  final Value<String?> chapterId;
  final Value<String?> chapterTitle;
  final Value<String?> totalDuration;
  final Value<String?> remainingDuration;
  final Value<String?> coverImage;
  final Value<double?> progress;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const DashboardContentsTableCompanion({
    this.lessonId = const Value.absent(),
    this.sectionType = const Value.absent(),
    this.lessonType = const Value.absent(),
    this.title = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.chapterTitle = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.remainingDuration = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.progress = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardContentsTableCompanion.insert({
    required String lessonId,
    required DashboardSectionType sectionType,
    required DashboardContentType lessonType,
    required String title,
    this.chapterId = const Value.absent(),
    this.chapterTitle = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.remainingDuration = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.progress = const Value.absent(),
    required int displayOrder,
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId),
       sectionType = Value(sectionType),
       lessonType = Value(lessonType),
       title = Value(title),
       displayOrder = Value(displayOrder);
  static Insertable<DashboardContentData> custom({
    Expression<String>? lessonId,
    Expression<int>? sectionType,
    Expression<int>? lessonType,
    Expression<String>? title,
    Expression<String>? chapterId,
    Expression<String>? chapterTitle,
    Expression<String>? totalDuration,
    Expression<String>? remainingDuration,
    Expression<String>? coverImage,
    Expression<double>? progress,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (sectionType != null) 'section_type': sectionType,
      if (lessonType != null) 'lesson_type': lessonType,
      if (title != null) 'title': title,
      if (chapterId != null) 'chapter_id': chapterId,
      if (chapterTitle != null) 'chapter_title': chapterTitle,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (remainingDuration != null) 'remaining_duration': remainingDuration,
      if (coverImage != null) 'cover_image': coverImage,
      if (progress != null) 'progress': progress,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardContentsTableCompanion copyWith({
    Value<String>? lessonId,
    Value<DashboardSectionType>? sectionType,
    Value<DashboardContentType>? lessonType,
    Value<String>? title,
    Value<String?>? chapterId,
    Value<String?>? chapterTitle,
    Value<String?>? totalDuration,
    Value<String?>? remainingDuration,
    Value<String?>? coverImage,
    Value<double?>? progress,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return DashboardContentsTableCompanion(
      lessonId: lessonId ?? this.lessonId,
      sectionType: sectionType ?? this.sectionType,
      lessonType: lessonType ?? this.lessonType,
      title: title ?? this.title,
      chapterId: chapterId ?? this.chapterId,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      coverImage: coverImage ?? this.coverImage,
      progress: progress ?? this.progress,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (sectionType.present) {
      map['section_type'] = Variable<int>(
        $DashboardContentsTableTable.$convertersectionType.toSql(
          sectionType.value,
        ),
      );
    }
    if (lessonType.present) {
      map['lesson_type'] = Variable<int>(
        $DashboardContentsTableTable.$converterlessonType.toSql(
          lessonType.value,
        ),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (chapterTitle.present) {
      map['chapter_title'] = Variable<String>(chapterTitle.value);
    }
    if (totalDuration.present) {
      map['total_duration'] = Variable<String>(totalDuration.value);
    }
    if (remainingDuration.present) {
      map['remaining_duration'] = Variable<String>(remainingDuration.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardContentsTableCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('sectionType: $sectionType, ')
          ..write('lessonType: $lessonType, ')
          ..write('title: $title, ')
          ..write('chapterId: $chapterId, ')
          ..write('chapterTitle: $chapterTitle, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('remainingDuration: $remainingDuration, ')
          ..write('coverImage: $coverImage, ')
          ..write('progress: $progress, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTableTable extends DownloadsTable
    with TableInfo<$DownloadsTableTable, DownloadsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  @override
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeInBytesMeta = const VerificationMeta(
    'sizeInBytes',
  );
  @override
  late final GeneratedColumn<BigInt> sizeInBytes = GeneratedColumn<BigInt>(
    'size_in_bytes',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadedDateMeta = const VerificationMeta(
    'downloadedDate',
  );
  @override
  late final GeneratedColumn<String> downloadedDate = GeneratedColumn<String>(
    'downloaded_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeIndexMeta = const VerificationMeta(
    'typeIndex',
  );
  @override
  late final GeneratedColumn<int> typeIndex = GeneratedColumn<int>(
    'type_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusIndexMeta = const VerificationMeta(
    'statusIndex',
  );
  @override
  late final GeneratedColumn<int> statusIndex = GeneratedColumn<int>(
    'status_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    course,
    chapter,
    filePath,
    sizeInBytes,
    downloadedDate,
    typeIndex,
    statusIndex,
    progress,
    thumbnailUrl,
    duration,
    fileType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadsTableData> instance, {
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
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('size_in_bytes')) {
      context.handle(
        _sizeInBytesMeta,
        sizeInBytes.isAcceptableOrUnknown(
          data['size_in_bytes']!,
          _sizeInBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sizeInBytesMeta);
    }
    if (data.containsKey('downloaded_date')) {
      context.handle(
        _downloadedDateMeta,
        downloadedDate.isAcceptableOrUnknown(
          data['downloaded_date']!,
          _downloadedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedDateMeta);
    }
    if (data.containsKey('type_index')) {
      context.handle(
        _typeIndexMeta,
        typeIndex.isAcceptableOrUnknown(data['type_index']!, _typeIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_typeIndexMeta);
    }
    if (data.containsKey('status_index')) {
      context.handle(
        _statusIndexMeta,
        statusIndex.isAcceptableOrUnknown(
          data['status_index']!,
          _statusIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statusIndexMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      sizeInBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}size_in_bytes'],
      )!,
      downloadedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}downloaded_date'],
      )!,
      typeIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type_index'],
      )!,
      statusIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_index'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      ),
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      ),
    );
  }

  @override
  $DownloadsTableTable createAlias(String alias) {
    return $DownloadsTableTable(attachedDatabase, alias);
  }
}

class DownloadsTableData extends DataClass
    implements Insertable<DownloadsTableData> {
  /// Unique identifier for the download item (e.g. video_id or attachment_id).
  final String id;

  /// Title of the content.
  final String title;

  /// Course title this download belongs to.
  final String course;

  /// Chapter title this download belongs to.
  final String chapter;

  /// Local file path on the device.
  final String? filePath;

  /// Total size of the file in bytes.
  final BigInt sizeInBytes;

  /// Date the download was initiated/completed.
  final String downloadedDate;

  /// Type of download (e.g. video, attachment).
  /// Stored as index of DownloadType enum.
  final int typeIndex;

  /// Current status (e.g. completed, downloading, paused, error).
  /// Stored as index of DownloadStatus enum.
  final int statusIndex;

  /// Download progress (0-100).
  final int progress;

  /// Optional thumbnail URL for the content.
  final String? thumbnailUrl;

  /// Optional duration (for videos).
  final String? duration;

  /// Optional file extension (e.g. "PDF", "DOC").
  final String? fileType;
  const DownloadsTableData({
    required this.id,
    required this.title,
    required this.course,
    required this.chapter,
    this.filePath,
    required this.sizeInBytes,
    required this.downloadedDate,
    required this.typeIndex,
    required this.statusIndex,
    required this.progress,
    this.thumbnailUrl,
    this.duration,
    this.fileType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['course'] = Variable<String>(course);
    map['chapter'] = Variable<String>(chapter);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['size_in_bytes'] = Variable<BigInt>(sizeInBytes);
    map['downloaded_date'] = Variable<String>(downloadedDate);
    map['type_index'] = Variable<int>(typeIndex);
    map['status_index'] = Variable<int>(statusIndex);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    if (!nullToAbsent || fileType != null) {
      map['file_type'] = Variable<String>(fileType);
    }
    return map;
  }

  DownloadsTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadsTableCompanion(
      id: Value(id),
      title: Value(title),
      course: Value(course),
      chapter: Value(chapter),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      sizeInBytes: Value(sizeInBytes),
      downloadedDate: Value(downloadedDate),
      typeIndex: Value(typeIndex),
      statusIndex: Value(statusIndex),
      progress: Value(progress),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      fileType: fileType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileType),
    );
  }

  factory DownloadsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      course: serializer.fromJson<String>(json['course']),
      chapter: serializer.fromJson<String>(json['chapter']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      sizeInBytes: serializer.fromJson<BigInt>(json['sizeInBytes']),
      downloadedDate: serializer.fromJson<String>(json['downloadedDate']),
      typeIndex: serializer.fromJson<int>(json['typeIndex']),
      statusIndex: serializer.fromJson<int>(json['statusIndex']),
      progress: serializer.fromJson<int>(json['progress']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      duration: serializer.fromJson<String?>(json['duration']),
      fileType: serializer.fromJson<String?>(json['fileType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'course': serializer.toJson<String>(course),
      'chapter': serializer.toJson<String>(chapter),
      'filePath': serializer.toJson<String?>(filePath),
      'sizeInBytes': serializer.toJson<BigInt>(sizeInBytes),
      'downloadedDate': serializer.toJson<String>(downloadedDate),
      'typeIndex': serializer.toJson<int>(typeIndex),
      'statusIndex': serializer.toJson<int>(statusIndex),
      'progress': serializer.toJson<int>(progress),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'duration': serializer.toJson<String?>(duration),
      'fileType': serializer.toJson<String?>(fileType),
    };
  }

  DownloadsTableData copyWith({
    String? id,
    String? title,
    String? course,
    String? chapter,
    Value<String?> filePath = const Value.absent(),
    BigInt? sizeInBytes,
    String? downloadedDate,
    int? typeIndex,
    int? statusIndex,
    int? progress,
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<String?> duration = const Value.absent(),
    Value<String?> fileType = const Value.absent(),
  }) => DownloadsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    course: course ?? this.course,
    chapter: chapter ?? this.chapter,
    filePath: filePath.present ? filePath.value : this.filePath,
    sizeInBytes: sizeInBytes ?? this.sizeInBytes,
    downloadedDate: downloadedDate ?? this.downloadedDate,
    typeIndex: typeIndex ?? this.typeIndex,
    statusIndex: statusIndex ?? this.statusIndex,
    progress: progress ?? this.progress,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    duration: duration.present ? duration.value : this.duration,
    fileType: fileType.present ? fileType.value : this.fileType,
  );
  DownloadsTableData copyWithCompanion(DownloadsTableCompanion data) {
    return DownloadsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      course: data.course.present ? data.course.value : this.course,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      sizeInBytes: data.sizeInBytes.present
          ? data.sizeInBytes.value
          : this.sizeInBytes,
      downloadedDate: data.downloadedDate.present
          ? data.downloadedDate.value
          : this.downloadedDate,
      typeIndex: data.typeIndex.present ? data.typeIndex.value : this.typeIndex,
      statusIndex: data.statusIndex.present
          ? data.statusIndex.value
          : this.statusIndex,
      progress: data.progress.present ? data.progress.value : this.progress,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      duration: data.duration.present ? data.duration.value : this.duration,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('course: $course, ')
          ..write('chapter: $chapter, ')
          ..write('filePath: $filePath, ')
          ..write('sizeInBytes: $sizeInBytes, ')
          ..write('downloadedDate: $downloadedDate, ')
          ..write('typeIndex: $typeIndex, ')
          ..write('statusIndex: $statusIndex, ')
          ..write('progress: $progress, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('duration: $duration, ')
          ..write('fileType: $fileType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    course,
    chapter,
    filePath,
    sizeInBytes,
    downloadedDate,
    typeIndex,
    statusIndex,
    progress,
    thumbnailUrl,
    duration,
    fileType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.course == this.course &&
          other.chapter == this.chapter &&
          other.filePath == this.filePath &&
          other.sizeInBytes == this.sizeInBytes &&
          other.downloadedDate == this.downloadedDate &&
          other.typeIndex == this.typeIndex &&
          other.statusIndex == this.statusIndex &&
          other.progress == this.progress &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.duration == this.duration &&
          other.fileType == this.fileType);
}

class DownloadsTableCompanion extends UpdateCompanion<DownloadsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> course;
  final Value<String> chapter;
  final Value<String?> filePath;
  final Value<BigInt> sizeInBytes;
  final Value<String> downloadedDate;
  final Value<int> typeIndex;
  final Value<int> statusIndex;
  final Value<int> progress;
  final Value<String?> thumbnailUrl;
  final Value<String?> duration;
  final Value<String?> fileType;
  final Value<int> rowid;
  const DownloadsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.course = const Value.absent(),
    this.chapter = const Value.absent(),
    this.filePath = const Value.absent(),
    this.sizeInBytes = const Value.absent(),
    this.downloadedDate = const Value.absent(),
    this.typeIndex = const Value.absent(),
    this.statusIndex = const Value.absent(),
    this.progress = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.fileType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadsTableCompanion.insert({
    required String id,
    required String title,
    required String course,
    required String chapter,
    this.filePath = const Value.absent(),
    required BigInt sizeInBytes,
    required String downloadedDate,
    required int typeIndex,
    required int statusIndex,
    this.progress = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.fileType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       course = Value(course),
       chapter = Value(chapter),
       sizeInBytes = Value(sizeInBytes),
       downloadedDate = Value(downloadedDate),
       typeIndex = Value(typeIndex),
       statusIndex = Value(statusIndex);
  static Insertable<DownloadsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? course,
    Expression<String>? chapter,
    Expression<String>? filePath,
    Expression<BigInt>? sizeInBytes,
    Expression<String>? downloadedDate,
    Expression<int>? typeIndex,
    Expression<int>? statusIndex,
    Expression<int>? progress,
    Expression<String>? thumbnailUrl,
    Expression<String>? duration,
    Expression<String>? fileType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (course != null) 'course': course,
      if (chapter != null) 'chapter': chapter,
      if (filePath != null) 'file_path': filePath,
      if (sizeInBytes != null) 'size_in_bytes': sizeInBytes,
      if (downloadedDate != null) 'downloaded_date': downloadedDate,
      if (typeIndex != null) 'type_index': typeIndex,
      if (statusIndex != null) 'status_index': statusIndex,
      if (progress != null) 'progress': progress,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (duration != null) 'duration': duration,
      if (fileType != null) 'file_type': fileType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? course,
    Value<String>? chapter,
    Value<String?>? filePath,
    Value<BigInt>? sizeInBytes,
    Value<String>? downloadedDate,
    Value<int>? typeIndex,
    Value<int>? statusIndex,
    Value<int>? progress,
    Value<String?>? thumbnailUrl,
    Value<String?>? duration,
    Value<String?>? fileType,
    Value<int>? rowid,
  }) {
    return DownloadsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      chapter: chapter ?? this.chapter,
      filePath: filePath ?? this.filePath,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      downloadedDate: downloadedDate ?? this.downloadedDate,
      typeIndex: typeIndex ?? this.typeIndex,
      statusIndex: statusIndex ?? this.statusIndex,
      progress: progress ?? this.progress,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      fileType: fileType ?? this.fileType,
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
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (sizeInBytes.present) {
      map['size_in_bytes'] = Variable<BigInt>(sizeInBytes.value);
    }
    if (downloadedDate.present) {
      map['downloaded_date'] = Variable<String>(downloadedDate.value);
    }
    if (typeIndex.present) {
      map['type_index'] = Variable<int>(typeIndex.value);
    }
    if (statusIndex.present) {
      map['status_index'] = Variable<int>(statusIndex.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('course: $course, ')
          ..write('chapter: $chapter, ')
          ..write('filePath: $filePath, ')
          ..write('sizeInBytes: $sizeInBytes, ')
          ..write('downloadedDate: $downloadedDate, ')
          ..write('typeIndex: $typeIndex, ')
          ..write('statusIndex: $statusIndex, ')
          ..write('progress: $progress, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('duration: $duration, ')
          ..write('fileType: $fileType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoubtsTableTable extends DoubtsTable
    with TableInfo<$DoubtsTableTable, DoubtsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoubtsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<int> topicId = GeneratedColumn<int>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topicNameMeta = const VerificationMeta(
    'topicName',
  );
  @override
  late final GeneratedColumn<String> topicName = GeneratedColumn<String>(
    'topic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _studentNameMeta = const VerificationMeta(
    'studentName',
  );
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
    'student_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentAvatarMeta = const VerificationMeta(
    'studentAvatar',
  );
  @override
  late final GeneratedColumn<String> studentAvatar = GeneratedColumn<String>(
    'student_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyCountMeta = const VerificationMeta(
    'replyCount',
  );
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
    'reply_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdHumanizedMeta = const VerificationMeta(
    'createdHumanized',
  );
  @override
  late final GeneratedColumn<String> createdHumanized = GeneratedColumn<String>(
    'created_humanized',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topicId,
    topicName,
    lessonId,
    title,
    content,
    studentName,
    studentAvatar,
    replyCount,
    status,
    createdAt,
    createdHumanized,
    attachments,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doubts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoubtsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('topic_name')) {
      context.handle(
        _topicNameMeta,
        topicName.isAcceptableOrUnknown(data['topic_name']!, _topicNameMeta),
      );
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('student_name')) {
      context.handle(
        _studentNameMeta,
        studentName.isAcceptableOrUnknown(
          data['student_name']!,
          _studentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_studentNameMeta);
    }
    if (data.containsKey('student_avatar')) {
      context.handle(
        _studentAvatarMeta,
        studentAvatar.isAcceptableOrUnknown(
          data['student_avatar']!,
          _studentAvatarMeta,
        ),
      );
    }
    if (data.containsKey('reply_count')) {
      context.handle(
        _replyCountMeta,
        replyCount.isAcceptableOrUnknown(data['reply_count']!, _replyCountMeta),
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_humanized')) {
      context.handle(
        _createdHumanizedMeta,
        createdHumanized.isAcceptableOrUnknown(
          data['created_humanized']!,
          _createdHumanizedMeta,
        ),
      );
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoubtsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoubtsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}topic_id'],
      ),
      topicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_name'],
      ),
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      studentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_name'],
      )!,
      studentAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_avatar'],
      ),
      replyCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reply_count'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdHumanized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_humanized'],
      ),
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      ),
    );
  }

  @override
  $DoubtsTableTable createAlias(String alias) {
    return $DoubtsTableTable(attachedDatabase, alias);
  }
}

class DoubtsTableData extends DataClass implements Insertable<DoubtsTableData> {
  final String id;
  final int? topicId;
  final String? topicName;
  final String? lessonId;
  final String title;
  final String content;
  final String studentName;
  final String? studentAvatar;
  final int? replyCount;
  final String status;
  final DateTime createdAt;
  final String? createdHumanized;
  final String? attachments;
  const DoubtsTableData({
    required this.id,
    this.topicId,
    this.topicName,
    this.lessonId,
    required this.title,
    required this.content,
    required this.studentName,
    this.studentAvatar,
    this.replyCount,
    required this.status,
    required this.createdAt,
    this.createdHumanized,
    this.attachments,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<int>(topicId);
    }
    if (!nullToAbsent || topicName != null) {
      map['topic_name'] = Variable<String>(topicName);
    }
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['student_name'] = Variable<String>(studentName);
    if (!nullToAbsent || studentAvatar != null) {
      map['student_avatar'] = Variable<String>(studentAvatar);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int>(replyCount);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdHumanized != null) {
      map['created_humanized'] = Variable<String>(createdHumanized);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    return map;
  }

  DoubtsTableCompanion toCompanion(bool nullToAbsent) {
    return DoubtsTableCompanion(
      id: Value(id),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      topicName: topicName == null && nullToAbsent
          ? const Value.absent()
          : Value(topicName),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      title: Value(title),
      content: Value(content),
      studentName: Value(studentName),
      studentAvatar: studentAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(studentAvatar),
      replyCount: replyCount == null && nullToAbsent
          ? const Value.absent()
          : Value(replyCount),
      status: Value(status),
      createdAt: Value(createdAt),
      createdHumanized: createdHumanized == null && nullToAbsent
          ? const Value.absent()
          : Value(createdHumanized),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
    );
  }

  factory DoubtsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoubtsTableData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<int?>(json['topicId']),
      topicName: serializer.fromJson<String?>(json['topicName']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      studentName: serializer.fromJson<String>(json['studentName']),
      studentAvatar: serializer.fromJson<String?>(json['studentAvatar']),
      replyCount: serializer.fromJson<int?>(json['replyCount']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdHumanized: serializer.fromJson<String?>(json['createdHumanized']),
      attachments: serializer.fromJson<String?>(json['attachments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<int?>(topicId),
      'topicName': serializer.toJson<String?>(topicName),
      'lessonId': serializer.toJson<String?>(lessonId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'studentName': serializer.toJson<String>(studentName),
      'studentAvatar': serializer.toJson<String?>(studentAvatar),
      'replyCount': serializer.toJson<int?>(replyCount),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdHumanized': serializer.toJson<String?>(createdHumanized),
      'attachments': serializer.toJson<String?>(attachments),
    };
  }

  DoubtsTableData copyWith({
    String? id,
    Value<int?> topicId = const Value.absent(),
    Value<String?> topicName = const Value.absent(),
    Value<String?> lessonId = const Value.absent(),
    String? title,
    String? content,
    String? studentName,
    Value<String?> studentAvatar = const Value.absent(),
    Value<int?> replyCount = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<String?> createdHumanized = const Value.absent(),
    Value<String?> attachments = const Value.absent(),
  }) => DoubtsTableData(
    id: id ?? this.id,
    topicId: topicId.present ? topicId.value : this.topicId,
    topicName: topicName.present ? topicName.value : this.topicName,
    lessonId: lessonId.present ? lessonId.value : this.lessonId,
    title: title ?? this.title,
    content: content ?? this.content,
    studentName: studentName ?? this.studentName,
    studentAvatar: studentAvatar.present
        ? studentAvatar.value
        : this.studentAvatar,
    replyCount: replyCount.present ? replyCount.value : this.replyCount,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    createdHumanized: createdHumanized.present
        ? createdHumanized.value
        : this.createdHumanized,
    attachments: attachments.present ? attachments.value : this.attachments,
  );
  DoubtsTableData copyWithCompanion(DoubtsTableCompanion data) {
    return DoubtsTableData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      topicName: data.topicName.present ? data.topicName.value : this.topicName,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      studentName: data.studentName.present
          ? data.studentName.value
          : this.studentName,
      studentAvatar: data.studentAvatar.present
          ? data.studentAvatar.value
          : this.studentAvatar,
      replyCount: data.replyCount.present
          ? data.replyCount.value
          : this.replyCount,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdHumanized: data.createdHumanized.present
          ? data.createdHumanized.value
          : this.createdHumanized,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoubtsTableData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('topicName: $topicName, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('studentName: $studentName, ')
          ..write('studentAvatar: $studentAvatar, ')
          ..write('replyCount: $replyCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdHumanized: $createdHumanized, ')
          ..write('attachments: $attachments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    topicId,
    topicName,
    lessonId,
    title,
    content,
    studentName,
    studentAvatar,
    replyCount,
    status,
    createdAt,
    createdHumanized,
    attachments,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoubtsTableData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.topicName == this.topicName &&
          other.lessonId == this.lessonId &&
          other.title == this.title &&
          other.content == this.content &&
          other.studentName == this.studentName &&
          other.studentAvatar == this.studentAvatar &&
          other.replyCount == this.replyCount &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.createdHumanized == this.createdHumanized &&
          other.attachments == this.attachments);
}

class DoubtsTableCompanion extends UpdateCompanion<DoubtsTableData> {
  final Value<String> id;
  final Value<int?> topicId;
  final Value<String?> topicName;
  final Value<String?> lessonId;
  final Value<String> title;
  final Value<String> content;
  final Value<String> studentName;
  final Value<String?> studentAvatar;
  final Value<int?> replyCount;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String?> createdHumanized;
  final Value<String?> attachments;
  final Value<int> rowid;
  const DoubtsTableCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.topicName = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.studentName = const Value.absent(),
    this.studentAvatar = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdHumanized = const Value.absent(),
    this.attachments = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoubtsTableCompanion.insert({
    required String id,
    this.topicId = const Value.absent(),
    this.topicName = const Value.absent(),
    this.lessonId = const Value.absent(),
    required String title,
    required String content,
    required String studentName,
    this.studentAvatar = const Value.absent(),
    this.replyCount = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.createdHumanized = const Value.absent(),
    this.attachments = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       studentName = Value(studentName),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<DoubtsTableData> custom({
    Expression<String>? id,
    Expression<int>? topicId,
    Expression<String>? topicName,
    Expression<String>? lessonId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? studentName,
    Expression<String>? studentAvatar,
    Expression<int>? replyCount,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? createdHumanized,
    Expression<String>? attachments,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (topicName != null) 'topic_name': topicName,
      if (lessonId != null) 'lesson_id': lessonId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (studentName != null) 'student_name': studentName,
      if (studentAvatar != null) 'student_avatar': studentAvatar,
      if (replyCount != null) 'reply_count': replyCount,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (createdHumanized != null) 'created_humanized': createdHumanized,
      if (attachments != null) 'attachments': attachments,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoubtsTableCompanion copyWith({
    Value<String>? id,
    Value<int?>? topicId,
    Value<String?>? topicName,
    Value<String?>? lessonId,
    Value<String>? title,
    Value<String>? content,
    Value<String>? studentName,
    Value<String?>? studentAvatar,
    Value<int?>? replyCount,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String?>? createdHumanized,
    Value<String?>? attachments,
    Value<int>? rowid,
  }) {
    return DoubtsTableCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      content: content ?? this.content,
      studentName: studentName ?? this.studentName,
      studentAvatar: studentAvatar ?? this.studentAvatar,
      replyCount: replyCount ?? this.replyCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdHumanized: createdHumanized ?? this.createdHumanized,
      attachments: attachments ?? this.attachments,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<int>(topicId.value);
    }
    if (topicName.present) {
      map['topic_name'] = Variable<String>(topicName.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (studentAvatar.present) {
      map['student_avatar'] = Variable<String>(studentAvatar.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdHumanized.present) {
      map['created_humanized'] = Variable<String>(createdHumanized.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoubtsTableCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('topicName: $topicName, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('studentName: $studentName, ')
          ..write('studentAvatar: $studentAvatar, ')
          ..write('replyCount: $replyCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdHumanized: $createdHumanized, ')
          ..write('attachments: $attachments, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoubtRepliesTableTable extends DoubtRepliesTable
    with TableInfo<$DoubtRepliesTableTable, DoubtRepliesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoubtRepliesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doubtIdMeta = const VerificationMeta(
    'doubtId',
  );
  @override
  late final GeneratedColumn<String> doubtId = GeneratedColumn<String>(
    'doubt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _isMentorMeta = const VerificationMeta(
    'isMentor',
  );
  @override
  late final GeneratedColumn<bool> isMentor = GeneratedColumn<bool>(
    'is_mentor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mentor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdHumanizedMeta = const VerificationMeta(
    'createdHumanized',
  );
  @override
  late final GeneratedColumn<String> createdHumanized = GeneratedColumn<String>(
    'created_humanized',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doubtId,
    content,
    authorName,
    authorAvatar,
    isMentor,
    createdAt,
    createdHumanized,
    attachments,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doubt_replies_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoubtRepliesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doubt_id')) {
      context.handle(
        _doubtIdMeta,
        doubtId.isAcceptableOrUnknown(data['doubt_id']!, _doubtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doubtIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
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
    if (data.containsKey('is_mentor')) {
      context.handle(
        _isMentorMeta,
        isMentor.isAcceptableOrUnknown(data['is_mentor']!, _isMentorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_humanized')) {
      context.handle(
        _createdHumanizedMeta,
        createdHumanized.isAcceptableOrUnknown(
          data['created_humanized']!,
          _createdHumanizedMeta,
        ),
      );
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoubtRepliesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoubtRepliesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doubtId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doubt_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      authorAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar'],
      ),
      isMentor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mentor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdHumanized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_humanized'],
      ),
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      ),
    );
  }

  @override
  $DoubtRepliesTableTable createAlias(String alias) {
    return $DoubtRepliesTableTable(attachedDatabase, alias);
  }
}

class DoubtRepliesTableData extends DataClass
    implements Insertable<DoubtRepliesTableData> {
  final String id;
  final String doubtId;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final bool isMentor;
  final DateTime createdAt;
  final String? createdHumanized;
  final String? attachments;
  const DoubtRepliesTableData({
    required this.id,
    required this.doubtId,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.isMentor,
    required this.createdAt,
    this.createdHumanized,
    this.attachments,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doubt_id'] = Variable<String>(doubtId);
    map['content'] = Variable<String>(content);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['is_mentor'] = Variable<bool>(isMentor);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdHumanized != null) {
      map['created_humanized'] = Variable<String>(createdHumanized);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    return map;
  }

  DoubtRepliesTableCompanion toCompanion(bool nullToAbsent) {
    return DoubtRepliesTableCompanion(
      id: Value(id),
      doubtId: Value(doubtId),
      content: Value(content),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      isMentor: Value(isMentor),
      createdAt: Value(createdAt),
      createdHumanized: createdHumanized == null && nullToAbsent
          ? const Value.absent()
          : Value(createdHumanized),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
    );
  }

  factory DoubtRepliesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoubtRepliesTableData(
      id: serializer.fromJson<String>(json['id']),
      doubtId: serializer.fromJson<String>(json['doubtId']),
      content: serializer.fromJson<String>(json['content']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      isMentor: serializer.fromJson<bool>(json['isMentor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdHumanized: serializer.fromJson<String?>(json['createdHumanized']),
      attachments: serializer.fromJson<String?>(json['attachments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doubtId': serializer.toJson<String>(doubtId),
      'content': serializer.toJson<String>(content),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'isMentor': serializer.toJson<bool>(isMentor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdHumanized': serializer.toJson<String?>(createdHumanized),
      'attachments': serializer.toJson<String?>(attachments),
    };
  }

  DoubtRepliesTableData copyWith({
    String? id,
    String? doubtId,
    String? content,
    String? authorName,
    Value<String?> authorAvatar = const Value.absent(),
    bool? isMentor,
    DateTime? createdAt,
    Value<String?> createdHumanized = const Value.absent(),
    Value<String?> attachments = const Value.absent(),
  }) => DoubtRepliesTableData(
    id: id ?? this.id,
    doubtId: doubtId ?? this.doubtId,
    content: content ?? this.content,
    authorName: authorName ?? this.authorName,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    isMentor: isMentor ?? this.isMentor,
    createdAt: createdAt ?? this.createdAt,
    createdHumanized: createdHumanized.present
        ? createdHumanized.value
        : this.createdHumanized,
    attachments: attachments.present ? attachments.value : this.attachments,
  );
  DoubtRepliesTableData copyWithCompanion(DoubtRepliesTableCompanion data) {
    return DoubtRepliesTableData(
      id: data.id.present ? data.id.value : this.id,
      doubtId: data.doubtId.present ? data.doubtId.value : this.doubtId,
      content: data.content.present ? data.content.value : this.content,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      isMentor: data.isMentor.present ? data.isMentor.value : this.isMentor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdHumanized: data.createdHumanized.present
          ? data.createdHumanized.value
          : this.createdHumanized,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoubtRepliesTableData(')
          ..write('id: $id, ')
          ..write('doubtId: $doubtId, ')
          ..write('content: $content, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('isMentor: $isMentor, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdHumanized: $createdHumanized, ')
          ..write('attachments: $attachments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    doubtId,
    content,
    authorName,
    authorAvatar,
    isMentor,
    createdAt,
    createdHumanized,
    attachments,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoubtRepliesTableData &&
          other.id == this.id &&
          other.doubtId == this.doubtId &&
          other.content == this.content &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.isMentor == this.isMentor &&
          other.createdAt == this.createdAt &&
          other.createdHumanized == this.createdHumanized &&
          other.attachments == this.attachments);
}

class DoubtRepliesTableCompanion
    extends UpdateCompanion<DoubtRepliesTableData> {
  final Value<String> id;
  final Value<String> doubtId;
  final Value<String> content;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<bool> isMentor;
  final Value<DateTime> createdAt;
  final Value<String?> createdHumanized;
  final Value<String?> attachments;
  final Value<int> rowid;
  const DoubtRepliesTableCompanion({
    this.id = const Value.absent(),
    this.doubtId = const Value.absent(),
    this.content = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.isMentor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdHumanized = const Value.absent(),
    this.attachments = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoubtRepliesTableCompanion.insert({
    required String id,
    required String doubtId,
    required String content,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    this.isMentor = const Value.absent(),
    required DateTime createdAt,
    this.createdHumanized = const Value.absent(),
    this.attachments = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       doubtId = Value(doubtId),
       content = Value(content),
       authorName = Value(authorName),
       createdAt = Value(createdAt);
  static Insertable<DoubtRepliesTableData> custom({
    Expression<String>? id,
    Expression<String>? doubtId,
    Expression<String>? content,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<bool>? isMentor,
    Expression<DateTime>? createdAt,
    Expression<String>? createdHumanized,
    Expression<String>? attachments,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doubtId != null) 'doubt_id': doubtId,
      if (content != null) 'content': content,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (isMentor != null) 'is_mentor': isMentor,
      if (createdAt != null) 'created_at': createdAt,
      if (createdHumanized != null) 'created_humanized': createdHumanized,
      if (attachments != null) 'attachments': attachments,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoubtRepliesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? doubtId,
    Value<String>? content,
    Value<String>? authorName,
    Value<String?>? authorAvatar,
    Value<bool>? isMentor,
    Value<DateTime>? createdAt,
    Value<String?>? createdHumanized,
    Value<String?>? attachments,
    Value<int>? rowid,
  }) {
    return DoubtRepliesTableCompanion(
      id: id ?? this.id,
      doubtId: doubtId ?? this.doubtId,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      isMentor: isMentor ?? this.isMentor,
      createdAt: createdAt ?? this.createdAt,
      createdHumanized: createdHumanized ?? this.createdHumanized,
      attachments: attachments ?? this.attachments,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doubtId.present) {
      map['doubt_id'] = Variable<String>(doubtId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (isMentor.present) {
      map['is_mentor'] = Variable<bool>(isMentor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdHumanized.present) {
      map['created_humanized'] = Variable<String>(createdHumanized.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoubtRepliesTableCompanion(')
          ..write('id: $id, ')
          ..write('doubtId: $doubtId, ')
          ..write('content: $content, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('isMentor: $isMentor, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdHumanized: $createdHumanized, ')
          ..write('attachments: $attachments, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoubtTopicsTableTable extends DoubtTopicsTable
    with TableInfo<$DoubtTopicsTableTable, DoubtTopicsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoubtTopicsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasChildrenMeta = const VerificationMeta(
    'hasChildren',
  );
  @override
  late final GeneratedColumn<bool> hasChildren = GeneratedColumn<bool>(
    'has_children',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_children" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, parentId, hasChildren];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doubt_topics_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoubtTopicsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('has_children')) {
      context.handle(
        _hasChildrenMeta,
        hasChildren.isAcceptableOrUnknown(
          data['has_children']!,
          _hasChildrenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoubtTopicsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoubtTopicsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      hasChildren: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_children'],
      )!,
    );
  }

  @override
  $DoubtTopicsTableTable createAlias(String alias) {
    return $DoubtTopicsTableTable(attachedDatabase, alias);
  }
}

class DoubtTopicsTableData extends DataClass
    implements Insertable<DoubtTopicsTableData> {
  final int id;
  final String title;
  final int? parentId;
  final bool hasChildren;
  const DoubtTopicsTableData({
    required this.id,
    required this.title,
    this.parentId,
    required this.hasChildren,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['has_children'] = Variable<bool>(hasChildren);
    return map;
  }

  DoubtTopicsTableCompanion toCompanion(bool nullToAbsent) {
    return DoubtTopicsTableCompanion(
      id: Value(id),
      title: Value(title),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      hasChildren: Value(hasChildren),
    );
  }

  factory DoubtTopicsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoubtTopicsTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      hasChildren: serializer.fromJson<bool>(json['hasChildren']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'parentId': serializer.toJson<int?>(parentId),
      'hasChildren': serializer.toJson<bool>(hasChildren),
    };
  }

  DoubtTopicsTableData copyWith({
    int? id,
    String? title,
    Value<int?> parentId = const Value.absent(),
    bool? hasChildren,
  }) => DoubtTopicsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    parentId: parentId.present ? parentId.value : this.parentId,
    hasChildren: hasChildren ?? this.hasChildren,
  );
  DoubtTopicsTableData copyWithCompanion(DoubtTopicsTableCompanion data) {
    return DoubtTopicsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      hasChildren: data.hasChildren.present
          ? data.hasChildren.value
          : this.hasChildren,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoubtTopicsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('parentId: $parentId, ')
          ..write('hasChildren: $hasChildren')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, parentId, hasChildren);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoubtTopicsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.parentId == this.parentId &&
          other.hasChildren == this.hasChildren);
}

class DoubtTopicsTableCompanion extends UpdateCompanion<DoubtTopicsTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int?> parentId;
  final Value<bool> hasChildren;
  const DoubtTopicsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.parentId = const Value.absent(),
    this.hasChildren = const Value.absent(),
  });
  DoubtTopicsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.parentId = const Value.absent(),
    this.hasChildren = const Value.absent(),
  }) : title = Value(title);
  static Insertable<DoubtTopicsTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? parentId,
    Expression<bool>? hasChildren,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (parentId != null) 'parent_id': parentId,
      if (hasChildren != null) 'has_children': hasChildren,
    });
  }

  DoubtTopicsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int?>? parentId,
    Value<bool>? hasChildren,
  }) {
    return DoubtTopicsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      parentId: parentId ?? this.parentId,
      hasChildren: hasChildren ?? this.hasChildren,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (hasChildren.present) {
      map['has_children'] = Variable<bool>(hasChildren.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoubtTopicsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('parentId: $parentId, ')
          ..write('hasChildren: $hasChildren')
          ..write(')'))
        .toString();
  }
}

class $BookmarkFoldersTableTable extends BookmarkFoldersTable
    with TableInfo<$BookmarkFoldersTableTable, BookmarkFoldersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkFoldersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookmarksCountMeta = const VerificationMeta(
    'bookmarksCount',
  );
  @override
  late final GeneratedColumn<int> bookmarksCount = GeneratedColumn<int>(
    'bookmarks_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, bookmarksCount, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmark_folders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkFoldersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bookmarks_count')) {
      context.handle(
        _bookmarksCountMeta,
        bookmarksCount.isAcceptableOrUnknown(
          data['bookmarks_count']!,
          _bookmarksCountMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkFoldersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkFoldersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bookmarksCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bookmarks_count'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $BookmarkFoldersTableTable createAlias(String alias) {
    return $BookmarkFoldersTableTable(attachedDatabase, alias);
  }
}

class BookmarkFoldersTableData extends DataClass
    implements Insertable<BookmarkFoldersTableData> {
  final int id;
  final String name;
  final int bookmarksCount;
  final int? userId;
  const BookmarkFoldersTableData({
    required this.id,
    required this.name,
    required this.bookmarksCount,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['bookmarks_count'] = Variable<int>(bookmarksCount);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  BookmarkFoldersTableCompanion toCompanion(bool nullToAbsent) {
    return BookmarkFoldersTableCompanion(
      id: Value(id),
      name: Value(name),
      bookmarksCount: Value(bookmarksCount),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory BookmarkFoldersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkFoldersTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bookmarksCount: serializer.fromJson<int>(json['bookmarksCount']),
      userId: serializer.fromJson<int?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bookmarksCount': serializer.toJson<int>(bookmarksCount),
      'userId': serializer.toJson<int?>(userId),
    };
  }

  BookmarkFoldersTableData copyWith({
    int? id,
    String? name,
    int? bookmarksCount,
    Value<int?> userId = const Value.absent(),
  }) => BookmarkFoldersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    userId: userId.present ? userId.value : this.userId,
  );
  BookmarkFoldersTableData copyWithCompanion(
    BookmarkFoldersTableCompanion data,
  ) {
    return BookmarkFoldersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bookmarksCount: data.bookmarksCount.present
          ? data.bookmarksCount.value
          : this.bookmarksCount,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkFoldersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bookmarksCount, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkFoldersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.bookmarksCount == this.bookmarksCount &&
          other.userId == this.userId);
}

class BookmarkFoldersTableCompanion
    extends UpdateCompanion<BookmarkFoldersTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> bookmarksCount;
  final Value<int?> userId;
  const BookmarkFoldersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bookmarksCount = const Value.absent(),
    this.userId = const Value.absent(),
  });
  BookmarkFoldersTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.bookmarksCount = const Value.absent(),
    this.userId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<BookmarkFoldersTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? bookmarksCount,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bookmarksCount != null) 'bookmarks_count': bookmarksCount,
      if (userId != null) 'user_id': userId,
    });
  }

  BookmarkFoldersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? bookmarksCount,
    Value<int?>? userId,
  }) {
    return BookmarkFoldersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bookmarksCount.present) {
      map['bookmarks_count'] = Variable<int>(bookmarksCount.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkFoldersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $BookmarkItemsTableTable extends BookmarkItemsTable
    with TableInfo<$BookmarkItemsTableTable, BookmarkItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bookmark_folders_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _folderNameMeta = const VerificationMeta(
    'folderName',
  );
  @override
  late final GeneratedColumn<String> folderName = GeneratedColumn<String>(
    'folder_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookmarkTypeMeta = const VerificationMeta(
    'bookmarkType',
  );
  @override
  late final GeneratedColumn<String> bookmarkType = GeneratedColumn<String>(
    'bookmark_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    folderName,
    lessonId,
    bookmarkType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmark_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('folder_name')) {
      context.handle(
        _folderNameMeta,
        folderName.isAcceptableOrUnknown(data['folder_name']!, _folderNameMeta),
      );
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('bookmark_type')) {
      context.handle(
        _bookmarkTypeMeta,
        bookmarkType.isAcceptableOrUnknown(
          data['bookmark_type']!,
          _bookmarkTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      ),
      folderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_name'],
      ),
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      bookmarkType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bookmark_type'],
      ),
    );
  }

  @override
  $BookmarkItemsTableTable createAlias(String alias) {
    return $BookmarkItemsTableTable(attachedDatabase, alias);
  }
}

class BookmarkItemsTableData extends DataClass
    implements Insertable<BookmarkItemsTableData> {
  final int id;
  final int? folderId;
  final String? folderName;
  final int lessonId;
  final String? bookmarkType;
  const BookmarkItemsTableData({
    required this.id,
    this.folderId,
    this.folderName,
    required this.lessonId,
    this.bookmarkType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<int>(folderId);
    }
    if (!nullToAbsent || folderName != null) {
      map['folder_name'] = Variable<String>(folderName);
    }
    map['lesson_id'] = Variable<int>(lessonId);
    if (!nullToAbsent || bookmarkType != null) {
      map['bookmark_type'] = Variable<String>(bookmarkType);
    }
    return map;
  }

  BookmarkItemsTableCompanion toCompanion(bool nullToAbsent) {
    return BookmarkItemsTableCompanion(
      id: Value(id),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      folderName: folderName == null && nullToAbsent
          ? const Value.absent()
          : Value(folderName),
      lessonId: Value(lessonId),
      bookmarkType: bookmarkType == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarkType),
    );
  }

  factory BookmarkItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkItemsTableData(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int?>(json['folderId']),
      folderName: serializer.fromJson<String?>(json['folderName']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      bookmarkType: serializer.fromJson<String?>(json['bookmarkType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int?>(folderId),
      'folderName': serializer.toJson<String?>(folderName),
      'lessonId': serializer.toJson<int>(lessonId),
      'bookmarkType': serializer.toJson<String?>(bookmarkType),
    };
  }

  BookmarkItemsTableData copyWith({
    int? id,
    Value<int?> folderId = const Value.absent(),
    Value<String?> folderName = const Value.absent(),
    int? lessonId,
    Value<String?> bookmarkType = const Value.absent(),
  }) => BookmarkItemsTableData(
    id: id ?? this.id,
    folderId: folderId.present ? folderId.value : this.folderId,
    folderName: folderName.present ? folderName.value : this.folderName,
    lessonId: lessonId ?? this.lessonId,
    bookmarkType: bookmarkType.present ? bookmarkType.value : this.bookmarkType,
  );
  BookmarkItemsTableData copyWithCompanion(BookmarkItemsTableCompanion data) {
    return BookmarkItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      folderName: data.folderName.present
          ? data.folderName.value
          : this.folderName,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      bookmarkType: data.bookmarkType.present
          ? data.bookmarkType.value
          : this.bookmarkType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkItemsTableData(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('folderName: $folderName, ')
          ..write('lessonId: $lessonId, ')
          ..write('bookmarkType: $bookmarkType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, folderId, folderName, lessonId, bookmarkType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkItemsTableData &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.folderName == this.folderName &&
          other.lessonId == this.lessonId &&
          other.bookmarkType == this.bookmarkType);
}

class BookmarkItemsTableCompanion
    extends UpdateCompanion<BookmarkItemsTableData> {
  final Value<int> id;
  final Value<int?> folderId;
  final Value<String?> folderName;
  final Value<int> lessonId;
  final Value<String?> bookmarkType;
  const BookmarkItemsTableCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.folderName = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.bookmarkType = const Value.absent(),
  });
  BookmarkItemsTableCompanion.insert({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.folderName = const Value.absent(),
    required int lessonId,
    this.bookmarkType = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<BookmarkItemsTableData> custom({
    Expression<int>? id,
    Expression<int>? folderId,
    Expression<String>? folderName,
    Expression<int>? lessonId,
    Expression<String>? bookmarkType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (folderName != null) 'folder_name': folderName,
      if (lessonId != null) 'lesson_id': lessonId,
      if (bookmarkType != null) 'bookmark_type': bookmarkType,
    });
  }

  BookmarkItemsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? folderId,
    Value<String?>? folderName,
    Value<int>? lessonId,
    Value<String?>? bookmarkType,
  }) {
    return BookmarkItemsTableCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      lessonId: lessonId ?? this.lessonId,
      bookmarkType: bookmarkType ?? this.bookmarkType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (folderName.present) {
      map['folder_name'] = Variable<String>(folderName.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (bookmarkType.present) {
      map['bookmark_type'] = Variable<String>(bookmarkType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('folderName: $folderName, ')
          ..write('lessonId: $lessonId, ')
          ..write('bookmarkType: $bookmarkType')
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
  late final $DashboardBannersTableTable dashboardBannersTable =
      $DashboardBannersTableTable(this);
  late final $WeeklyLeaderboardTableTable weeklyLeaderboardTable =
      $WeeklyLeaderboardTableTable(this);
  late final $MonthlyLeaderboardTableTable monthlyLeaderboardTable =
      $MonthlyLeaderboardTableTable(this);
  late final $AllTimeLeaderboardTableTable allTimeLeaderboardTable =
      $AllTimeLeaderboardTableTable(this);
  late final $DashboardContentsTableTable dashboardContentsTable =
      $DashboardContentsTableTable(this);
  late final $DownloadsTableTable downloadsTable = $DownloadsTableTable(this);
  late final $DoubtsTableTable doubtsTable = $DoubtsTableTable(this);
  late final $DoubtRepliesTableTable doubtRepliesTable =
      $DoubtRepliesTableTable(this);
  late final $DoubtTopicsTableTable doubtTopicsTable = $DoubtTopicsTableTable(
    this,
  );
  late final $BookmarkFoldersTableTable bookmarkFoldersTable =
      $BookmarkFoldersTableTable(this);
  late final $BookmarkItemsTableTable bookmarkItemsTable =
      $BookmarkItemsTableTable(this);
  late final Index weeklyRankIdx = Index(
    'weekly_rank_idx',
    'CREATE INDEX weekly_rank_idx ON weekly_leaderboard (rank)',
  );
  late final Index weeklyPointsIdx = Index(
    'weekly_points_idx',
    'CREATE INDEX weekly_points_idx ON weekly_leaderboard (points)',
  );
  late final Index monthlyRankIdx = Index(
    'monthly_rank_idx',
    'CREATE INDEX monthly_rank_idx ON monthly_leaderboard (rank)',
  );
  late final Index monthlyPointsIdx = Index(
    'monthly_points_idx',
    'CREATE INDEX monthly_points_idx ON monthly_leaderboard (points)',
  );
  late final Index allTimeRankIdx = Index(
    'all_time_rank_idx',
    'CREATE INDEX all_time_rank_idx ON all_time_leaderboard (rank)',
  );
  late final Index allTimePointsIdx = Index(
    'all_time_points_idx',
    'CREATE INDEX all_time_points_idx ON all_time_leaderboard (points)',
  );
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
    dashboardBannersTable,
    weeklyLeaderboardTable,
    monthlyLeaderboardTable,
    allTimeLeaderboardTable,
    dashboardContentsTable,
    downloadsTable,
    doubtsTable,
    doubtRepliesTable,
    doubtTopicsTable,
    bookmarkFoldersTable,
    bookmarkItemsTable,
    weeklyRankIdx,
    weeklyPointsIdx,
    monthlyRankIdx,
    monthlyPointsIdx,
    allTimeRankIdx,
    allTimePointsIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bookmark_folders_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmark_items_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CoursesTableTableCreateCompanionBuilder =
    CoursesTableCompanion Function({
      required String id,
      required String title,
      required int colorIndex,
      required int chapterCount,
      Value<String?> totalDuration,
      Value<int> totalContents,
      Value<int> progress,
      Value<int> completedLessons,
      required int totalLessons,
      Value<String?> image,
      Value<String?> tags,
      Value<String?> allowedDevices,
      Value<int> examsCount,
      Value<int> orderIndex,
      Value<bool> isChaptersSynced,
      Value<int> rowid,
    });
typedef $$CoursesTableTableUpdateCompanionBuilder =
    CoursesTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> colorIndex,
      Value<int> chapterCount,
      Value<String?> totalDuration,
      Value<int> totalContents,
      Value<int> progress,
      Value<int> completedLessons,
      Value<int> totalLessons,
      Value<String?> image,
      Value<String?> tags,
      Value<String?> allowedDevices,
      Value<int> examsCount,
      Value<int> orderIndex,
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

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowedDevices => $composableBuilder(
    column: $table.allowedDevices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get examsCount => $composableBuilder(
    column: $table.examsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
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

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowedDevices => $composableBuilder(
    column: $table.allowedDevices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get examsCount => $composableBuilder(
    column: $table.examsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
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

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get allowedDevices => $composableBuilder(
    column: $table.allowedDevices,
    builder: (column) => column,
  );

  GeneratedColumn<int> get examsCount => $composableBuilder(
    column: $table.examsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

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
                Value<String?> totalDuration = const Value.absent(),
                Value<int> totalContents = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> completedLessons = const Value.absent(),
                Value<int> totalLessons = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> allowedDevices = const Value.absent(),
                Value<int> examsCount = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
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
                tags: tags,
                allowedDevices: allowedDevices,
                examsCount: examsCount,
                orderIndex: orderIndex,
                isChaptersSynced: isChaptersSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int colorIndex,
                required int chapterCount,
                Value<String?> totalDuration = const Value.absent(),
                Value<int> totalContents = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> completedLessons = const Value.absent(),
                required int totalLessons,
                Value<String?> image = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> allowedDevices = const Value.absent(),
                Value<int> examsCount = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
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
                tags: tags,
                allowedDevices: allowedDevices,
                examsCount: examsCount,
                orderIndex: orderIndex,
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
      Value<String?> courseId,
      Value<String?> ancestorChapterIds,
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
      Value<int?> bookmarkId,
      Value<bool> isRunning,
      Value<bool> isUpcoming,
      Value<bool> hasAttempts,
      Value<String?> image,
      Value<String?> nextContentId,
      Value<String?> previousContentId,
      Value<String?> htmlContent,
      Value<String?> chatEmbedUrl,
      Value<String?> streamStatus,
      Value<bool> showRecordedVideo,
      Value<bool> isDetailFetched,
      Value<bool> isScheduled,
      Value<String?> scheduledMessage,
      Value<String?> attemptsUrl,
      Value<String?> slug,
      Value<String?> description,
      Value<String?> examMetadataJson,
      Value<bool> enableTranscript,
      Value<String?> videoSubtitleUrl,
      Value<bool> isAiEnabled,
      Value<String?> aiNotesUrl,
      Value<int> rowid,
    });
typedef $$LessonsTableTableUpdateCompanionBuilder =
    LessonsTableCompanion Function({
      Value<String> id,
      Value<String> chapterId,
      Value<String?> courseId,
      Value<String?> ancestorChapterIds,
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
      Value<int?> bookmarkId,
      Value<bool> isRunning,
      Value<bool> isUpcoming,
      Value<bool> hasAttempts,
      Value<String?> image,
      Value<String?> nextContentId,
      Value<String?> previousContentId,
      Value<String?> htmlContent,
      Value<String?> chatEmbedUrl,
      Value<String?> streamStatus,
      Value<bool> showRecordedVideo,
      Value<bool> isDetailFetched,
      Value<bool> isScheduled,
      Value<String?> scheduledMessage,
      Value<String?> attemptsUrl,
      Value<String?> slug,
      Value<String?> description,
      Value<String?> examMetadataJson,
      Value<bool> enableTranscript,
      Value<String?> videoSubtitleUrl,
      Value<bool> isAiEnabled,
      Value<String?> aiNotesUrl,
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ancestorChapterIds => $composableBuilder(
    column: $table.ancestorChapterIds,
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

  ColumnFilters<int> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
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

  ColumnFilters<String> get nextContentId => $composableBuilder(
    column: $table.nextContentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousContentId => $composableBuilder(
    column: $table.previousContentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chatEmbedUrl => $composableBuilder(
    column: $table.chatEmbedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streamStatus => $composableBuilder(
    column: $table.streamStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showRecordedVideo => $composableBuilder(
    column: $table.showRecordedVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDetailFetched => $composableBuilder(
    column: $table.isDetailFetched,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isScheduled => $composableBuilder(
    column: $table.isScheduled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledMessage => $composableBuilder(
    column: $table.scheduledMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptsUrl => $composableBuilder(
    column: $table.attemptsUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examMetadataJson => $composableBuilder(
    column: $table.examMetadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableTranscript => $composableBuilder(
    column: $table.enableTranscript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoSubtitleUrl => $composableBuilder(
    column: $table.videoSubtitleUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAiEnabled => $composableBuilder(
    column: $table.isAiEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiNotesUrl => $composableBuilder(
    column: $table.aiNotesUrl,
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ancestorChapterIds => $composableBuilder(
    column: $table.ancestorChapterIds,
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

  ColumnOrderings<int> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
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

  ColumnOrderings<String> get nextContentId => $composableBuilder(
    column: $table.nextContentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousContentId => $composableBuilder(
    column: $table.previousContentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chatEmbedUrl => $composableBuilder(
    column: $table.chatEmbedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streamStatus => $composableBuilder(
    column: $table.streamStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showRecordedVideo => $composableBuilder(
    column: $table.showRecordedVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDetailFetched => $composableBuilder(
    column: $table.isDetailFetched,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isScheduled => $composableBuilder(
    column: $table.isScheduled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledMessage => $composableBuilder(
    column: $table.scheduledMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptsUrl => $composableBuilder(
    column: $table.attemptsUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examMetadataJson => $composableBuilder(
    column: $table.examMetadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableTranscript => $composableBuilder(
    column: $table.enableTranscript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoSubtitleUrl => $composableBuilder(
    column: $table.videoSubtitleUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAiEnabled => $composableBuilder(
    column: $table.isAiEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiNotesUrl => $composableBuilder(
    column: $table.aiNotesUrl,
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

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get ancestorChapterIds => $composableBuilder(
    column: $table.ancestorChapterIds,
    builder: (column) => column,
  );

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

  GeneratedColumn<int> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
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

  GeneratedColumn<String> get nextContentId => $composableBuilder(
    column: $table.nextContentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousContentId => $composableBuilder(
    column: $table.previousContentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chatEmbedUrl => $composableBuilder(
    column: $table.chatEmbedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streamStatus => $composableBuilder(
    column: $table.streamStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showRecordedVideo => $composableBuilder(
    column: $table.showRecordedVideo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDetailFetched => $composableBuilder(
    column: $table.isDetailFetched,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isScheduled => $composableBuilder(
    column: $table.isScheduled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledMessage => $composableBuilder(
    column: $table.scheduledMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attemptsUrl => $composableBuilder(
    column: $table.attemptsUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get examMetadataJson => $composableBuilder(
    column: $table.examMetadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableTranscript => $composableBuilder(
    column: $table.enableTranscript,
    builder: (column) => column,
  );

  GeneratedColumn<String> get videoSubtitleUrl => $composableBuilder(
    column: $table.videoSubtitleUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAiEnabled => $composableBuilder(
    column: $table.isAiEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiNotesUrl => $composableBuilder(
    column: $table.aiNotesUrl,
    builder: (column) => column,
  );
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
                Value<String?> courseId = const Value.absent(),
                Value<String?> ancestorChapterIds = const Value.absent(),
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
                Value<int?> bookmarkId = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<bool> isUpcoming = const Value.absent(),
                Value<bool> hasAttempts = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> nextContentId = const Value.absent(),
                Value<String?> previousContentId = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> chatEmbedUrl = const Value.absent(),
                Value<String?> streamStatus = const Value.absent(),
                Value<bool> showRecordedVideo = const Value.absent(),
                Value<bool> isDetailFetched = const Value.absent(),
                Value<bool> isScheduled = const Value.absent(),
                Value<String?> scheduledMessage = const Value.absent(),
                Value<String?> attemptsUrl = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> examMetadataJson = const Value.absent(),
                Value<bool> enableTranscript = const Value.absent(),
                Value<String?> videoSubtitleUrl = const Value.absent(),
                Value<bool> isAiEnabled = const Value.absent(),
                Value<String?> aiNotesUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion(
                id: id,
                chapterId: chapterId,
                courseId: courseId,
                ancestorChapterIds: ancestorChapterIds,
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
                bookmarkId: bookmarkId,
                isRunning: isRunning,
                isUpcoming: isUpcoming,
                hasAttempts: hasAttempts,
                image: image,
                nextContentId: nextContentId,
                previousContentId: previousContentId,
                htmlContent: htmlContent,
                chatEmbedUrl: chatEmbedUrl,
                streamStatus: streamStatus,
                showRecordedVideo: showRecordedVideo,
                isDetailFetched: isDetailFetched,
                isScheduled: isScheduled,
                scheduledMessage: scheduledMessage,
                attemptsUrl: attemptsUrl,
                slug: slug,
                description: description,
                examMetadataJson: examMetadataJson,
                enableTranscript: enableTranscript,
                videoSubtitleUrl: videoSubtitleUrl,
                isAiEnabled: isAiEnabled,
                aiNotesUrl: aiNotesUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                Value<String?> courseId = const Value.absent(),
                Value<String?> ancestorChapterIds = const Value.absent(),
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
                Value<int?> bookmarkId = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<bool> isUpcoming = const Value.absent(),
                Value<bool> hasAttempts = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> nextContentId = const Value.absent(),
                Value<String?> previousContentId = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> chatEmbedUrl = const Value.absent(),
                Value<String?> streamStatus = const Value.absent(),
                Value<bool> showRecordedVideo = const Value.absent(),
                Value<bool> isDetailFetched = const Value.absent(),
                Value<bool> isScheduled = const Value.absent(),
                Value<String?> scheduledMessage = const Value.absent(),
                Value<String?> attemptsUrl = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> examMetadataJson = const Value.absent(),
                Value<bool> enableTranscript = const Value.absent(),
                Value<String?> videoSubtitleUrl = const Value.absent(),
                Value<bool> isAiEnabled = const Value.absent(),
                Value<String?> aiNotesUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion.insert(
                id: id,
                chapterId: chapterId,
                courseId: courseId,
                ancestorChapterIds: ancestorChapterIds,
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
                bookmarkId: bookmarkId,
                isRunning: isRunning,
                isUpcoming: isUpcoming,
                hasAttempts: hasAttempts,
                image: image,
                nextContentId: nextContentId,
                previousContentId: previousContentId,
                htmlContent: htmlContent,
                chatEmbedUrl: chatEmbedUrl,
                streamStatus: streamStatus,
                showRecordedVideo: showRecordedVideo,
                isDetailFetched: isDetailFetched,
                isScheduled: isScheduled,
                scheduledMessage: scheduledMessage,
                attemptsUrl: attemptsUrl,
                slug: slug,
                description: description,
                examMetadataJson: examMetadataJson,
                enableTranscript: enableTranscript,
                videoSubtitleUrl: videoSubtitleUrl,
                isAiEnabled: isAiEnabled,
                aiNotesUrl: aiNotesUrl,
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
      Value<String?> courseId,
      required String title,
      required String description,
      required String authorName,
      Value<String?> authorAvatar,
      required String createdAt,
      Value<int> replyCount,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<int?> threadId,
      required String status,
      Value<String?> imageUrl,
      Value<String?> categorySlug,
      Value<String?> contentHtml,
      Value<int> rowid,
    });
typedef $$ForumThreadsTableTableUpdateCompanionBuilder =
    ForumThreadsTableCompanion Function({
      Value<String> id,
      Value<String?> courseId,
      Value<String> title,
      Value<String> description,
      Value<String> authorName,
      Value<String?> authorAvatar,
      Value<String> createdAt,
      Value<int> replyCount,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<int?> threadId,
      Value<String> status,
      Value<String?> imageUrl,
      Value<String?> categorySlug,
      Value<String?> contentHtml,
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  ColumnFilters<int> get threadId => $composableBuilder(
    column: $table.threadId,
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

  ColumnFilters<String> get categorySlug => $composableBuilder(
    column: $table.categorySlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  ColumnOrderings<int> get threadId => $composableBuilder(
    column: $table.threadId,
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

  ColumnOrderings<String> get categorySlug => $composableBuilder(
    column: $table.categorySlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get upvotes =>
      $composableBuilder(column: $table.upvotes, builder: (column) => column);

  GeneratedColumn<int> get downvotes =>
      $composableBuilder(column: $table.downvotes, builder: (column) => column);

  GeneratedColumn<int> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get categorySlug => $composableBuilder(
    column: $table.categorySlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => column,
  );
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
                Value<String?> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> replyCount = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<int?> threadId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> categorySlug = const Value.absent(),
                Value<String?> contentHtml = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumThreadsTableCompanion(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                authorName: authorName,
                authorAvatar: authorAvatar,
                createdAt: createdAt,
                replyCount: replyCount,
                upvotes: upvotes,
                downvotes: downvotes,
                threadId: threadId,
                status: status,
                imageUrl: imageUrl,
                categorySlug: categorySlug,
                contentHtml: contentHtml,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> courseId = const Value.absent(),
                required String title,
                required String description,
                required String authorName,
                Value<String?> authorAvatar = const Value.absent(),
                required String createdAt,
                Value<int> replyCount = const Value.absent(),
                Value<int> upvotes = const Value.absent(),
                Value<int> downvotes = const Value.absent(),
                Value<int?> threadId = const Value.absent(),
                required String status,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> categorySlug = const Value.absent(),
                Value<String?> contentHtml = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForumThreadsTableCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                authorName: authorName,
                authorAvatar: authorAvatar,
                createdAt: createdAt,
                replyCount: replyCount,
                upvotes: upvotes,
                downvotes: downvotes,
                threadId: threadId,
                status: status,
                imageUrl: imageUrl,
                categorySlug: categorySlug,
                contentHtml: contentHtml,
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
      required int threadId,
      required String authorName,
      Value<String?> authorAvatar,
      required String content,
      required String createdAt,
      Value<int> upvotes,
      Value<int> downvotes,
      Value<bool> isInstructor,
      Value<int> rowid,
    });
typedef $$ForumCommentsTableTableUpdateCompanionBuilder =
    ForumCommentsTableCompanion Function({
      Value<String> id,
      Value<int> threadId,
      Value<String> authorName,
      Value<String?> authorAvatar,
      Value<String> content,
      Value<String> createdAt,
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

  ColumnFilters<int> get threadId => $composableBuilder(
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  ColumnOrderings<int> get threadId => $composableBuilder(
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  GeneratedColumn<int> get threadId =>
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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
                Value<int> threadId = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
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
                createdAt: createdAt,
                upvotes: upvotes,
                downvotes: downvotes,
                isInstructor: isInstructor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int threadId,
                required String authorName,
                Value<String?> authorAvatar = const Value.absent(),
                required String content,
                required String createdAt,
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
                createdAt: createdAt,
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
typedef $$DashboardBannersTableTableCreateCompanionBuilder =
    DashboardBannersTableCompanion Function({
      required String id,
      required String imageUrl,
      Value<String?> title,
      Value<String?> link,
      Value<String?> description,
      Value<int?> bgColor,
      Value<int?> textColor,
      Value<String?> tag,
      Value<int> rowid,
    });
typedef $$DashboardBannersTableTableUpdateCompanionBuilder =
    DashboardBannersTableCompanion Function({
      Value<String> id,
      Value<String> imageUrl,
      Value<String?> title,
      Value<String?> link,
      Value<String?> description,
      Value<int?> bgColor,
      Value<int?> textColor,
      Value<String?> tag,
      Value<int> rowid,
    });

class $$DashboardBannersTableTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardBannersTableTable> {
  $$DashboardBannersTableTableFilterComposer({
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

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bgColor => $composableBuilder(
    column: $table.bgColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get textColor => $composableBuilder(
    column: $table.textColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardBannersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardBannersTableTable> {
  $$DashboardBannersTableTableOrderingComposer({
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

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bgColor => $composableBuilder(
    column: $table.bgColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get textColor => $composableBuilder(
    column: $table.textColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardBannersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardBannersTableTable> {
  $$DashboardBannersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bgColor =>
      $composableBuilder(column: $table.bgColor, builder: (column) => column);

  GeneratedColumn<int> get textColor =>
      $composableBuilder(column: $table.textColor, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$DashboardBannersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardBannersTableTable,
          DashboardBannersTableData,
          $$DashboardBannersTableTableFilterComposer,
          $$DashboardBannersTableTableOrderingComposer,
          $$DashboardBannersTableTableAnnotationComposer,
          $$DashboardBannersTableTableCreateCompanionBuilder,
          $$DashboardBannersTableTableUpdateCompanionBuilder,
          (
            DashboardBannersTableData,
            BaseReferences<
              _$AppDatabase,
              $DashboardBannersTableTable,
              DashboardBannersTableData
            >,
          ),
          DashboardBannersTableData,
          PrefetchHooks Function()
        > {
  $$DashboardBannersTableTableTableManager(
    _$AppDatabase db,
    $DashboardBannersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardBannersTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DashboardBannersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DashboardBannersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> bgColor = const Value.absent(),
                Value<int?> textColor = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardBannersTableCompanion(
                id: id,
                imageUrl: imageUrl,
                title: title,
                link: link,
                description: description,
                bgColor: bgColor,
                textColor: textColor,
                tag: tag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String imageUrl,
                Value<String?> title = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> bgColor = const Value.absent(),
                Value<int?> textColor = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardBannersTableCompanion.insert(
                id: id,
                imageUrl: imageUrl,
                title: title,
                link: link,
                description: description,
                bgColor: bgColor,
                textColor: textColor,
                tag: tag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardBannersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardBannersTableTable,
      DashboardBannersTableData,
      $$DashboardBannersTableTableFilterComposer,
      $$DashboardBannersTableTableOrderingComposer,
      $$DashboardBannersTableTableAnnotationComposer,
      $$DashboardBannersTableTableCreateCompanionBuilder,
      $$DashboardBannersTableTableUpdateCompanionBuilder,
      (
        DashboardBannersTableData,
        BaseReferences<
          _$AppDatabase,
          $DashboardBannersTableTable,
          DashboardBannersTableData
        >,
      ),
      DashboardBannersTableData,
      PrefetchHooks Function()
    >;
typedef $$WeeklyLeaderboardTableTableCreateCompanionBuilder =
    WeeklyLeaderboardTableCompanion Function({
      required String id,
      required String name,
      Value<String?> avatar,
      required double points,
      required int rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });
typedef $$WeeklyLeaderboardTableTableUpdateCompanionBuilder =
    WeeklyLeaderboardTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> avatar,
      Value<double> points,
      Value<int> rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });

class $$WeeklyLeaderboardTableTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyLeaderboardTableTable> {
  $$WeeklyLeaderboardTableTableFilterComposer({
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

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyLeaderboardTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyLeaderboardTableTable> {
  $$WeeklyLeaderboardTableTableOrderingComposer({
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

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyLeaderboardTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyLeaderboardTableTable> {
  $$WeeklyLeaderboardTableTableAnnotationComposer({
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

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<double> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);
}

class $$WeeklyLeaderboardTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyLeaderboardTableTable,
          WeeklyLeaderboardData,
          $$WeeklyLeaderboardTableTableFilterComposer,
          $$WeeklyLeaderboardTableTableOrderingComposer,
          $$WeeklyLeaderboardTableTableAnnotationComposer,
          $$WeeklyLeaderboardTableTableCreateCompanionBuilder,
          $$WeeklyLeaderboardTableTableUpdateCompanionBuilder,
          (
            WeeklyLeaderboardData,
            BaseReferences<
              _$AppDatabase,
              $WeeklyLeaderboardTableTable,
              WeeklyLeaderboardData
            >,
          ),
          WeeklyLeaderboardData,
          PrefetchHooks Function()
        > {
  $$WeeklyLeaderboardTableTableTableManager(
    _$AppDatabase db,
    $WeeklyLeaderboardTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyLeaderboardTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeeklyLeaderboardTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyLeaderboardTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<double> points = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyLeaderboardTableCompanion(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> avatar = const Value.absent(),
                required double points,
                required int rank,
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyLeaderboardTableCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyLeaderboardTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyLeaderboardTableTable,
      WeeklyLeaderboardData,
      $$WeeklyLeaderboardTableTableFilterComposer,
      $$WeeklyLeaderboardTableTableOrderingComposer,
      $$WeeklyLeaderboardTableTableAnnotationComposer,
      $$WeeklyLeaderboardTableTableCreateCompanionBuilder,
      $$WeeklyLeaderboardTableTableUpdateCompanionBuilder,
      (
        WeeklyLeaderboardData,
        BaseReferences<
          _$AppDatabase,
          $WeeklyLeaderboardTableTable,
          WeeklyLeaderboardData
        >,
      ),
      WeeklyLeaderboardData,
      PrefetchHooks Function()
    >;
typedef $$MonthlyLeaderboardTableTableCreateCompanionBuilder =
    MonthlyLeaderboardTableCompanion Function({
      required String id,
      required String name,
      Value<String?> avatar,
      required double points,
      required int rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });
typedef $$MonthlyLeaderboardTableTableUpdateCompanionBuilder =
    MonthlyLeaderboardTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> avatar,
      Value<double> points,
      Value<int> rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });

class $$MonthlyLeaderboardTableTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyLeaderboardTableTable> {
  $$MonthlyLeaderboardTableTableFilterComposer({
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

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyLeaderboardTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyLeaderboardTableTable> {
  $$MonthlyLeaderboardTableTableOrderingComposer({
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

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyLeaderboardTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyLeaderboardTableTable> {
  $$MonthlyLeaderboardTableTableAnnotationComposer({
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

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<double> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);
}

class $$MonthlyLeaderboardTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyLeaderboardTableTable,
          MonthlyLeaderboardData,
          $$MonthlyLeaderboardTableTableFilterComposer,
          $$MonthlyLeaderboardTableTableOrderingComposer,
          $$MonthlyLeaderboardTableTableAnnotationComposer,
          $$MonthlyLeaderboardTableTableCreateCompanionBuilder,
          $$MonthlyLeaderboardTableTableUpdateCompanionBuilder,
          (
            MonthlyLeaderboardData,
            BaseReferences<
              _$AppDatabase,
              $MonthlyLeaderboardTableTable,
              MonthlyLeaderboardData
            >,
          ),
          MonthlyLeaderboardData,
          PrefetchHooks Function()
        > {
  $$MonthlyLeaderboardTableTableTableManager(
    _$AppDatabase db,
    $MonthlyLeaderboardTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyLeaderboardTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MonthlyLeaderboardTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MonthlyLeaderboardTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<double> points = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthlyLeaderboardTableCompanion(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> avatar = const Value.absent(),
                required double points,
                required int rank,
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthlyLeaderboardTableCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyLeaderboardTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyLeaderboardTableTable,
      MonthlyLeaderboardData,
      $$MonthlyLeaderboardTableTableFilterComposer,
      $$MonthlyLeaderboardTableTableOrderingComposer,
      $$MonthlyLeaderboardTableTableAnnotationComposer,
      $$MonthlyLeaderboardTableTableCreateCompanionBuilder,
      $$MonthlyLeaderboardTableTableUpdateCompanionBuilder,
      (
        MonthlyLeaderboardData,
        BaseReferences<
          _$AppDatabase,
          $MonthlyLeaderboardTableTable,
          MonthlyLeaderboardData
        >,
      ),
      MonthlyLeaderboardData,
      PrefetchHooks Function()
    >;
typedef $$AllTimeLeaderboardTableTableCreateCompanionBuilder =
    AllTimeLeaderboardTableCompanion Function({
      required String id,
      required String name,
      Value<String?> avatar,
      required double points,
      required int rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });
typedef $$AllTimeLeaderboardTableTableUpdateCompanionBuilder =
    AllTimeLeaderboardTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> avatar,
      Value<double> points,
      Value<int> rank,
      Value<int> coursesCompleted,
      Value<int> streakDays,
      Value<int> page,
      Value<int> rowid,
    });

class $$AllTimeLeaderboardTableTableFilterComposer
    extends Composer<_$AppDatabase, $AllTimeLeaderboardTableTable> {
  $$AllTimeLeaderboardTableTableFilterComposer({
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

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllTimeLeaderboardTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AllTimeLeaderboardTableTable> {
  $$AllTimeLeaderboardTableTableOrderingComposer({
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

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllTimeLeaderboardTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllTimeLeaderboardTableTable> {
  $$AllTimeLeaderboardTableTableAnnotationComposer({
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

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<double> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get coursesCompleted => $composableBuilder(
    column: $table.coursesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);
}

class $$AllTimeLeaderboardTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllTimeLeaderboardTableTable,
          AllTimeLeaderboardData,
          $$AllTimeLeaderboardTableTableFilterComposer,
          $$AllTimeLeaderboardTableTableOrderingComposer,
          $$AllTimeLeaderboardTableTableAnnotationComposer,
          $$AllTimeLeaderboardTableTableCreateCompanionBuilder,
          $$AllTimeLeaderboardTableTableUpdateCompanionBuilder,
          (
            AllTimeLeaderboardData,
            BaseReferences<
              _$AppDatabase,
              $AllTimeLeaderboardTableTable,
              AllTimeLeaderboardData
            >,
          ),
          AllTimeLeaderboardData,
          PrefetchHooks Function()
        > {
  $$AllTimeLeaderboardTableTableTableManager(
    _$AppDatabase db,
    $AllTimeLeaderboardTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllTimeLeaderboardTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AllTimeLeaderboardTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AllTimeLeaderboardTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<double> points = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllTimeLeaderboardTableCompanion(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> avatar = const Value.absent(),
                required double points,
                required int rank,
                Value<int> coursesCompleted = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllTimeLeaderboardTableCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                points: points,
                rank: rank,
                coursesCompleted: coursesCompleted,
                streakDays: streakDays,
                page: page,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllTimeLeaderboardTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllTimeLeaderboardTableTable,
      AllTimeLeaderboardData,
      $$AllTimeLeaderboardTableTableFilterComposer,
      $$AllTimeLeaderboardTableTableOrderingComposer,
      $$AllTimeLeaderboardTableTableAnnotationComposer,
      $$AllTimeLeaderboardTableTableCreateCompanionBuilder,
      $$AllTimeLeaderboardTableTableUpdateCompanionBuilder,
      (
        AllTimeLeaderboardData,
        BaseReferences<
          _$AppDatabase,
          $AllTimeLeaderboardTableTable,
          AllTimeLeaderboardData
        >,
      ),
      AllTimeLeaderboardData,
      PrefetchHooks Function()
    >;
typedef $$DashboardContentsTableTableCreateCompanionBuilder =
    DashboardContentsTableCompanion Function({
      required String lessonId,
      required DashboardSectionType sectionType,
      required DashboardContentType lessonType,
      required String title,
      Value<String?> chapterId,
      Value<String?> chapterTitle,
      Value<String?> totalDuration,
      Value<String?> remainingDuration,
      Value<String?> coverImage,
      Value<double?> progress,
      required int displayOrder,
      Value<int> rowid,
    });
typedef $$DashboardContentsTableTableUpdateCompanionBuilder =
    DashboardContentsTableCompanion Function({
      Value<String> lessonId,
      Value<DashboardSectionType> sectionType,
      Value<DashboardContentType> lessonType,
      Value<String> title,
      Value<String?> chapterId,
      Value<String?> chapterTitle,
      Value<String?> totalDuration,
      Value<String?> remainingDuration,
      Value<String?> coverImage,
      Value<double?> progress,
      Value<int> displayOrder,
      Value<int> rowid,
    });

class $$DashboardContentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardContentsTableTable> {
  $$DashboardContentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    DashboardSectionType,
    DashboardSectionType,
    int
  >
  get sectionType => $composableBuilder(
    column: $table.sectionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    DashboardContentType,
    DashboardContentType,
    int
  >
  get lessonType => $composableBuilder(
    column: $table.lessonType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remainingDuration => $composableBuilder(
    column: $table.remainingDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardContentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardContentsTableTable> {
  $$DashboardContentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sectionType => $composableBuilder(
    column: $table.sectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonType => $composableBuilder(
    column: $table.lessonType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remainingDuration => $composableBuilder(
    column: $table.remainingDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardContentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardContentsTableTable> {
  $$DashboardContentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DashboardSectionType, int> get sectionType =>
      $composableBuilder(
        column: $table.sectionType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DashboardContentType, int> get lessonType =>
      $composableBuilder(
        column: $table.lessonType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remainingDuration => $composableBuilder(
    column: $table.remainingDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );
}

class $$DashboardContentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardContentsTableTable,
          DashboardContentData,
          $$DashboardContentsTableTableFilterComposer,
          $$DashboardContentsTableTableOrderingComposer,
          $$DashboardContentsTableTableAnnotationComposer,
          $$DashboardContentsTableTableCreateCompanionBuilder,
          $$DashboardContentsTableTableUpdateCompanionBuilder,
          (
            DashboardContentData,
            BaseReferences<
              _$AppDatabase,
              $DashboardContentsTableTable,
              DashboardContentData
            >,
          ),
          DashboardContentData,
          PrefetchHooks Function()
        > {
  $$DashboardContentsTableTableTableManager(
    _$AppDatabase db,
    $DashboardContentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardContentsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DashboardContentsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DashboardContentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<DashboardSectionType> sectionType = const Value.absent(),
                Value<DashboardContentType> lessonType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<String?> chapterTitle = const Value.absent(),
                Value<String?> totalDuration = const Value.absent(),
                Value<String?> remainingDuration = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<double?> progress = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardContentsTableCompanion(
                lessonId: lessonId,
                sectionType: sectionType,
                lessonType: lessonType,
                title: title,
                chapterId: chapterId,
                chapterTitle: chapterTitle,
                totalDuration: totalDuration,
                remainingDuration: remainingDuration,
                coverImage: coverImage,
                progress: progress,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                required DashboardSectionType sectionType,
                required DashboardContentType lessonType,
                required String title,
                Value<String?> chapterId = const Value.absent(),
                Value<String?> chapterTitle = const Value.absent(),
                Value<String?> totalDuration = const Value.absent(),
                Value<String?> remainingDuration = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<double?> progress = const Value.absent(),
                required int displayOrder,
                Value<int> rowid = const Value.absent(),
              }) => DashboardContentsTableCompanion.insert(
                lessonId: lessonId,
                sectionType: sectionType,
                lessonType: lessonType,
                title: title,
                chapterId: chapterId,
                chapterTitle: chapterTitle,
                totalDuration: totalDuration,
                remainingDuration: remainingDuration,
                coverImage: coverImage,
                progress: progress,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardContentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardContentsTableTable,
      DashboardContentData,
      $$DashboardContentsTableTableFilterComposer,
      $$DashboardContentsTableTableOrderingComposer,
      $$DashboardContentsTableTableAnnotationComposer,
      $$DashboardContentsTableTableCreateCompanionBuilder,
      $$DashboardContentsTableTableUpdateCompanionBuilder,
      (
        DashboardContentData,
        BaseReferences<
          _$AppDatabase,
          $DashboardContentsTableTable,
          DashboardContentData
        >,
      ),
      DashboardContentData,
      PrefetchHooks Function()
    >;
typedef $$DownloadsTableTableCreateCompanionBuilder =
    DownloadsTableCompanion Function({
      required String id,
      required String title,
      required String course,
      required String chapter,
      Value<String?> filePath,
      required BigInt sizeInBytes,
      required String downloadedDate,
      required int typeIndex,
      required int statusIndex,
      Value<int> progress,
      Value<String?> thumbnailUrl,
      Value<String?> duration,
      Value<String?> fileType,
      Value<int> rowid,
    });
typedef $$DownloadsTableTableUpdateCompanionBuilder =
    DownloadsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> course,
      Value<String> chapter,
      Value<String?> filePath,
      Value<BigInt> sizeInBytes,
      Value<String> downloadedDate,
      Value<int> typeIndex,
      Value<int> statusIndex,
      Value<int> progress,
      Value<String?> thumbnailUrl,
      Value<String?> duration,
      Value<String?> fileType,
      Value<int> rowid,
    });

class $$DownloadsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTableTable> {
  $$DownloadsTableTableFilterComposer({
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

  ColumnFilters<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadedDate => $composableBuilder(
    column: $table.downloadedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typeIndex => $composableBuilder(
    column: $table.typeIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusIndex => $composableBuilder(
    column: $table.statusIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTableTable> {
  $$DownloadsTableTableOrderingComposer({
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

  ColumnOrderings<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadedDate => $composableBuilder(
    column: $table.downloadedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typeIndex => $composableBuilder(
    column: $table.typeIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusIndex => $composableBuilder(
    column: $table.statusIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTableTable> {
  $$DownloadsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get course =>
      $composableBuilder(column: $table.course, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<BigInt> get sizeInBytes => $composableBuilder(
    column: $table.sizeInBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downloadedDate => $composableBuilder(
    column: $table.downloadedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typeIndex =>
      $composableBuilder(column: $table.typeIndex, builder: (column) => column);

  GeneratedColumn<int> get statusIndex => $composableBuilder(
    column: $table.statusIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);
}

class $$DownloadsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadsTableTable,
          DownloadsTableData,
          $$DownloadsTableTableFilterComposer,
          $$DownloadsTableTableOrderingComposer,
          $$DownloadsTableTableAnnotationComposer,
          $$DownloadsTableTableCreateCompanionBuilder,
          $$DownloadsTableTableUpdateCompanionBuilder,
          (
            DownloadsTableData,
            BaseReferences<
              _$AppDatabase,
              $DownloadsTableTable,
              DownloadsTableData
            >,
          ),
          DownloadsTableData,
          PrefetchHooks Function()
        > {
  $$DownloadsTableTableTableManager(
    _$AppDatabase db,
    $DownloadsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<String> chapter = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<BigInt> sizeInBytes = const Value.absent(),
                Value<String> downloadedDate = const Value.absent(),
                Value<int> typeIndex = const Value.absent(),
                Value<int> statusIndex = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> fileType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsTableCompanion(
                id: id,
                title: title,
                course: course,
                chapter: chapter,
                filePath: filePath,
                sizeInBytes: sizeInBytes,
                downloadedDate: downloadedDate,
                typeIndex: typeIndex,
                statusIndex: statusIndex,
                progress: progress,
                thumbnailUrl: thumbnailUrl,
                duration: duration,
                fileType: fileType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String course,
                required String chapter,
                Value<String?> filePath = const Value.absent(),
                required BigInt sizeInBytes,
                required String downloadedDate,
                required int typeIndex,
                required int statusIndex,
                Value<int> progress = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> fileType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsTableCompanion.insert(
                id: id,
                title: title,
                course: course,
                chapter: chapter,
                filePath: filePath,
                sizeInBytes: sizeInBytes,
                downloadedDate: downloadedDate,
                typeIndex: typeIndex,
                statusIndex: statusIndex,
                progress: progress,
                thumbnailUrl: thumbnailUrl,
                duration: duration,
                fileType: fileType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadsTableTable,
      DownloadsTableData,
      $$DownloadsTableTableFilterComposer,
      $$DownloadsTableTableOrderingComposer,
      $$DownloadsTableTableAnnotationComposer,
      $$DownloadsTableTableCreateCompanionBuilder,
      $$DownloadsTableTableUpdateCompanionBuilder,
      (
        DownloadsTableData,
        BaseReferences<_$AppDatabase, $DownloadsTableTable, DownloadsTableData>,
      ),
      DownloadsTableData,
      PrefetchHooks Function()
    >;
typedef $$DoubtsTableTableCreateCompanionBuilder =
    DoubtsTableCompanion Function({
      required String id,
      Value<int?> topicId,
      Value<String?> topicName,
      Value<String?> lessonId,
      required String title,
      required String content,
      required String studentName,
      Value<String?> studentAvatar,
      Value<int?> replyCount,
      required String status,
      required DateTime createdAt,
      Value<String?> createdHumanized,
      Value<String?> attachments,
      Value<int> rowid,
    });
typedef $$DoubtsTableTableUpdateCompanionBuilder =
    DoubtsTableCompanion Function({
      Value<String> id,
      Value<int?> topicId,
      Value<String?> topicName,
      Value<String?> lessonId,
      Value<String> title,
      Value<String> content,
      Value<String> studentName,
      Value<String?> studentAvatar,
      Value<int?> replyCount,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String?> createdHumanized,
      Value<String?> attachments,
      Value<int> rowid,
    });

class $$DoubtsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DoubtsTableTable> {
  $$DoubtsTableTableFilterComposer({
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

  ColumnFilters<int> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicName => $composableBuilder(
    column: $table.topicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentAvatar => $composableBuilder(
    column: $table.studentAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoubtsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DoubtsTableTable> {
  $$DoubtsTableTableOrderingComposer({
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

  ColumnOrderings<int> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicName => $composableBuilder(
    column: $table.topicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentAvatar => $composableBuilder(
    column: $table.studentAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoubtsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoubtsTableTable> {
  $$DoubtsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get topicName =>
      $composableBuilder(column: $table.topicName, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentAvatar => $composableBuilder(
    column: $table.studentAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );
}

class $$DoubtsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoubtsTableTable,
          DoubtsTableData,
          $$DoubtsTableTableFilterComposer,
          $$DoubtsTableTableOrderingComposer,
          $$DoubtsTableTableAnnotationComposer,
          $$DoubtsTableTableCreateCompanionBuilder,
          $$DoubtsTableTableUpdateCompanionBuilder,
          (
            DoubtsTableData,
            BaseReferences<_$AppDatabase, $DoubtsTableTable, DoubtsTableData>,
          ),
          DoubtsTableData,
          PrefetchHooks Function()
        > {
  $$DoubtsTableTableTableManager(_$AppDatabase db, $DoubtsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoubtsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoubtsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoubtsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> topicId = const Value.absent(),
                Value<String?> topicName = const Value.absent(),
                Value<String?> lessonId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> studentName = const Value.absent(),
                Value<String?> studentAvatar = const Value.absent(),
                Value<int?> replyCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> createdHumanized = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoubtsTableCompanion(
                id: id,
                topicId: topicId,
                topicName: topicName,
                lessonId: lessonId,
                title: title,
                content: content,
                studentName: studentName,
                studentAvatar: studentAvatar,
                replyCount: replyCount,
                status: status,
                createdAt: createdAt,
                createdHumanized: createdHumanized,
                attachments: attachments,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> topicId = const Value.absent(),
                Value<String?> topicName = const Value.absent(),
                Value<String?> lessonId = const Value.absent(),
                required String title,
                required String content,
                required String studentName,
                Value<String?> studentAvatar = const Value.absent(),
                Value<int?> replyCount = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<String?> createdHumanized = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoubtsTableCompanion.insert(
                id: id,
                topicId: topicId,
                topicName: topicName,
                lessonId: lessonId,
                title: title,
                content: content,
                studentName: studentName,
                studentAvatar: studentAvatar,
                replyCount: replyCount,
                status: status,
                createdAt: createdAt,
                createdHumanized: createdHumanized,
                attachments: attachments,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoubtsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoubtsTableTable,
      DoubtsTableData,
      $$DoubtsTableTableFilterComposer,
      $$DoubtsTableTableOrderingComposer,
      $$DoubtsTableTableAnnotationComposer,
      $$DoubtsTableTableCreateCompanionBuilder,
      $$DoubtsTableTableUpdateCompanionBuilder,
      (
        DoubtsTableData,
        BaseReferences<_$AppDatabase, $DoubtsTableTable, DoubtsTableData>,
      ),
      DoubtsTableData,
      PrefetchHooks Function()
    >;
typedef $$DoubtRepliesTableTableCreateCompanionBuilder =
    DoubtRepliesTableCompanion Function({
      required String id,
      required String doubtId,
      required String content,
      required String authorName,
      Value<String?> authorAvatar,
      Value<bool> isMentor,
      required DateTime createdAt,
      Value<String?> createdHumanized,
      Value<String?> attachments,
      Value<int> rowid,
    });
typedef $$DoubtRepliesTableTableUpdateCompanionBuilder =
    DoubtRepliesTableCompanion Function({
      Value<String> id,
      Value<String> doubtId,
      Value<String> content,
      Value<String> authorName,
      Value<String?> authorAvatar,
      Value<bool> isMentor,
      Value<DateTime> createdAt,
      Value<String?> createdHumanized,
      Value<String?> attachments,
      Value<int> rowid,
    });

class $$DoubtRepliesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DoubtRepliesTableTable> {
  $$DoubtRepliesTableTableFilterComposer({
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

  ColumnFilters<String> get doubtId => $composableBuilder(
    column: $table.doubtId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
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

  ColumnFilters<bool> get isMentor => $composableBuilder(
    column: $table.isMentor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoubtRepliesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DoubtRepliesTableTable> {
  $$DoubtRepliesTableTableOrderingComposer({
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

  ColumnOrderings<String> get doubtId => $composableBuilder(
    column: $table.doubtId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
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

  ColumnOrderings<bool> get isMentor => $composableBuilder(
    column: $table.isMentor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoubtRepliesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoubtRepliesTableTable> {
  $$DoubtRepliesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doubtId =>
      $composableBuilder(column: $table.doubtId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMentor =>
      $composableBuilder(column: $table.isMentor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdHumanized => $composableBuilder(
    column: $table.createdHumanized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );
}

class $$DoubtRepliesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoubtRepliesTableTable,
          DoubtRepliesTableData,
          $$DoubtRepliesTableTableFilterComposer,
          $$DoubtRepliesTableTableOrderingComposer,
          $$DoubtRepliesTableTableAnnotationComposer,
          $$DoubtRepliesTableTableCreateCompanionBuilder,
          $$DoubtRepliesTableTableUpdateCompanionBuilder,
          (
            DoubtRepliesTableData,
            BaseReferences<
              _$AppDatabase,
              $DoubtRepliesTableTable,
              DoubtRepliesTableData
            >,
          ),
          DoubtRepliesTableData,
          PrefetchHooks Function()
        > {
  $$DoubtRepliesTableTableTableManager(
    _$AppDatabase db,
    $DoubtRepliesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoubtRepliesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoubtRepliesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoubtRepliesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> doubtId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<bool> isMentor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> createdHumanized = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoubtRepliesTableCompanion(
                id: id,
                doubtId: doubtId,
                content: content,
                authorName: authorName,
                authorAvatar: authorAvatar,
                isMentor: isMentor,
                createdAt: createdAt,
                createdHumanized: createdHumanized,
                attachments: attachments,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String doubtId,
                required String content,
                required String authorName,
                Value<String?> authorAvatar = const Value.absent(),
                Value<bool> isMentor = const Value.absent(),
                required DateTime createdAt,
                Value<String?> createdHumanized = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoubtRepliesTableCompanion.insert(
                id: id,
                doubtId: doubtId,
                content: content,
                authorName: authorName,
                authorAvatar: authorAvatar,
                isMentor: isMentor,
                createdAt: createdAt,
                createdHumanized: createdHumanized,
                attachments: attachments,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoubtRepliesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoubtRepliesTableTable,
      DoubtRepliesTableData,
      $$DoubtRepliesTableTableFilterComposer,
      $$DoubtRepliesTableTableOrderingComposer,
      $$DoubtRepliesTableTableAnnotationComposer,
      $$DoubtRepliesTableTableCreateCompanionBuilder,
      $$DoubtRepliesTableTableUpdateCompanionBuilder,
      (
        DoubtRepliesTableData,
        BaseReferences<
          _$AppDatabase,
          $DoubtRepliesTableTable,
          DoubtRepliesTableData
        >,
      ),
      DoubtRepliesTableData,
      PrefetchHooks Function()
    >;
typedef $$DoubtTopicsTableTableCreateCompanionBuilder =
    DoubtTopicsTableCompanion Function({
      Value<int> id,
      required String title,
      Value<int?> parentId,
      Value<bool> hasChildren,
    });
typedef $$DoubtTopicsTableTableUpdateCompanionBuilder =
    DoubtTopicsTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int?> parentId,
      Value<bool> hasChildren,
    });

class $$DoubtTopicsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DoubtTopicsTableTable> {
  $$DoubtTopicsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasChildren => $composableBuilder(
    column: $table.hasChildren,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoubtTopicsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DoubtTopicsTableTable> {
  $$DoubtTopicsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasChildren => $composableBuilder(
    column: $table.hasChildren,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoubtTopicsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoubtTopicsTableTable> {
  $$DoubtTopicsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<bool> get hasChildren => $composableBuilder(
    column: $table.hasChildren,
    builder: (column) => column,
  );
}

class $$DoubtTopicsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoubtTopicsTableTable,
          DoubtTopicsTableData,
          $$DoubtTopicsTableTableFilterComposer,
          $$DoubtTopicsTableTableOrderingComposer,
          $$DoubtTopicsTableTableAnnotationComposer,
          $$DoubtTopicsTableTableCreateCompanionBuilder,
          $$DoubtTopicsTableTableUpdateCompanionBuilder,
          (
            DoubtTopicsTableData,
            BaseReferences<
              _$AppDatabase,
              $DoubtTopicsTableTable,
              DoubtTopicsTableData
            >,
          ),
          DoubtTopicsTableData,
          PrefetchHooks Function()
        > {
  $$DoubtTopicsTableTableTableManager(
    _$AppDatabase db,
    $DoubtTopicsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoubtTopicsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoubtTopicsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoubtTopicsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<bool> hasChildren = const Value.absent(),
              }) => DoubtTopicsTableCompanion(
                id: id,
                title: title,
                parentId: parentId,
                hasChildren: hasChildren,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<int?> parentId = const Value.absent(),
                Value<bool> hasChildren = const Value.absent(),
              }) => DoubtTopicsTableCompanion.insert(
                id: id,
                title: title,
                parentId: parentId,
                hasChildren: hasChildren,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoubtTopicsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoubtTopicsTableTable,
      DoubtTopicsTableData,
      $$DoubtTopicsTableTableFilterComposer,
      $$DoubtTopicsTableTableOrderingComposer,
      $$DoubtTopicsTableTableAnnotationComposer,
      $$DoubtTopicsTableTableCreateCompanionBuilder,
      $$DoubtTopicsTableTableUpdateCompanionBuilder,
      (
        DoubtTopicsTableData,
        BaseReferences<
          _$AppDatabase,
          $DoubtTopicsTableTable,
          DoubtTopicsTableData
        >,
      ),
      DoubtTopicsTableData,
      PrefetchHooks Function()
    >;
typedef $$BookmarkFoldersTableTableCreateCompanionBuilder =
    BookmarkFoldersTableCompanion Function({
      Value<int> id,
      required String name,
      Value<int> bookmarksCount,
      Value<int?> userId,
    });
typedef $$BookmarkFoldersTableTableUpdateCompanionBuilder =
    BookmarkFoldersTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> bookmarksCount,
      Value<int?> userId,
    });

final class $$BookmarkFoldersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BookmarkFoldersTableTable,
          BookmarkFoldersTableData
        > {
  $$BookmarkFoldersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $BookmarkItemsTableTable,
    List<BookmarkItemsTableData>
  >
  _bookmarkItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bookmarkItemsTable,
        aliasName: $_aliasNameGenerator(
          db.bookmarkFoldersTable.id,
          db.bookmarkItemsTable.folderId,
        ),
      );

  $$BookmarkItemsTableTableProcessedTableManager get bookmarkItemsTableRefs {
    final manager = $$BookmarkItemsTableTableTableManager(
      $_db,
      $_db.bookmarkItemsTable,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookmarkItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BookmarkFoldersTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkFoldersTableTable> {
  $$BookmarkFoldersTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bookmarkItemsTableRefs(
    Expression<bool> Function($$BookmarkItemsTableTableFilterComposer f) f,
  ) {
    final $$BookmarkItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkItemsTable,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.bookmarkItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BookmarkFoldersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkFoldersTableTable> {
  $$BookmarkFoldersTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarkFoldersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkFoldersTableTable> {
  $$BookmarkFoldersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  Expression<T> bookmarkItemsTableRefs<T extends Object>(
    Expression<T> Function($$BookmarkItemsTableTableAnnotationComposer a) f,
  ) {
    final $$BookmarkItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bookmarkItemsTable,
          getReferencedColumn: (t) => t.folderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookmarkItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.bookmarkItemsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BookmarkFoldersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkFoldersTableTable,
          BookmarkFoldersTableData,
          $$BookmarkFoldersTableTableFilterComposer,
          $$BookmarkFoldersTableTableOrderingComposer,
          $$BookmarkFoldersTableTableAnnotationComposer,
          $$BookmarkFoldersTableTableCreateCompanionBuilder,
          $$BookmarkFoldersTableTableUpdateCompanionBuilder,
          (BookmarkFoldersTableData, $$BookmarkFoldersTableTableReferences),
          BookmarkFoldersTableData,
          PrefetchHooks Function({bool bookmarkItemsTableRefs})
        > {
  $$BookmarkFoldersTableTableTableManager(
    _$AppDatabase db,
    $BookmarkFoldersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkFoldersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkFoldersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BookmarkFoldersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> bookmarksCount = const Value.absent(),
                Value<int?> userId = const Value.absent(),
              }) => BookmarkFoldersTableCompanion(
                id: id,
                name: name,
                bookmarksCount: bookmarksCount,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> bookmarksCount = const Value.absent(),
                Value<int?> userId = const Value.absent(),
              }) => BookmarkFoldersTableCompanion.insert(
                id: id,
                name: name,
                bookmarksCount: bookmarksCount,
                userId: userId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookmarkFoldersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookmarkItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bookmarkItemsTableRefs) db.bookmarkItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookmarkItemsTableRefs)
                    await $_getPrefetchedData<
                      BookmarkFoldersTableData,
                      $BookmarkFoldersTableTable,
                      BookmarkItemsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$BookmarkFoldersTableTableReferences
                          ._bookmarkItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BookmarkFoldersTableTableReferences(
                            db,
                            table,
                            p0,
                          ).bookmarkItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BookmarkFoldersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkFoldersTableTable,
      BookmarkFoldersTableData,
      $$BookmarkFoldersTableTableFilterComposer,
      $$BookmarkFoldersTableTableOrderingComposer,
      $$BookmarkFoldersTableTableAnnotationComposer,
      $$BookmarkFoldersTableTableCreateCompanionBuilder,
      $$BookmarkFoldersTableTableUpdateCompanionBuilder,
      (BookmarkFoldersTableData, $$BookmarkFoldersTableTableReferences),
      BookmarkFoldersTableData,
      PrefetchHooks Function({bool bookmarkItemsTableRefs})
    >;
typedef $$BookmarkItemsTableTableCreateCompanionBuilder =
    BookmarkItemsTableCompanion Function({
      Value<int> id,
      Value<int?> folderId,
      Value<String?> folderName,
      required int lessonId,
      Value<String?> bookmarkType,
    });
typedef $$BookmarkItemsTableTableUpdateCompanionBuilder =
    BookmarkItemsTableCompanion Function({
      Value<int> id,
      Value<int?> folderId,
      Value<String?> folderName,
      Value<int> lessonId,
      Value<String?> bookmarkType,
    });

final class $$BookmarkItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BookmarkItemsTableTable,
          BookmarkItemsTableData
        > {
  $$BookmarkItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BookmarkFoldersTableTable _folderIdTable(_$AppDatabase db) =>
      db.bookmarkFoldersTable.createAlias(
        $_aliasNameGenerator(
          db.bookmarkItemsTable.folderId,
          db.bookmarkFoldersTable.id,
        ),
      );

  $$BookmarkFoldersTableTableProcessedTableManager? get folderId {
    final $_column = $_itemColumn<int>('folder_id');
    if ($_column == null) return null;
    final manager = $$BookmarkFoldersTableTableTableManager(
      $_db,
      $_db.bookmarkFoldersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarkItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkItemsTableTable> {
  $$BookmarkItemsTableTableFilterComposer({
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

  ColumnFilters<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookmarkType => $composableBuilder(
    column: $table.bookmarkType,
    builder: (column) => ColumnFilters(column),
  );

  $$BookmarkFoldersTableTableFilterComposer get folderId {
    final $$BookmarkFoldersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.bookmarkFoldersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkFoldersTableTableFilterComposer(
            $db: $db,
            $table: $db.bookmarkFoldersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarkItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkItemsTableTable> {
  $$BookmarkItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookmarkType => $composableBuilder(
    column: $table.bookmarkType,
    builder: (column) => ColumnOrderings(column),
  );

  $$BookmarkFoldersTableTableOrderingComposer get folderId {
    final $$BookmarkFoldersTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.folderId,
          referencedTable: $db.bookmarkFoldersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookmarkFoldersTableTableOrderingComposer(
                $db: $db,
                $table: $db.bookmarkFoldersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BookmarkItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkItemsTableTable> {
  $$BookmarkItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folderName => $composableBuilder(
    column: $table.folderName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get bookmarkType => $composableBuilder(
    column: $table.bookmarkType,
    builder: (column) => column,
  );

  $$BookmarkFoldersTableTableAnnotationComposer get folderId {
    final $$BookmarkFoldersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.folderId,
          referencedTable: $db.bookmarkFoldersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookmarkFoldersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.bookmarkFoldersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BookmarkItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkItemsTableTable,
          BookmarkItemsTableData,
          $$BookmarkItemsTableTableFilterComposer,
          $$BookmarkItemsTableTableOrderingComposer,
          $$BookmarkItemsTableTableAnnotationComposer,
          $$BookmarkItemsTableTableCreateCompanionBuilder,
          $$BookmarkItemsTableTableUpdateCompanionBuilder,
          (BookmarkItemsTableData, $$BookmarkItemsTableTableReferences),
          BookmarkItemsTableData,
          PrefetchHooks Function({bool folderId})
        > {
  $$BookmarkItemsTableTableTableManager(
    _$AppDatabase db,
    $BookmarkItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarkItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> folderId = const Value.absent(),
                Value<String?> folderName = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String?> bookmarkType = const Value.absent(),
              }) => BookmarkItemsTableCompanion(
                id: id,
                folderId: folderId,
                folderName: folderName,
                lessonId: lessonId,
                bookmarkType: bookmarkType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> folderId = const Value.absent(),
                Value<String?> folderName = const Value.absent(),
                required int lessonId,
                Value<String?> bookmarkType = const Value.absent(),
              }) => BookmarkItemsTableCompanion.insert(
                id: id,
                folderId: folderId,
                folderName: folderName,
                lessonId: lessonId,
                bookmarkType: bookmarkType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookmarkItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable:
                                    $$BookmarkItemsTableTableReferences
                                        ._folderIdTable(db),
                                referencedColumn:
                                    $$BookmarkItemsTableTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarkItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkItemsTableTable,
      BookmarkItemsTableData,
      $$BookmarkItemsTableTableFilterComposer,
      $$BookmarkItemsTableTableOrderingComposer,
      $$BookmarkItemsTableTableAnnotationComposer,
      $$BookmarkItemsTableTableCreateCompanionBuilder,
      $$BookmarkItemsTableTableUpdateCompanionBuilder,
      (BookmarkItemsTableData, $$BookmarkItemsTableTableReferences),
      BookmarkItemsTableData,
      PrefetchHooks Function({bool folderId})
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
  $$DashboardBannersTableTableTableManager get dashboardBannersTable =>
      $$DashboardBannersTableTableTableManager(_db, _db.dashboardBannersTable);
  $$WeeklyLeaderboardTableTableTableManager get weeklyLeaderboardTable =>
      $$WeeklyLeaderboardTableTableTableManager(
        _db,
        _db.weeklyLeaderboardTable,
      );
  $$MonthlyLeaderboardTableTableTableManager get monthlyLeaderboardTable =>
      $$MonthlyLeaderboardTableTableTableManager(
        _db,
        _db.monthlyLeaderboardTable,
      );
  $$AllTimeLeaderboardTableTableTableManager get allTimeLeaderboardTable =>
      $$AllTimeLeaderboardTableTableTableManager(
        _db,
        _db.allTimeLeaderboardTable,
      );
  $$DashboardContentsTableTableTableManager get dashboardContentsTable =>
      $$DashboardContentsTableTableTableManager(
        _db,
        _db.dashboardContentsTable,
      );
  $$DownloadsTableTableTableManager get downloadsTable =>
      $$DownloadsTableTableTableManager(_db, _db.downloadsTable);
  $$DoubtsTableTableTableManager get doubtsTable =>
      $$DoubtsTableTableTableManager(_db, _db.doubtsTable);
  $$DoubtRepliesTableTableTableManager get doubtRepliesTable =>
      $$DoubtRepliesTableTableTableManager(_db, _db.doubtRepliesTable);
  $$DoubtTopicsTableTableTableManager get doubtTopicsTable =>
      $$DoubtTopicsTableTableTableManager(_db, _db.doubtTopicsTable);
  $$BookmarkFoldersTableTableTableManager get bookmarkFoldersTable =>
      $$BookmarkFoldersTableTableTableManager(_db, _db.bookmarkFoldersTable);
  $$BookmarkItemsTableTableTableManager get bookmarkItemsTable =>
      $$BookmarkItemsTableTableTableManager(_db, _db.bookmarkItemsTable);
}
