import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Drift will auto create 
part 'app_database.g.dart';

// 1. Define the Blueprint (Table)
class DailyRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get steps => integer()();
  RealColumn get sleepHours => real()();
  TextColumn get diaryNote => text()();
  TextColumn get avatarState => text()();
}

// 2. Initialize the Database
@DriftDatabase(tables: [DailyRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Bump this number if you ever change the table columns later
  @override
  int get schemaVersion => 1;

  // 3. Write our Queries (The easy way to read/write data)
  Future<List<DailyRecord>> getAllRecords() => select(dailyRecords).get();
  Future<int> insertRecord(DailyRecordsCompanion entry) => into(dailyRecords).insert(entry);
  // Inside AppDatabase class
  Future<int> deleteAllRecords() => delete(dailyRecords).go();
  Future<int> deleteRecord(int id) => (delete(dailyRecords)..where((t) => t.id.equals(id))).go();
}

// 4. Find a safe place on the phone to store the SQLite file
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fyp_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}