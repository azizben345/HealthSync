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
}

// 4. Find a safe place on the phone to store the SQLite file
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fyp_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}