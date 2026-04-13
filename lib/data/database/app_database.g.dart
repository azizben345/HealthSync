// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyRecordsTable extends DailyRecords
    with TableInfo<$DailyRecordsTable, DailyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaryNoteMeta = const VerificationMeta(
    'diaryNote',
  );
  @override
  late final GeneratedColumn<String> diaryNote = GeneratedColumn<String>(
    'diary_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarStateMeta = const VerificationMeta(
    'avatarState',
  );
  @override
  late final GeneratedColumn<String> avatarState = GeneratedColumn<String>(
    'avatar_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietQualityMeta = const VerificationMeta(
    'dietQuality',
  );
  @override
  late final GeneratedColumn<String> dietQuality = GeneratedColumn<String>(
    'diet_quality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Normal'),
  );
  static const VerificationMeta _workoutTypeMeta = const VerificationMeta(
    'workoutType',
  );
  @override
  late final GeneratedColumn<String> workoutType = GeneratedColumn<String>(
    'workout_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Rest'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    steps,
    sleepHours,
    diaryNote,
    avatarState,
    dietQuality,
    workoutType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepHoursMeta);
    }
    if (data.containsKey('diary_note')) {
      context.handle(
        _diaryNoteMeta,
        diaryNote.isAcceptableOrUnknown(data['diary_note']!, _diaryNoteMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryNoteMeta);
    }
    if (data.containsKey('avatar_state')) {
      context.handle(
        _avatarStateMeta,
        avatarState.isAcceptableOrUnknown(
          data['avatar_state']!,
          _avatarStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avatarStateMeta);
    }
    if (data.containsKey('diet_quality')) {
      context.handle(
        _dietQualityMeta,
        dietQuality.isAcceptableOrUnknown(
          data['diet_quality']!,
          _dietQualityMeta,
        ),
      );
    }
    if (data.containsKey('workout_type')) {
      context.handle(
        _workoutTypeMeta,
        workoutType.isAcceptableOrUnknown(
          data['workout_type']!,
          _workoutTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      )!,
      diaryNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diary_note'],
      )!,
      avatarState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_state'],
      )!,
      dietQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_quality'],
      )!,
      workoutType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_type'],
      )!,
    );
  }

  @override
  $DailyRecordsTable createAlias(String alias) {
    return $DailyRecordsTable(attachedDatabase, alias);
  }
}

class DailyRecord extends DataClass implements Insertable<DailyRecord> {
  final int id;
  final DateTime date;
  final int steps;
  final double sleepHours;
  final String diaryNote;
  final String avatarState;
  final String dietQuality;
  final String workoutType;
  const DailyRecord({
    required this.id,
    required this.date,
    required this.steps,
    required this.sleepHours,
    required this.diaryNote,
    required this.avatarState,
    required this.dietQuality,
    required this.workoutType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['steps'] = Variable<int>(steps);
    map['sleep_hours'] = Variable<double>(sleepHours);
    map['diary_note'] = Variable<String>(diaryNote);
    map['avatar_state'] = Variable<String>(avatarState);
    map['diet_quality'] = Variable<String>(dietQuality);
    map['workout_type'] = Variable<String>(workoutType);
    return map;
  }

  DailyRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordsCompanion(
      id: Value(id),
      date: Value(date),
      steps: Value(steps),
      sleepHours: Value(sleepHours),
      diaryNote: Value(diaryNote),
      avatarState: Value(avatarState),
      dietQuality: Value(dietQuality),
      workoutType: Value(workoutType),
    );
  }

  factory DailyRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      steps: serializer.fromJson<int>(json['steps']),
      sleepHours: serializer.fromJson<double>(json['sleepHours']),
      diaryNote: serializer.fromJson<String>(json['diaryNote']),
      avatarState: serializer.fromJson<String>(json['avatarState']),
      dietQuality: serializer.fromJson<String>(json['dietQuality']),
      workoutType: serializer.fromJson<String>(json['workoutType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'steps': serializer.toJson<int>(steps),
      'sleepHours': serializer.toJson<double>(sleepHours),
      'diaryNote': serializer.toJson<String>(diaryNote),
      'avatarState': serializer.toJson<String>(avatarState),
      'dietQuality': serializer.toJson<String>(dietQuality),
      'workoutType': serializer.toJson<String>(workoutType),
    };
  }

  DailyRecord copyWith({
    int? id,
    DateTime? date,
    int? steps,
    double? sleepHours,
    String? diaryNote,
    String? avatarState,
    String? dietQuality,
    String? workoutType,
  }) => DailyRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    steps: steps ?? this.steps,
    sleepHours: sleepHours ?? this.sleepHours,
    diaryNote: diaryNote ?? this.diaryNote,
    avatarState: avatarState ?? this.avatarState,
    dietQuality: dietQuality ?? this.dietQuality,
    workoutType: workoutType ?? this.workoutType,
  );
  DailyRecord copyWithCompanion(DailyRecordsCompanion data) {
    return DailyRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      diaryNote: data.diaryNote.present ? data.diaryNote.value : this.diaryNote,
      avatarState: data.avatarState.present
          ? data.avatarState.value
          : this.avatarState,
      dietQuality: data.dietQuality.present
          ? data.dietQuality.value
          : this.dietQuality,
      workoutType: data.workoutType.present
          ? data.workoutType.value
          : this.workoutType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('diaryNote: $diaryNote, ')
          ..write('avatarState: $avatarState, ')
          ..write('dietQuality: $dietQuality, ')
          ..write('workoutType: $workoutType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    steps,
    sleepHours,
    diaryNote,
    avatarState,
    dietQuality,
    workoutType,
  );

  // String get diet => null;

  // String get workout => null;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.sleepHours == this.sleepHours &&
          other.diaryNote == this.diaryNote &&
          other.avatarState == this.avatarState &&
          other.dietQuality == this.dietQuality &&
          other.workoutType == this.workoutType);
}

class DailyRecordsCompanion extends UpdateCompanion<DailyRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> steps;
  final Value<double> sleepHours;
  final Value<String> diaryNote;
  final Value<String> avatarState;
  final Value<String> dietQuality;
  final Value<String> workoutType;
  const DailyRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.diaryNote = const Value.absent(),
    this.avatarState = const Value.absent(),
    this.dietQuality = const Value.absent(),
    this.workoutType = const Value.absent(),
  });
  DailyRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    required int steps,
    required double sleepHours,
    required String diaryNote,
    required String avatarState,
    this.dietQuality = const Value.absent(),
    this.workoutType = const Value.absent(),
  }) : steps = Value(steps),
       sleepHours = Value(sleepHours),
       diaryNote = Value(diaryNote),
       avatarState = Value(avatarState);
  static Insertable<DailyRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? steps,
    Expression<double>? sleepHours,
    Expression<String>? diaryNote,
    Expression<String>? avatarState,
    Expression<String>? dietQuality,
    Expression<String>? workoutType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (diaryNote != null) 'diary_note': diaryNote,
      if (avatarState != null) 'avatar_state': avatarState,
      if (dietQuality != null) 'diet_quality': dietQuality,
      if (workoutType != null) 'workout_type': workoutType,
    });
  }

  DailyRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? steps,
    Value<double>? sleepHours,
    Value<String>? diaryNote,
    Value<String>? avatarState,
    Value<String>? dietQuality,
    Value<String>? workoutType,
  }) {
    return DailyRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      sleepHours: sleepHours ?? this.sleepHours,
      diaryNote: diaryNote ?? this.diaryNote,
      avatarState: avatarState ?? this.avatarState,
      dietQuality: dietQuality ?? this.dietQuality,
      workoutType: workoutType ?? this.workoutType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (diaryNote.present) {
      map['diary_note'] = Variable<String>(diaryNote.value);
    }
    if (avatarState.present) {
      map['avatar_state'] = Variable<String>(avatarState.value);
    }
    if (dietQuality.present) {
      map['diet_quality'] = Variable<String>(dietQuality.value);
    }
    if (workoutType.present) {
      map['workout_type'] = Variable<String>(workoutType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('diaryNote: $diaryNote, ')
          ..write('avatarState: $avatarState, ')
          ..write('dietQuality: $dietQuality, ')
          ..write('workoutType: $workoutType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dailyRecords];
}

typedef $$DailyRecordsTableCreateCompanionBuilder =
    DailyRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      required int steps,
      required double sleepHours,
      required String diaryNote,
      required String avatarState,
      Value<String> dietQuality,
      Value<String> workoutType,
    });
typedef $$DailyRecordsTableUpdateCompanionBuilder =
    DailyRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> steps,
      Value<double> sleepHours,
      Value<String> diaryNote,
      Value<String> avatarState,
      Value<String> dietQuality,
      Value<String> workoutType,
    });

class $$DailyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diaryNote => $composableBuilder(
    column: $table.diaryNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarState => $composableBuilder(
    column: $table.avatarState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietQuality => $composableBuilder(
    column: $table.dietQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diaryNote => $composableBuilder(
    column: $table.diaryNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarState => $composableBuilder(
    column: $table.avatarState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietQuality => $composableBuilder(
    column: $table.dietQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diaryNote =>
      $composableBuilder(column: $table.diaryNote, builder: (column) => column);

  GeneratedColumn<String> get avatarState => $composableBuilder(
    column: $table.avatarState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietQuality => $composableBuilder(
    column: $table.dietQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutType => $composableBuilder(
    column: $table.workoutType,
    builder: (column) => column,
  );
}

class $$DailyRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyRecordsTable,
          DailyRecord,
          $$DailyRecordsTableFilterComposer,
          $$DailyRecordsTableOrderingComposer,
          $$DailyRecordsTableAnnotationComposer,
          $$DailyRecordsTableCreateCompanionBuilder,
          $$DailyRecordsTableUpdateCompanionBuilder,
          (
            DailyRecord,
            BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>,
          ),
          DailyRecord,
          PrefetchHooks Function()
        > {
  $$DailyRecordsTableTableManager(_$AppDatabase db, $DailyRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<double> sleepHours = const Value.absent(),
                Value<String> diaryNote = const Value.absent(),
                Value<String> avatarState = const Value.absent(),
                Value<String> dietQuality = const Value.absent(),
                Value<String> workoutType = const Value.absent(),
              }) => DailyRecordsCompanion(
                id: id,
                date: date,
                steps: steps,
                sleepHours: sleepHours,
                diaryNote: diaryNote,
                avatarState: avatarState,
                dietQuality: dietQuality,
                workoutType: workoutType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                required int steps,
                required double sleepHours,
                required String diaryNote,
                required String avatarState,
                Value<String> dietQuality = const Value.absent(),
                Value<String> workoutType = const Value.absent(),
              }) => DailyRecordsCompanion.insert(
                id: id,
                date: date,
                steps: steps,
                sleepHours: sleepHours,
                diaryNote: diaryNote,
                avatarState: avatarState,
                dietQuality: dietQuality,
                workoutType: workoutType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyRecordsTable,
      DailyRecord,
      $$DailyRecordsTableFilterComposer,
      $$DailyRecordsTableOrderingComposer,
      $$DailyRecordsTableAnnotationComposer,
      $$DailyRecordsTableCreateCompanionBuilder,
      $$DailyRecordsTableUpdateCompanionBuilder,
      (
        DailyRecord,
        BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>,
      ),
      DailyRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
}
