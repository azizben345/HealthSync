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
  static const VerificationMeta _coachMessageMeta = const VerificationMeta(
    'coachMessage',
  );
  @override
  late final GeneratedColumn<String> coachMessage = GeneratedColumn<String>(
    'coach_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    coachMessage,
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
    if (data.containsKey('coach_message')) {
      context.handle(
        _coachMessageMeta,
        coachMessage.isAcceptableOrUnknown(
          data['coach_message']!,
          _coachMessageMeta,
        ),
      );
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
      coachMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coach_message'],
      ),
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
  final String? coachMessage;
  final String dietQuality;
  final String workoutType;
  const DailyRecord({
    required this.id,
    required this.date,
    required this.steps,
    required this.sleepHours,
    required this.diaryNote,
    required this.avatarState,
    this.coachMessage,
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
    if (!nullToAbsent || coachMessage != null) {
      map['coach_message'] = Variable<String>(coachMessage);
    }
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
      coachMessage: coachMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(coachMessage),
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
      coachMessage: serializer.fromJson<String?>(json['coachMessage']),
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
      'coachMessage': serializer.toJson<String?>(coachMessage),
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
    Value<String?> coachMessage = const Value.absent(),
    String? dietQuality,
    String? workoutType,
  }) => DailyRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    steps: steps ?? this.steps,
    sleepHours: sleepHours ?? this.sleepHours,
    diaryNote: diaryNote ?? this.diaryNote,
    avatarState: avatarState ?? this.avatarState,
    coachMessage: coachMessage.present ? coachMessage.value : this.coachMessage,
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
      coachMessage: data.coachMessage.present
          ? data.coachMessage.value
          : this.coachMessage,
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
          ..write('coachMessage: $coachMessage, ')
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
    coachMessage,
    dietQuality,
    workoutType,
  );
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
          other.coachMessage == this.coachMessage &&
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
  final Value<String?> coachMessage;
  final Value<String> dietQuality;
  final Value<String> workoutType;
  const DailyRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.diaryNote = const Value.absent(),
    this.avatarState = const Value.absent(),
    this.coachMessage = const Value.absent(),
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
    this.coachMessage = const Value.absent(),
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
    Expression<String>? coachMessage,
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
      if (coachMessage != null) 'coach_message': coachMessage,
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
    Value<String?>? coachMessage,
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
      coachMessage: coachMessage ?? this.coachMessage,
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
    if (coachMessage.present) {
      map['coach_message'] = Variable<String>(coachMessage.value);
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
          ..write('coachMessage: $coachMessage, ')
          ..write('dietQuality: $dietQuality, ')
          ..write('workoutType: $workoutType')
          ..write(')'))
        .toString();
  }
}

class $ChatHistoryTable extends ChatHistory
    with TableInfo<$ChatHistoryTable, ChatHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _textMessageMeta = const VerificationMeta(
    'textMessage',
  );
  @override
  late final GeneratedColumn<String> textMessage = GeneratedColumn<String>(
    'text_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUserMeta = const VerificationMeta('isUser');
  @override
  late final GeneratedColumn<bool> isUser = GeneratedColumn<bool>(
    'is_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, textMessage, isUser, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_message')) {
      context.handle(
        _textMessageMeta,
        textMessage.isAcceptableOrUnknown(
          data['text_message']!,
          _textMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textMessageMeta);
    }
    if (data.containsKey('is_user')) {
      context.handle(
        _isUserMeta,
        isUser.isAcceptableOrUnknown(data['is_user']!, _isUserMeta),
      );
    } else if (isInserting) {
      context.missing(_isUserMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      textMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_message'],
      )!,
      isUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ChatHistoryTable createAlias(String alias) {
    return $ChatHistoryTable(attachedDatabase, alias);
  }
}

class ChatHistoryData extends DataClass implements Insertable<ChatHistoryData> {
  final int id;
  final String textMessage;
  final bool isUser;
  final DateTime timestamp;
  const ChatHistoryData({
    required this.id,
    required this.textMessage,
    required this.isUser,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_message'] = Variable<String>(textMessage);
    map['is_user'] = Variable<bool>(isUser);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatHistoryCompanion toCompanion(bool nullToAbsent) {
    return ChatHistoryCompanion(
      id: Value(id),
      textMessage: Value(textMessage),
      isUser: Value(isUser),
      timestamp: Value(timestamp),
    );
  }

  factory ChatHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatHistoryData(
      id: serializer.fromJson<int>(json['id']),
      textMessage: serializer.fromJson<String>(json['textMessage']),
      isUser: serializer.fromJson<bool>(json['isUser']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textMessage': serializer.toJson<String>(textMessage),
      'isUser': serializer.toJson<bool>(isUser),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatHistoryData copyWith({
    int? id,
    String? textMessage,
    bool? isUser,
    DateTime? timestamp,
  }) => ChatHistoryData(
    id: id ?? this.id,
    textMessage: textMessage ?? this.textMessage,
    isUser: isUser ?? this.isUser,
    timestamp: timestamp ?? this.timestamp,
  );
  ChatHistoryData copyWithCompanion(ChatHistoryCompanion data) {
    return ChatHistoryData(
      id: data.id.present ? data.id.value : this.id,
      textMessage: data.textMessage.present
          ? data.textMessage.value
          : this.textMessage,
      isUser: data.isUser.present ? data.isUser.value : this.isUser,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatHistoryData(')
          ..write('id: $id, ')
          ..write('textMessage: $textMessage, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textMessage, isUser, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatHistoryData &&
          other.id == this.id &&
          other.textMessage == this.textMessage &&
          other.isUser == this.isUser &&
          other.timestamp == this.timestamp);
}

class ChatHistoryCompanion extends UpdateCompanion<ChatHistoryData> {
  final Value<int> id;
  final Value<String> textMessage;
  final Value<bool> isUser;
  final Value<DateTime> timestamp;
  const ChatHistoryCompanion({
    this.id = const Value.absent(),
    this.textMessage = const Value.absent(),
    this.isUser = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ChatHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String textMessage,
    required bool isUser,
    this.timestamp = const Value.absent(),
  }) : textMessage = Value(textMessage),
       isUser = Value(isUser);
  static Insertable<ChatHistoryData> custom({
    Expression<int>? id,
    Expression<String>? textMessage,
    Expression<bool>? isUser,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textMessage != null) 'text_message': textMessage,
      if (isUser != null) 'is_user': isUser,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ChatHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? textMessage,
    Value<bool>? isUser,
    Value<DateTime>? timestamp,
  }) {
    return ChatHistoryCompanion(
      id: id ?? this.id,
      textMessage: textMessage ?? this.textMessage,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textMessage.present) {
      map['text_message'] = Variable<String>(textMessage.value);
    }
    if (isUser.present) {
      map['is_user'] = Variable<bool>(isUser.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatHistoryCompanion(')
          ..write('id: $id, ')
          ..write('textMessage: $textMessage, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dailyRecordIdMeta = const VerificationMeta(
    'dailyRecordId',
  );
  @override
  late final GeneratedColumn<int> dailyRecordId = GeneratedColumn<int>(
    'daily_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_records (id)',
    ),
  );
  static const VerificationMeta _activityNameMeta = const VerificationMeta(
    'activityName',
  );
  @override
  late final GeneratedColumn<String> activityName = GeneratedColumn<String>(
    'activity_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesBurnedMeta = const VerificationMeta(
    'caloriesBurned',
  );
  @override
  late final GeneratedColumn<int> caloriesBurned = GeneratedColumn<int>(
    'calories_burned',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyRecordId,
    activityName,
    durationMinutes,
    caloriesBurned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_record_id')) {
      context.handle(
        _dailyRecordIdMeta,
        dailyRecordId.isAcceptableOrUnknown(
          data['daily_record_id']!,
          _dailyRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyRecordIdMeta);
    }
    if (data.containsKey('activity_name')) {
      context.handle(
        _activityNameMeta,
        activityName.isAcceptableOrUnknown(
          data['activity_name']!,
          _activityNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityNameMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
        _caloriesBurnedMeta,
        caloriesBurned.isAcceptableOrUnknown(
          data['calories_burned']!,
          _caloriesBurnedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_record_id'],
      )!,
      activityName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_name'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      caloriesBurned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_burned'],
      ),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final int dailyRecordId;
  final String activityName;
  final int durationMinutes;
  final int? caloriesBurned;
  const Workout({
    required this.id,
    required this.dailyRecordId,
    required this.activityName,
    required this.durationMinutes,
    this.caloriesBurned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_record_id'] = Variable<int>(dailyRecordId);
    map['activity_name'] = Variable<String>(activityName);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || caloriesBurned != null) {
      map['calories_burned'] = Variable<int>(caloriesBurned);
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      dailyRecordId: Value(dailyRecordId),
      activityName: Value(activityName),
      durationMinutes: Value(durationMinutes),
      caloriesBurned: caloriesBurned == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesBurned),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      dailyRecordId: serializer.fromJson<int>(json['dailyRecordId']),
      activityName: serializer.fromJson<String>(json['activityName']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      caloriesBurned: serializer.fromJson<int?>(json['caloriesBurned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyRecordId': serializer.toJson<int>(dailyRecordId),
      'activityName': serializer.toJson<String>(activityName),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'caloriesBurned': serializer.toJson<int?>(caloriesBurned),
    };
  }

  Workout copyWith({
    int? id,
    int? dailyRecordId,
    String? activityName,
    int? durationMinutes,
    Value<int?> caloriesBurned = const Value.absent(),
  }) => Workout(
    id: id ?? this.id,
    dailyRecordId: dailyRecordId ?? this.dailyRecordId,
    activityName: activityName ?? this.activityName,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    caloriesBurned: caloriesBurned.present
        ? caloriesBurned.value
        : this.caloriesBurned,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      dailyRecordId: data.dailyRecordId.present
          ? data.dailyRecordId.value
          : this.dailyRecordId,
      activityName: data.activityName.present
          ? data.activityName.value
          : this.activityName,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      caloriesBurned: data.caloriesBurned.present
          ? data.caloriesBurned.value
          : this.caloriesBurned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('activityName: $activityName, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('caloriesBurned: $caloriesBurned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyRecordId,
    activityName,
    durationMinutes,
    caloriesBurned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.dailyRecordId == this.dailyRecordId &&
          other.activityName == this.activityName &&
          other.durationMinutes == this.durationMinutes &&
          other.caloriesBurned == this.caloriesBurned);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<int> dailyRecordId;
  final Value<String> activityName;
  final Value<int> durationMinutes;
  final Value<int?> caloriesBurned;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.dailyRecordId = const Value.absent(),
    this.activityName = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int dailyRecordId,
    required String activityName,
    required int durationMinutes,
    this.caloriesBurned = const Value.absent(),
  }) : dailyRecordId = Value(dailyRecordId),
       activityName = Value(activityName),
       durationMinutes = Value(durationMinutes);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<int>? dailyRecordId,
    Expression<String>? activityName,
    Expression<int>? durationMinutes,
    Expression<int>? caloriesBurned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyRecordId != null) 'daily_record_id': dailyRecordId,
      if (activityName != null) 'activity_name': activityName,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyRecordId,
    Value<String>? activityName,
    Value<int>? durationMinutes,
    Value<int?>? caloriesBurned,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      dailyRecordId: dailyRecordId ?? this.dailyRecordId,
      activityName: activityName ?? this.activityName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyRecordId.present) {
      map['daily_record_id'] = Variable<int>(dailyRecordId.value);
    }
    if (activityName.present) {
      map['activity_name'] = Variable<String>(activityName.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<int>(caloriesBurned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('activityName: $activityName, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('caloriesBurned: $caloriesBurned')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dailyRecordIdMeta = const VerificationMeta(
    'dailyRecordId',
  );
  @override
  late final GeneratedColumn<int> dailyRecordId = GeneratedColumn<int>(
    'daily_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_records (id)',
    ),
  );
  static const VerificationMeta _mealNameMeta = const VerificationMeta(
    'mealName',
  );
  @override
  late final GeneratedColumn<String> mealName = GeneratedColumn<String>(
    'meal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyRecordId,
    mealName,
    mealType,
    calories,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_record_id')) {
      context.handle(
        _dailyRecordIdMeta,
        dailyRecordId.isAcceptableOrUnknown(
          data['daily_record_id']!,
          _dailyRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyRecordIdMeta);
    }
    if (data.containsKey('meal_name')) {
      context.handle(
        _mealNameMeta,
        mealName.isAcceptableOrUnknown(data['meal_name']!, _mealNameMeta),
      );
    } else if (isInserting) {
      context.missing(_mealNameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_record_id'],
      )!,
      mealName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_name'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      ),
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final int dailyRecordId;
  final String mealName;
  final String mealType;
  final int? calories;
  const Meal({
    required this.id,
    required this.dailyRecordId,
    required this.mealName,
    required this.mealType,
    this.calories,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_record_id'] = Variable<int>(dailyRecordId);
    map['meal_name'] = Variable<String>(mealName);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      dailyRecordId: Value(dailyRecordId),
      mealName: Value(mealName),
      mealType: Value(mealType),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      dailyRecordId: serializer.fromJson<int>(json['dailyRecordId']),
      mealName: serializer.fromJson<String>(json['mealName']),
      mealType: serializer.fromJson<String>(json['mealType']),
      calories: serializer.fromJson<int?>(json['calories']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyRecordId': serializer.toJson<int>(dailyRecordId),
      'mealName': serializer.toJson<String>(mealName),
      'mealType': serializer.toJson<String>(mealType),
      'calories': serializer.toJson<int?>(calories),
    };
  }

  Meal copyWith({
    int? id,
    int? dailyRecordId,
    String? mealName,
    String? mealType,
    Value<int?> calories = const Value.absent(),
  }) => Meal(
    id: id ?? this.id,
    dailyRecordId: dailyRecordId ?? this.dailyRecordId,
    mealName: mealName ?? this.mealName,
    mealType: mealType ?? this.mealType,
    calories: calories.present ? calories.value : this.calories,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      dailyRecordId: data.dailyRecordId.present
          ? data.dailyRecordId.value
          : this.dailyRecordId,
      mealName: data.mealName.present ? data.mealName.value : this.mealName,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      calories: data.calories.present ? data.calories.value : this.calories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('mealName: $mealName, ')
          ..write('mealType: $mealType, ')
          ..write('calories: $calories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dailyRecordId, mealName, mealType, calories);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.dailyRecordId == this.dailyRecordId &&
          other.mealName == this.mealName &&
          other.mealType == this.mealType &&
          other.calories == this.calories);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<int> dailyRecordId;
  final Value<String> mealName;
  final Value<String> mealType;
  final Value<int?> calories;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.dailyRecordId = const Value.absent(),
    this.mealName = const Value.absent(),
    this.mealType = const Value.absent(),
    this.calories = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required int dailyRecordId,
    required String mealName,
    required String mealType,
    this.calories = const Value.absent(),
  }) : dailyRecordId = Value(dailyRecordId),
       mealName = Value(mealName),
       mealType = Value(mealType);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<int>? dailyRecordId,
    Expression<String>? mealName,
    Expression<String>? mealType,
    Expression<int>? calories,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyRecordId != null) 'daily_record_id': dailyRecordId,
      if (mealName != null) 'meal_name': mealName,
      if (mealType != null) 'meal_type': mealType,
      if (calories != null) 'calories': calories,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyRecordId,
    Value<String>? mealName,
    Value<String>? mealType,
    Value<int?>? calories,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      dailyRecordId: dailyRecordId ?? this.dailyRecordId,
      mealName: mealName ?? this.mealName,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyRecordId.present) {
      map['daily_record_id'] = Variable<int>(dailyRecordId.value);
    }
    if (mealName.present) {
      map['meal_name'] = Variable<String>(mealName.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('mealName: $mealName, ')
          ..write('mealType: $mealType, ')
          ..write('calories: $calories')
          ..write(')'))
        .toString();
  }
}

class $MoodSymptomsTable extends MoodSymptoms
    with TableInfo<$MoodSymptomsTable, MoodSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodSymptomsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dailyRecordIdMeta = const VerificationMeta(
    'dailyRecordId',
  );
  @override
  late final GeneratedColumn<int> dailyRecordId = GeneratedColumn<int>(
    'daily_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_records (id)',
    ),
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
    'mood_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _anxietyLevelMeta = const VerificationMeta(
    'anxietyLevel',
  );
  @override
  late final GeneratedColumn<int> anxietyLevel = GeneratedColumn<int>(
    'anxiety_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productivityLevelMeta = const VerificationMeta(
    'productivityLevel',
  );
  @override
  late final GeneratedColumn<int> productivityLevel = GeneratedColumn<int>(
    'productivity_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motivationLevelMeta = const VerificationMeta(
    'motivationLevel',
  );
  @override
  late final GeneratedColumn<int> motivationLevel = GeneratedColumn<int>(
    'motivation_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyRecordId,
    moodScore,
    anxietyLevel,
    productivityLevel,
    motivationLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_record_id')) {
      context.handle(
        _dailyRecordIdMeta,
        dailyRecordId.isAcceptableOrUnknown(
          data['daily_record_id']!,
          _dailyRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyRecordIdMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    }
    if (data.containsKey('anxiety_level')) {
      context.handle(
        _anxietyLevelMeta,
        anxietyLevel.isAcceptableOrUnknown(
          data['anxiety_level']!,
          _anxietyLevelMeta,
        ),
      );
    }
    if (data.containsKey('productivity_level')) {
      context.handle(
        _productivityLevelMeta,
        productivityLevel.isAcceptableOrUnknown(
          data['productivity_level']!,
          _productivityLevelMeta,
        ),
      );
    }
    if (data.containsKey('motivation_level')) {
      context.handle(
        _motivationLevelMeta,
        motivationLevel.isAcceptableOrUnknown(
          data['motivation_level']!,
          _motivationLevelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodSymptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_record_id'],
      )!,
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_score'],
      )!,
      anxietyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anxiety_level'],
      ),
      productivityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}productivity_level'],
      ),
      motivationLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motivation_level'],
      ),
    );
  }

  @override
  $MoodSymptomsTable createAlias(String alias) {
    return $MoodSymptomsTable(attachedDatabase, alias);
  }
}

class MoodSymptom extends DataClass implements Insertable<MoodSymptom> {
  final int id;
  final int dailyRecordId;
  final int moodScore;
  final int? anxietyLevel;
  final int? productivityLevel;
  final int? motivationLevel;
  const MoodSymptom({
    required this.id,
    required this.dailyRecordId,
    required this.moodScore,
    this.anxietyLevel,
    this.productivityLevel,
    this.motivationLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_record_id'] = Variable<int>(dailyRecordId);
    map['mood_score'] = Variable<int>(moodScore);
    if (!nullToAbsent || anxietyLevel != null) {
      map['anxiety_level'] = Variable<int>(anxietyLevel);
    }
    if (!nullToAbsent || productivityLevel != null) {
      map['productivity_level'] = Variable<int>(productivityLevel);
    }
    if (!nullToAbsent || motivationLevel != null) {
      map['motivation_level'] = Variable<int>(motivationLevel);
    }
    return map;
  }

  MoodSymptomsCompanion toCompanion(bool nullToAbsent) {
    return MoodSymptomsCompanion(
      id: Value(id),
      dailyRecordId: Value(dailyRecordId),
      moodScore: Value(moodScore),
      anxietyLevel: anxietyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(anxietyLevel),
      productivityLevel: productivityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(productivityLevel),
      motivationLevel: motivationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(motivationLevel),
    );
  }

  factory MoodSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodSymptom(
      id: serializer.fromJson<int>(json['id']),
      dailyRecordId: serializer.fromJson<int>(json['dailyRecordId']),
      moodScore: serializer.fromJson<int>(json['moodScore']),
      anxietyLevel: serializer.fromJson<int?>(json['anxietyLevel']),
      productivityLevel: serializer.fromJson<int?>(json['productivityLevel']),
      motivationLevel: serializer.fromJson<int?>(json['motivationLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyRecordId': serializer.toJson<int>(dailyRecordId),
      'moodScore': serializer.toJson<int>(moodScore),
      'anxietyLevel': serializer.toJson<int?>(anxietyLevel),
      'productivityLevel': serializer.toJson<int?>(productivityLevel),
      'motivationLevel': serializer.toJson<int?>(motivationLevel),
    };
  }

  MoodSymptom copyWith({
    int? id,
    int? dailyRecordId,
    int? moodScore,
    Value<int?> anxietyLevel = const Value.absent(),
    Value<int?> productivityLevel = const Value.absent(),
    Value<int?> motivationLevel = const Value.absent(),
  }) => MoodSymptom(
    id: id ?? this.id,
    dailyRecordId: dailyRecordId ?? this.dailyRecordId,
    moodScore: moodScore ?? this.moodScore,
    anxietyLevel: anxietyLevel.present ? anxietyLevel.value : this.anxietyLevel,
    productivityLevel: productivityLevel.present
        ? productivityLevel.value
        : this.productivityLevel,
    motivationLevel: motivationLevel.present
        ? motivationLevel.value
        : this.motivationLevel,
  );
  MoodSymptom copyWithCompanion(MoodSymptomsCompanion data) {
    return MoodSymptom(
      id: data.id.present ? data.id.value : this.id,
      dailyRecordId: data.dailyRecordId.present
          ? data.dailyRecordId.value
          : this.dailyRecordId,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      anxietyLevel: data.anxietyLevel.present
          ? data.anxietyLevel.value
          : this.anxietyLevel,
      productivityLevel: data.productivityLevel.present
          ? data.productivityLevel.value
          : this.productivityLevel,
      motivationLevel: data.motivationLevel.present
          ? data.motivationLevel.value
          : this.motivationLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodSymptom(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('moodScore: $moodScore, ')
          ..write('anxietyLevel: $anxietyLevel, ')
          ..write('productivityLevel: $productivityLevel, ')
          ..write('motivationLevel: $motivationLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyRecordId,
    moodScore,
    anxietyLevel,
    productivityLevel,
    motivationLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodSymptom &&
          other.id == this.id &&
          other.dailyRecordId == this.dailyRecordId &&
          other.moodScore == this.moodScore &&
          other.anxietyLevel == this.anxietyLevel &&
          other.productivityLevel == this.productivityLevel &&
          other.motivationLevel == this.motivationLevel);
}

class MoodSymptomsCompanion extends UpdateCompanion<MoodSymptom> {
  final Value<int> id;
  final Value<int> dailyRecordId;
  final Value<int> moodScore;
  final Value<int?> anxietyLevel;
  final Value<int?> productivityLevel;
  final Value<int?> motivationLevel;
  const MoodSymptomsCompanion({
    this.id = const Value.absent(),
    this.dailyRecordId = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.anxietyLevel = const Value.absent(),
    this.productivityLevel = const Value.absent(),
    this.motivationLevel = const Value.absent(),
  });
  MoodSymptomsCompanion.insert({
    this.id = const Value.absent(),
    required int dailyRecordId,
    this.moodScore = const Value.absent(),
    this.anxietyLevel = const Value.absent(),
    this.productivityLevel = const Value.absent(),
    this.motivationLevel = const Value.absent(),
  }) : dailyRecordId = Value(dailyRecordId);
  static Insertable<MoodSymptom> custom({
    Expression<int>? id,
    Expression<int>? dailyRecordId,
    Expression<int>? moodScore,
    Expression<int>? anxietyLevel,
    Expression<int>? productivityLevel,
    Expression<int>? motivationLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyRecordId != null) 'daily_record_id': dailyRecordId,
      if (moodScore != null) 'mood_score': moodScore,
      if (anxietyLevel != null) 'anxiety_level': anxietyLevel,
      if (productivityLevel != null) 'productivity_level': productivityLevel,
      if (motivationLevel != null) 'motivation_level': motivationLevel,
    });
  }

  MoodSymptomsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyRecordId,
    Value<int>? moodScore,
    Value<int?>? anxietyLevel,
    Value<int?>? productivityLevel,
    Value<int?>? motivationLevel,
  }) {
    return MoodSymptomsCompanion(
      id: id ?? this.id,
      dailyRecordId: dailyRecordId ?? this.dailyRecordId,
      moodScore: moodScore ?? this.moodScore,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      productivityLevel: productivityLevel ?? this.productivityLevel,
      motivationLevel: motivationLevel ?? this.motivationLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyRecordId.present) {
      map['daily_record_id'] = Variable<int>(dailyRecordId.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (anxietyLevel.present) {
      map['anxiety_level'] = Variable<int>(anxietyLevel.value);
    }
    if (productivityLevel.present) {
      map['productivity_level'] = Variable<int>(productivityLevel.value);
    }
    if (motivationLevel.present) {
      map['motivation_level'] = Variable<int>(motivationLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodSymptomsCompanion(')
          ..write('id: $id, ')
          ..write('dailyRecordId: $dailyRecordId, ')
          ..write('moodScore: $moodScore, ')
          ..write('anxietyLevel: $anxietyLevel, ')
          ..write('productivityLevel: $productivityLevel, ')
          ..write('motivationLevel: $motivationLevel')
          ..write(')'))
        .toString();
  }
}

class $UserGoalsTable extends UserGoals
    with TableInfo<$UserGoalsTable, UserGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGoalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetStepsMeta = const VerificationMeta(
    'targetSteps',
  );
  @override
  late final GeneratedColumn<int> targetSteps = GeneratedColumn<int>(
    'target_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8000),
  );
  static const VerificationMeta _targetSleepMeta = const VerificationMeta(
    'targetSleep',
  );
  @override
  late final GeneratedColumn<double> targetSleep = GeneratedColumn<double>(
    'target_sleep',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(7.5),
  );
  static const VerificationMeta _targetWorkoutMinutesWeeklyMeta =
      const VerificationMeta('targetWorkoutMinutesWeekly');
  @override
  late final GeneratedColumn<int> targetWorkoutMinutesWeekly =
      GeneratedColumn<int>(
        'target_workout_minutes_weekly',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(150),
      );
  static const VerificationMeta _targetDailyCaloriesMeta =
      const VerificationMeta('targetDailyCalories');
  @override
  late final GeneratedColumn<int> targetDailyCalories = GeneratedColumn<int>(
    'target_daily_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2200),
  );
  static const VerificationMeta _targetAvgMoodMeta = const VerificationMeta(
    'targetAvgMood',
  );
  @override
  late final GeneratedColumn<double> targetAvgMood = GeneratedColumn<double>(
    'target_avg_mood',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(6.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetSteps,
    targetSleep,
    targetWorkoutMinutesWeekly,
    targetDailyCalories,
    targetAvgMood,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_steps')) {
      context.handle(
        _targetStepsMeta,
        targetSteps.isAcceptableOrUnknown(
          data['target_steps']!,
          _targetStepsMeta,
        ),
      );
    }
    if (data.containsKey('target_sleep')) {
      context.handle(
        _targetSleepMeta,
        targetSleep.isAcceptableOrUnknown(
          data['target_sleep']!,
          _targetSleepMeta,
        ),
      );
    }
    if (data.containsKey('target_workout_minutes_weekly')) {
      context.handle(
        _targetWorkoutMinutesWeeklyMeta,
        targetWorkoutMinutesWeekly.isAcceptableOrUnknown(
          data['target_workout_minutes_weekly']!,
          _targetWorkoutMinutesWeeklyMeta,
        ),
      );
    }
    if (data.containsKey('target_daily_calories')) {
      context.handle(
        _targetDailyCaloriesMeta,
        targetDailyCalories.isAcceptableOrUnknown(
          data['target_daily_calories']!,
          _targetDailyCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('target_avg_mood')) {
      context.handle(
        _targetAvgMoodMeta,
        targetAvgMood.isAcceptableOrUnknown(
          data['target_avg_mood']!,
          _targetAvgMoodMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_steps'],
      )!,
      targetSleep: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_sleep'],
      )!,
      targetWorkoutMinutesWeekly: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_workout_minutes_weekly'],
      )!,
      targetDailyCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_daily_calories'],
      )!,
      targetAvgMood: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_avg_mood'],
      )!,
    );
  }

  @override
  $UserGoalsTable createAlias(String alias) {
    return $UserGoalsTable(attachedDatabase, alias);
  }
}

class UserGoal extends DataClass implements Insertable<UserGoal> {
  final int id;
  final int targetSteps;
  final double targetSleep;
  final int targetWorkoutMinutesWeekly;
  final int targetDailyCalories;
  final double targetAvgMood;
  const UserGoal({
    required this.id,
    required this.targetSteps,
    required this.targetSleep,
    required this.targetWorkoutMinutesWeekly,
    required this.targetDailyCalories,
    required this.targetAvgMood,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_steps'] = Variable<int>(targetSteps);
    map['target_sleep'] = Variable<double>(targetSleep);
    map['target_workout_minutes_weekly'] = Variable<int>(
      targetWorkoutMinutesWeekly,
    );
    map['target_daily_calories'] = Variable<int>(targetDailyCalories);
    map['target_avg_mood'] = Variable<double>(targetAvgMood);
    return map;
  }

  UserGoalsCompanion toCompanion(bool nullToAbsent) {
    return UserGoalsCompanion(
      id: Value(id),
      targetSteps: Value(targetSteps),
      targetSleep: Value(targetSleep),
      targetWorkoutMinutesWeekly: Value(targetWorkoutMinutesWeekly),
      targetDailyCalories: Value(targetDailyCalories),
      targetAvgMood: Value(targetAvgMood),
    );
  }

  factory UserGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGoal(
      id: serializer.fromJson<int>(json['id']),
      targetSteps: serializer.fromJson<int>(json['targetSteps']),
      targetSleep: serializer.fromJson<double>(json['targetSleep']),
      targetWorkoutMinutesWeekly: serializer.fromJson<int>(
        json['targetWorkoutMinutesWeekly'],
      ),
      targetDailyCalories: serializer.fromJson<int>(
        json['targetDailyCalories'],
      ),
      targetAvgMood: serializer.fromJson<double>(json['targetAvgMood']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetSteps': serializer.toJson<int>(targetSteps),
      'targetSleep': serializer.toJson<double>(targetSleep),
      'targetWorkoutMinutesWeekly': serializer.toJson<int>(
        targetWorkoutMinutesWeekly,
      ),
      'targetDailyCalories': serializer.toJson<int>(targetDailyCalories),
      'targetAvgMood': serializer.toJson<double>(targetAvgMood),
    };
  }

  UserGoal copyWith({
    int? id,
    int? targetSteps,
    double? targetSleep,
    int? targetWorkoutMinutesWeekly,
    int? targetDailyCalories,
    double? targetAvgMood,
  }) => UserGoal(
    id: id ?? this.id,
    targetSteps: targetSteps ?? this.targetSteps,
    targetSleep: targetSleep ?? this.targetSleep,
    targetWorkoutMinutesWeekly:
        targetWorkoutMinutesWeekly ?? this.targetWorkoutMinutesWeekly,
    targetDailyCalories: targetDailyCalories ?? this.targetDailyCalories,
    targetAvgMood: targetAvgMood ?? this.targetAvgMood,
  );
  UserGoal copyWithCompanion(UserGoalsCompanion data) {
    return UserGoal(
      id: data.id.present ? data.id.value : this.id,
      targetSteps: data.targetSteps.present
          ? data.targetSteps.value
          : this.targetSteps,
      targetSleep: data.targetSleep.present
          ? data.targetSleep.value
          : this.targetSleep,
      targetWorkoutMinutesWeekly: data.targetWorkoutMinutesWeekly.present
          ? data.targetWorkoutMinutesWeekly.value
          : this.targetWorkoutMinutesWeekly,
      targetDailyCalories: data.targetDailyCalories.present
          ? data.targetDailyCalories.value
          : this.targetDailyCalories,
      targetAvgMood: data.targetAvgMood.present
          ? data.targetAvgMood.value
          : this.targetAvgMood,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGoal(')
          ..write('id: $id, ')
          ..write('targetSteps: $targetSteps, ')
          ..write('targetSleep: $targetSleep, ')
          ..write('targetWorkoutMinutesWeekly: $targetWorkoutMinutesWeekly, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetAvgMood: $targetAvgMood')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetSteps,
    targetSleep,
    targetWorkoutMinutesWeekly,
    targetDailyCalories,
    targetAvgMood,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGoal &&
          other.id == this.id &&
          other.targetSteps == this.targetSteps &&
          other.targetSleep == this.targetSleep &&
          other.targetWorkoutMinutesWeekly == this.targetWorkoutMinutesWeekly &&
          other.targetDailyCalories == this.targetDailyCalories &&
          other.targetAvgMood == this.targetAvgMood);
}

class UserGoalsCompanion extends UpdateCompanion<UserGoal> {
  final Value<int> id;
  final Value<int> targetSteps;
  final Value<double> targetSleep;
  final Value<int> targetWorkoutMinutesWeekly;
  final Value<int> targetDailyCalories;
  final Value<double> targetAvgMood;
  const UserGoalsCompanion({
    this.id = const Value.absent(),
    this.targetSteps = const Value.absent(),
    this.targetSleep = const Value.absent(),
    this.targetWorkoutMinutesWeekly = const Value.absent(),
    this.targetDailyCalories = const Value.absent(),
    this.targetAvgMood = const Value.absent(),
  });
  UserGoalsCompanion.insert({
    this.id = const Value.absent(),
    this.targetSteps = const Value.absent(),
    this.targetSleep = const Value.absent(),
    this.targetWorkoutMinutesWeekly = const Value.absent(),
    this.targetDailyCalories = const Value.absent(),
    this.targetAvgMood = const Value.absent(),
  });
  static Insertable<UserGoal> custom({
    Expression<int>? id,
    Expression<int>? targetSteps,
    Expression<double>? targetSleep,
    Expression<int>? targetWorkoutMinutesWeekly,
    Expression<int>? targetDailyCalories,
    Expression<double>? targetAvgMood,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetSteps != null) 'target_steps': targetSteps,
      if (targetSleep != null) 'target_sleep': targetSleep,
      if (targetWorkoutMinutesWeekly != null)
        'target_workout_minutes_weekly': targetWorkoutMinutesWeekly,
      if (targetDailyCalories != null)
        'target_daily_calories': targetDailyCalories,
      if (targetAvgMood != null) 'target_avg_mood': targetAvgMood,
    });
  }

  UserGoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? targetSteps,
    Value<double>? targetSleep,
    Value<int>? targetWorkoutMinutesWeekly,
    Value<int>? targetDailyCalories,
    Value<double>? targetAvgMood,
  }) {
    return UserGoalsCompanion(
      id: id ?? this.id,
      targetSteps: targetSteps ?? this.targetSteps,
      targetSleep: targetSleep ?? this.targetSleep,
      targetWorkoutMinutesWeekly:
          targetWorkoutMinutesWeekly ?? this.targetWorkoutMinutesWeekly,
      targetDailyCalories: targetDailyCalories ?? this.targetDailyCalories,
      targetAvgMood: targetAvgMood ?? this.targetAvgMood,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetSteps.present) {
      map['target_steps'] = Variable<int>(targetSteps.value);
    }
    if (targetSleep.present) {
      map['target_sleep'] = Variable<double>(targetSleep.value);
    }
    if (targetWorkoutMinutesWeekly.present) {
      map['target_workout_minutes_weekly'] = Variable<int>(
        targetWorkoutMinutesWeekly.value,
      );
    }
    if (targetDailyCalories.present) {
      map['target_daily_calories'] = Variable<int>(targetDailyCalories.value);
    }
    if (targetAvgMood.present) {
      map['target_avg_mood'] = Variable<double>(targetAvgMood.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGoalsCompanion(')
          ..write('id: $id, ')
          ..write('targetSteps: $targetSteps, ')
          ..write('targetSleep: $targetSleep, ')
          ..write('targetWorkoutMinutesWeekly: $targetWorkoutMinutesWeekly, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetAvgMood: $targetAvgMood')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  late final $ChatHistoryTable chatHistory = $ChatHistoryTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $MoodSymptomsTable moodSymptoms = $MoodSymptomsTable(this);
  late final $UserGoalsTable userGoals = $UserGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyRecords,
    chatHistory,
    workouts,
    meals,
    moodSymptoms,
    userGoals,
  ];
}

typedef $$DailyRecordsTableCreateCompanionBuilder =
    DailyRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      required int steps,
      required double sleepHours,
      required String diaryNote,
      required String avatarState,
      Value<String?> coachMessage,
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
      Value<String?> coachMessage,
      Value<String> dietQuality,
      Value<String> workoutType,
    });

final class $$DailyRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord> {
  $$DailyRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutsTable, List<Workout>> _workoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workouts,
    aliasName: $_aliasNameGenerator(
      db.dailyRecords.id,
      db.workouts.dailyRecordId,
    ),
  );

  $$WorkoutsTableProcessedTableManager get workoutsRefs {
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.dailyRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.dailyRecords.id, db.meals.dailyRecordId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.dailyRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MoodSymptomsTable, List<MoodSymptom>>
  _moodSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.moodSymptoms,
    aliasName: $_aliasNameGenerator(
      db.dailyRecords.id,
      db.moodSymptoms.dailyRecordId,
    ),
  );

  $$MoodSymptomsTableProcessedTableManager get moodSymptomsRefs {
    final manager = $$MoodSymptomsTableTableManager(
      $_db,
      $_db.moodSymptoms,
    ).filter((f) => f.dailyRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_moodSymptomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get coachMessage => $composableBuilder(
    column: $table.coachMessage,
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

  Expression<bool> workoutsRefs(
    Expression<bool> Function($$WorkoutsTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> moodSymptomsRefs(
    Expression<bool> Function($$MoodSymptomsTableFilterComposer f) f,
  ) {
    final $$MoodSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodSymptoms,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.moodSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get coachMessage => $composableBuilder(
    column: $table.coachMessage,
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

  GeneratedColumn<String> get coachMessage => $composableBuilder(
    column: $table.coachMessage,
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

  Expression<T> workoutsRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> moodSymptomsRefs<T extends Object>(
    Expression<T> Function($$MoodSymptomsTableAnnotationComposer a) f,
  ) {
    final $$MoodSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodSymptoms,
      getReferencedColumn: (t) => t.dailyRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.moodSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (DailyRecord, $$DailyRecordsTableReferences),
          DailyRecord,
          PrefetchHooks Function({
            bool workoutsRefs,
            bool mealsRefs,
            bool moodSymptomsRefs,
          })
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
                Value<String?> coachMessage = const Value.absent(),
                Value<String> dietQuality = const Value.absent(),
                Value<String> workoutType = const Value.absent(),
              }) => DailyRecordsCompanion(
                id: id,
                date: date,
                steps: steps,
                sleepHours: sleepHours,
                diaryNote: diaryNote,
                avatarState: avatarState,
                coachMessage: coachMessage,
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
                Value<String?> coachMessage = const Value.absent(),
                Value<String> dietQuality = const Value.absent(),
                Value<String> workoutType = const Value.absent(),
              }) => DailyRecordsCompanion.insert(
                id: id,
                date: date,
                steps: steps,
                sleepHours: sleepHours,
                diaryNote: diaryNote,
                avatarState: avatarState,
                coachMessage: coachMessage,
                dietQuality: dietQuality,
                workoutType: workoutType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutsRefs = false,
                mealsRefs = false,
                moodSymptomsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutsRefs) db.workouts,
                    if (mealsRefs) db.meals,
                    if (moodSymptomsRefs) db.moodSymptoms,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutsRefs)
                        await $_getPrefetchedData<
                          DailyRecord,
                          $DailyRecordsTable,
                          Workout
                        >(
                          currentTable: table,
                          referencedTable: $$DailyRecordsTableReferences
                              ._workoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dailyRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealsRefs)
                        await $_getPrefetchedData<
                          DailyRecord,
                          $DailyRecordsTable,
                          Meal
                        >(
                          currentTable: table,
                          referencedTable: $$DailyRecordsTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dailyRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (moodSymptomsRefs)
                        await $_getPrefetchedData<
                          DailyRecord,
                          $DailyRecordsTable,
                          MoodSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$DailyRecordsTableReferences
                              ._moodSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).moodSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dailyRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (DailyRecord, $$DailyRecordsTableReferences),
      DailyRecord,
      PrefetchHooks Function({
        bool workoutsRefs,
        bool mealsRefs,
        bool moodSymptomsRefs,
      })
    >;
typedef $$ChatHistoryTableCreateCompanionBuilder =
    ChatHistoryCompanion Function({
      Value<int> id,
      required String textMessage,
      required bool isUser,
      Value<DateTime> timestamp,
    });
typedef $$ChatHistoryTableUpdateCompanionBuilder =
    ChatHistoryCompanion Function({
      Value<int> id,
      Value<String> textMessage,
      Value<bool> isUser,
      Value<DateTime> timestamp,
    });

class $$ChatHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ChatHistoryTable> {
  $$ChatHistoryTableFilterComposer({
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

  ColumnFilters<String> get textMessage => $composableBuilder(
    column: $table.textMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatHistoryTable> {
  $$ChatHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get textMessage => $composableBuilder(
    column: $table.textMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatHistoryTable> {
  $$ChatHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textMessage => $composableBuilder(
    column: $table.textMessage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUser =>
      $composableBuilder(column: $table.isUser, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ChatHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatHistoryTable,
          ChatHistoryData,
          $$ChatHistoryTableFilterComposer,
          $$ChatHistoryTableOrderingComposer,
          $$ChatHistoryTableAnnotationComposer,
          $$ChatHistoryTableCreateCompanionBuilder,
          $$ChatHistoryTableUpdateCompanionBuilder,
          (
            ChatHistoryData,
            BaseReferences<_$AppDatabase, $ChatHistoryTable, ChatHistoryData>,
          ),
          ChatHistoryData,
          PrefetchHooks Function()
        > {
  $$ChatHistoryTableTableManager(_$AppDatabase db, $ChatHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> textMessage = const Value.absent(),
                Value<bool> isUser = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatHistoryCompanion(
                id: id,
                textMessage: textMessage,
                isUser: isUser,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String textMessage,
                required bool isUser,
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatHistoryCompanion.insert(
                id: id,
                textMessage: textMessage,
                isUser: isUser,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatHistoryTable,
      ChatHistoryData,
      $$ChatHistoryTableFilterComposer,
      $$ChatHistoryTableOrderingComposer,
      $$ChatHistoryTableAnnotationComposer,
      $$ChatHistoryTableCreateCompanionBuilder,
      $$ChatHistoryTableUpdateCompanionBuilder,
      (
        ChatHistoryData,
        BaseReferences<_$AppDatabase, $ChatHistoryTable, ChatHistoryData>,
      ),
      ChatHistoryData,
      PrefetchHooks Function()
    >;
typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<int> id,
      required int dailyRecordId,
      required String activityName,
      required int durationMinutes,
      Value<int?> caloriesBurned,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<int> id,
      Value<int> dailyRecordId,
      Value<String> activityName,
      Value<int> durationMinutes,
      Value<int?> caloriesBurned,
    });

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyRecordsTable _dailyRecordIdTable(_$AppDatabase db) =>
      db.dailyRecords.createAlias(
        $_aliasNameGenerator(db.workouts.dailyRecordId, db.dailyRecords.id),
      );

  $$DailyRecordsTableProcessedTableManager get dailyRecordId {
    final $_column = $_itemColumn<int>('daily_record_id')!;

    final manager = $$DailyRecordsTableTableManager(
      $_db,
      $_db.dailyRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
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

  ColumnFilters<String> get activityName => $composableBuilder(
    column: $table.activityName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyRecordsTableFilterComposer get dailyRecordId {
    final $$DailyRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
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

  ColumnOrderings<String> get activityName => $composableBuilder(
    column: $table.activityName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyRecordsTableOrderingComposer get dailyRecordId {
    final $$DailyRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activityName => $composableBuilder(
    column: $table.activityName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => column,
  );

  $$DailyRecordsTableAnnotationComposer get dailyRecordId {
    final $$DailyRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({bool dailyRecordId})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyRecordId = const Value.absent(),
                Value<String> activityName = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int?> caloriesBurned = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                dailyRecordId: dailyRecordId,
                activityName: activityName,
                durationMinutes: durationMinutes,
                caloriesBurned: caloriesBurned,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailyRecordId,
                required String activityName,
                required int durationMinutes,
                Value<int?> caloriesBurned = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                dailyRecordId: dailyRecordId,
                activityName: activityName,
                durationMinutes: durationMinutes,
                caloriesBurned: caloriesBurned,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordId = false}) {
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
                    if (dailyRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dailyRecordId,
                                referencedTable: $$WorkoutsTableReferences
                                    ._dailyRecordIdTable(db),
                                referencedColumn: $$WorkoutsTableReferences
                                    ._dailyRecordIdTable(db)
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

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({bool dailyRecordId})
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required int dailyRecordId,
      required String mealName,
      required String mealType,
      Value<int?> calories,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<int> dailyRecordId,
      Value<String> mealName,
      Value<String> mealType,
      Value<int?> calories,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyRecordsTable _dailyRecordIdTable(_$AppDatabase db) =>
      db.dailyRecords.createAlias(
        $_aliasNameGenerator(db.meals.dailyRecordId, db.dailyRecords.id),
      );

  $$DailyRecordsTableProcessedTableManager get dailyRecordId {
    final $_column = $_itemColumn<int>('daily_record_id')!;

    final manager = $$DailyRecordsTableTableManager(
      $_db,
      $_db.dailyRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
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

  ColumnFilters<String> get mealName => $composableBuilder(
    column: $table.mealName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyRecordsTableFilterComposer get dailyRecordId {
    final $$DailyRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
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

  ColumnOrderings<String> get mealName => $composableBuilder(
    column: $table.mealName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyRecordsTableOrderingComposer get dailyRecordId {
    final $$DailyRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mealName =>
      $composableBuilder(column: $table.mealName, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  $$DailyRecordsTableAnnotationComposer get dailyRecordId {
    final $$DailyRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({bool dailyRecordId})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyRecordId = const Value.absent(),
                Value<String> mealName = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int?> calories = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                dailyRecordId: dailyRecordId,
                mealName: mealName,
                mealType: mealType,
                calories: calories,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailyRecordId,
                required String mealName,
                required String mealType,
                Value<int?> calories = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                dailyRecordId: dailyRecordId,
                mealName: mealName,
                mealType: mealType,
                calories: calories,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordId = false}) {
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
                    if (dailyRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dailyRecordId,
                                referencedTable: $$MealsTableReferences
                                    ._dailyRecordIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._dailyRecordIdTable(db)
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

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({bool dailyRecordId})
    >;
typedef $$MoodSymptomsTableCreateCompanionBuilder =
    MoodSymptomsCompanion Function({
      Value<int> id,
      required int dailyRecordId,
      Value<int> moodScore,
      Value<int?> anxietyLevel,
      Value<int?> productivityLevel,
      Value<int?> motivationLevel,
    });
typedef $$MoodSymptomsTableUpdateCompanionBuilder =
    MoodSymptomsCompanion Function({
      Value<int> id,
      Value<int> dailyRecordId,
      Value<int> moodScore,
      Value<int?> anxietyLevel,
      Value<int?> productivityLevel,
      Value<int?> motivationLevel,
    });

final class $$MoodSymptomsTableReferences
    extends BaseReferences<_$AppDatabase, $MoodSymptomsTable, MoodSymptom> {
  $$MoodSymptomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyRecordsTable _dailyRecordIdTable(_$AppDatabase db) =>
      db.dailyRecords.createAlias(
        $_aliasNameGenerator(db.moodSymptoms.dailyRecordId, db.dailyRecords.id),
      );

  $$DailyRecordsTableProcessedTableManager get dailyRecordId {
    final $_column = $_itemColumn<int>('daily_record_id')!;

    final manager = $$DailyRecordsTableTableManager(
      $_db,
      $_db.dailyRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodSymptomsTable> {
  $$MoodSymptomsTableFilterComposer({
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

  ColumnFilters<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productivityLevel => $composableBuilder(
    column: $table.productivityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyRecordsTableFilterComposer get dailyRecordId {
    final $$DailyRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableFilterComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodSymptomsTable> {
  $$MoodSymptomsTableOrderingComposer({
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

  ColumnOrderings<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productivityLevel => $composableBuilder(
    column: $table.productivityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyRecordsTableOrderingComposer get dailyRecordId {
    final $$DailyRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodSymptomsTable> {
  $$MoodSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<int> get anxietyLevel => $composableBuilder(
    column: $table.anxietyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productivityLevel => $composableBuilder(
    column: $table.productivityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => column,
  );

  $$DailyRecordsTableAnnotationComposer get dailyRecordId {
    final $$DailyRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dailyRecordId,
      referencedTable: $db.dailyRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodSymptomsTable,
          MoodSymptom,
          $$MoodSymptomsTableFilterComposer,
          $$MoodSymptomsTableOrderingComposer,
          $$MoodSymptomsTableAnnotationComposer,
          $$MoodSymptomsTableCreateCompanionBuilder,
          $$MoodSymptomsTableUpdateCompanionBuilder,
          (MoodSymptom, $$MoodSymptomsTableReferences),
          MoodSymptom,
          PrefetchHooks Function({bool dailyRecordId})
        > {
  $$MoodSymptomsTableTableManager(_$AppDatabase db, $MoodSymptomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodSymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodSymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyRecordId = const Value.absent(),
                Value<int> moodScore = const Value.absent(),
                Value<int?> anxietyLevel = const Value.absent(),
                Value<int?> productivityLevel = const Value.absent(),
                Value<int?> motivationLevel = const Value.absent(),
              }) => MoodSymptomsCompanion(
                id: id,
                dailyRecordId: dailyRecordId,
                moodScore: moodScore,
                anxietyLevel: anxietyLevel,
                productivityLevel: productivityLevel,
                motivationLevel: motivationLevel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dailyRecordId,
                Value<int> moodScore = const Value.absent(),
                Value<int?> anxietyLevel = const Value.absent(),
                Value<int?> productivityLevel = const Value.absent(),
                Value<int?> motivationLevel = const Value.absent(),
              }) => MoodSymptomsCompanion.insert(
                id: id,
                dailyRecordId: dailyRecordId,
                moodScore: moodScore,
                anxietyLevel: anxietyLevel,
                productivityLevel: productivityLevel,
                motivationLevel: motivationLevel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodSymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyRecordId = false}) {
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
                    if (dailyRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dailyRecordId,
                                referencedTable: $$MoodSymptomsTableReferences
                                    ._dailyRecordIdTable(db),
                                referencedColumn: $$MoodSymptomsTableReferences
                                    ._dailyRecordIdTable(db)
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

typedef $$MoodSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodSymptomsTable,
      MoodSymptom,
      $$MoodSymptomsTableFilterComposer,
      $$MoodSymptomsTableOrderingComposer,
      $$MoodSymptomsTableAnnotationComposer,
      $$MoodSymptomsTableCreateCompanionBuilder,
      $$MoodSymptomsTableUpdateCompanionBuilder,
      (MoodSymptom, $$MoodSymptomsTableReferences),
      MoodSymptom,
      PrefetchHooks Function({bool dailyRecordId})
    >;
typedef $$UserGoalsTableCreateCompanionBuilder =
    UserGoalsCompanion Function({
      Value<int> id,
      Value<int> targetSteps,
      Value<double> targetSleep,
      Value<int> targetWorkoutMinutesWeekly,
      Value<int> targetDailyCalories,
      Value<double> targetAvgMood,
    });
typedef $$UserGoalsTableUpdateCompanionBuilder =
    UserGoalsCompanion Function({
      Value<int> id,
      Value<int> targetSteps,
      Value<double> targetSleep,
      Value<int> targetWorkoutMinutesWeekly,
      Value<int> targetDailyCalories,
      Value<double> targetAvgMood,
    });

class $$UserGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableFilterComposer({
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

  ColumnFilters<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetSleep => $composableBuilder(
    column: $table.targetSleep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetWorkoutMinutesWeekly => $composableBuilder(
    column: $table.targetWorkoutMinutesWeekly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAvgMood => $composableBuilder(
    column: $table.targetAvgMood,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableOrderingComposer({
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

  ColumnOrderings<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetSleep => $composableBuilder(
    column: $table.targetSleep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetWorkoutMinutesWeekly => $composableBuilder(
    column: $table.targetWorkoutMinutesWeekly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAvgMood => $composableBuilder(
    column: $table.targetAvgMood,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetSteps => $composableBuilder(
    column: $table.targetSteps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetSleep => $composableBuilder(
    column: $table.targetSleep,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetWorkoutMinutesWeekly => $composableBuilder(
    column: $table.targetWorkoutMinutesWeekly,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetAvgMood => $composableBuilder(
    column: $table.targetAvgMood,
    builder: (column) => column,
  );
}

class $$UserGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserGoalsTable,
          UserGoal,
          $$UserGoalsTableFilterComposer,
          $$UserGoalsTableOrderingComposer,
          $$UserGoalsTableAnnotationComposer,
          $$UserGoalsTableCreateCompanionBuilder,
          $$UserGoalsTableUpdateCompanionBuilder,
          (UserGoal, BaseReferences<_$AppDatabase, $UserGoalsTable, UserGoal>),
          UserGoal,
          PrefetchHooks Function()
        > {
  $$UserGoalsTableTableManager(_$AppDatabase db, $UserGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetSteps = const Value.absent(),
                Value<double> targetSleep = const Value.absent(),
                Value<int> targetWorkoutMinutesWeekly = const Value.absent(),
                Value<int> targetDailyCalories = const Value.absent(),
                Value<double> targetAvgMood = const Value.absent(),
              }) => UserGoalsCompanion(
                id: id,
                targetSteps: targetSteps,
                targetSleep: targetSleep,
                targetWorkoutMinutesWeekly: targetWorkoutMinutesWeekly,
                targetDailyCalories: targetDailyCalories,
                targetAvgMood: targetAvgMood,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetSteps = const Value.absent(),
                Value<double> targetSleep = const Value.absent(),
                Value<int> targetWorkoutMinutesWeekly = const Value.absent(),
                Value<int> targetDailyCalories = const Value.absent(),
                Value<double> targetAvgMood = const Value.absent(),
              }) => UserGoalsCompanion.insert(
                id: id,
                targetSteps: targetSteps,
                targetSleep: targetSleep,
                targetWorkoutMinutesWeekly: targetWorkoutMinutesWeekly,
                targetDailyCalories: targetDailyCalories,
                targetAvgMood: targetAvgMood,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserGoalsTable,
      UserGoal,
      $$UserGoalsTableFilterComposer,
      $$UserGoalsTableOrderingComposer,
      $$UserGoalsTableAnnotationComposer,
      $$UserGoalsTableCreateCompanionBuilder,
      $$UserGoalsTableUpdateCompanionBuilder,
      (UserGoal, BaseReferences<_$AppDatabase, $UserGoalsTable, UserGoal>),
      UserGoal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
  $$ChatHistoryTableTableManager get chatHistory =>
      $$ChatHistoryTableTableManager(_db, _db.chatHistory);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MoodSymptomsTableTableManager get moodSymptoms =>
      $$MoodSymptomsTableTableManager(_db, _db.moodSymptoms);
  $$UserGoalsTableTableManager get userGoals =>
      $$UserGoalsTableTableManager(_db, _db.userGoals);
}
