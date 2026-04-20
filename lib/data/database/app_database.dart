import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Drift will auto create 
part 'app_database.g.dart';

// Input Data
class DailyRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get steps => integer()();
  RealColumn get sleepHours => real()();
  TextColumn get diaryNote => text()();
  TextColumn get avatarState => text()();
  TextColumn get coachMessage => text().nullable()();
  TextColumn get dietQuality => text().withDefault(const Constant('Normal'))();
  TextColumn get workoutType => text().withDefault(const Constant('Rest'))();
}

// Chatbot History
class ChatHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textMessage => text()();
  BoolColumn get isUser => boolean()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

// 2. Initialize the Database
@DriftDatabase(tables: [DailyRecords, ChatHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Bump this number if ever need to change the table columns later
  @override
  int get schemaVersion => 2;

  // live stream that automatically updates the UI whenever the database changes
  Stream<List<DailyRecord>> watchAllRecords() => (select(dailyRecords)
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .watch();

  // 3. Write Queries (to read/write data)
  Future<List<DailyRecord>> getAllRecords() => select(dailyRecords).get();
  Future<int> insertRecord(DailyRecordsCompanion entry) => into(dailyRecords).insert(entry);
  // Inside AppDatabase class
  Future<int> deleteAllRecords() => delete(dailyRecords).go();
  Future<int> deleteRecord(int id) => (delete(dailyRecords)..where((t) => t.id.equals(id))).go();
  Future<bool> updateRecord(DailyRecordsCompanion entry) => update(dailyRecords).replace(entry);
  // ChatHistory methods
  Future<List<ChatHistoryData>> getAllChatMessages() => select(chatHistory).get();
  Future<int> insertChatMessage(ChatHistoryCompanion message) => into(chatHistory).insert(message);
  Future<int> clearChatHistory() => delete(chatHistory).go();
  // clear all local daily records - used for Cloud Restore feature
  Future<int> clearAllDailyRecords() => delete(dailyRecords).go();

  // For Calendar Function: Time-Traveling Upsert Function
  Future<void> saveOrUpdateDailyLog({
    required DateTime date,
    required int steps,
    required double sleep,
    required String diet,
    required String workout,
    required String diary,
    required String avatarState,
    String? coachMessage,
  }) async {
    // 1. Normalize the time! 
    // This strips away the hours/minutes so we only look at the exact calendar day.
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1, milliseconds: -1));

    // 2. Ask SQLite: "Do we already have a record for this calendar day?"
    final existingRecord = await (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    if (existingRecord != null) {
      // 3. UPSERT MATCH: if record exists, update it
      await update(dailyRecords).replace(
        existingRecord.copyWith(
          steps: steps,
          sleepHours: sleep,
          dietQuality: diet,
          workoutType: workout,
          diaryNote: diary,
          avatarState: avatarState,
          coachMessage: Value(coachMessage),
        ),
      );
    } else {
      // 4. UPSERT MATCH: if no record exists, insert a brand new one
      await into(dailyRecords).insert(
        DailyRecordsCompanion.insert(
          date: Value(startOfDay),       // ADDED Value()
          steps: steps,                  // Left as raw int
          sleepHours: sleep,             // Left as raw double
          dietQuality: Value(diet),      // ADDED Value()
          workoutType: Value(workout),   // ADDED Value()
          diaryNote: diary,              // REMOVED Value()
          avatarState: avatarState,      // Left as raw String
          coachMessage: Value(coachMessage),
        ),
      );
    }
  }

  // function to fetch a single day's record to populate the UI
  Future<DailyRecord?> getRecordByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1, milliseconds: -1));

    return await (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();
  }

  // get list of all dates that has logged data
  // Future<List<DateTime>> getAllLoggedDates() async {
  //   final records = await select(dailyRecords).get();
  //   return records.map((r) => r.date).toList();
  // }
  Future<List<DailyRecord>> getAllLoggedRecords() async {
    return await select(dailyRecords).get();
  }

}

// 4. Find a safe place on the phone to store the SQLite file
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fyp_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}