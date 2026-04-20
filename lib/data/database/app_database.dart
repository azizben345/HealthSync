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

// TABLE: Workouts
// A user can log multiple workouts in a single day.
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // This Foreign Key links the workout to a specific Daily Record!
  IntColumn get dailyRecordId => integer().references(DailyRecords, #id)(); 
  
  TextColumn get activityName => text()(); // e.g., "Running", "Weightlifting"
  IntColumn get durationMinutes => integer()();
  IntColumn get caloriesBurned => integer().nullable()(); // Made optional
}

// TABLE: Meals
// A user can log multiple meals (Breakfast, Lunch, Snack).
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyRecordId => integer().references(DailyRecords, #id)();
  
  TextColumn get mealName => text()(); // e.g., "Chicken Salad"
  TextColumn get mealType => text()(); // e.g., "Breakfast", "Lunch"
  IntColumn get calories => integer().nullable()(); // Made optional
}

// TABLE: MoodSymptoms
// Holds the detailed 1-10 sliders for their mental state.
class MoodSymptoms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyRecordId => integer().references(DailyRecords, #id)();
  
  IntColumn get moodScore => integer().withDefault(const Constant(5))(); // The core 1-10 score
  IntColumn get anxietyLevel => integer().nullable()(); // 1-10
  IntColumn get productivityLevel => integer().nullable()(); // 1-10
  IntColumn get motivationLevel => integer().nullable()(); // 1-10
}

// TABLE: UserGoals
// A "Singleton" table. We only ever keep ONE row in here (ID = 1).
@DataClassName('UserGoal')
class UserGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Fitness Goals
  IntColumn get targetSteps => integer().withDefault(const Constant(8000))();
  RealColumn get targetSleep => real().withDefault(const Constant(7.5))();
  IntColumn get targetWorkoutMinutesWeekly => integer().withDefault(const Constant(150))();
  
  // Nutrition Goal
  IntColumn get targetDailyCalories => integer().withDefault(const Constant(2200))();
  
  // Mood Goal
  RealColumn get targetAvgMood => real().withDefault(const Constant(6.0))();
}

// Chatbot History
class ChatHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textMessage => text()();
  BoolColumn get isUser => boolean()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

// 2. Initialize the Database
@DriftDatabase(tables: [DailyRecords, ChatHistory, Workouts, Meals, MoodSymptoms, UserGoals])
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

  // 1. THE HELPER: Guarantees a Daily Record exists and returns its ID
  Future<int> _ensureDailyRecordExists(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1, milliseconds: -1));

    final existingRecord = await (select(dailyRecords)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();

    if (existingRecord != null) {
      return existingRecord.id; // It exists! Return the ID.
    } else {
      // doesn't exist yet - create a blank placeholder and return the new ID.
      return await into(dailyRecords).insert(
        DailyRecordsCompanion.insert(
          date: Value(startOfDay),
          steps: 0,
          sleepHours: 0.0,
          dietQuality: const Value('Normal'),
          workoutType: const Value('Rest'),
          avatarState: 'idle', 
          diaryNote: '', 
          // We leave diary and coachMessage null
        ),
      );
    }
  }

  // 2. SAVE WORKOUT
  Future<void> addDetailedWorkout(DateTime date, String name, int duration, int? calories) async {
    final recordId = await _ensureDailyRecordExists(date); // Get the parent ID
    
    await into(workouts).insert(
      WorkoutsCompanion.insert(
        dailyRecordId: recordId, // Link it!
        activityName: name,
        durationMinutes: duration,
        caloriesBurned: Value(calories),
      ),
    );
  }

  // 3. SAVE MEAL
  Future<void> addDetailedMeal(DateTime date, String name, String type, int? calories) async {
    final recordId = await _ensureDailyRecordExists(date); // Get the parent ID
    
    await into(meals).insert(
      MealsCompanion.insert(
        dailyRecordId: recordId, // Link it!
        mealName: name,
        mealType: type,
        calories: Value(calories),
      ),
    );
  }

  // Live Stream of Workouts for a specific calendar day
  Stream<List<Workout>> watchWorkoutsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1, milliseconds: -1));

    return (select(workouts)
          // Ask SQLite: "Give me workouts where the dailyRecordId matches this specific date"
          ..where((w) => w.dailyRecordId.isInQuery(
                selectOnly(dailyRecords)
                  ..addColumns([dailyRecords.id])
                  ..where(dailyRecords.date.isBetweenValues(startOfDay, endOfDay))
              )))
        .watch();
  }

  // Live Stream of Meals for a specific calendar day
  Stream<List<Meal>> watchMealsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1, milliseconds: -1));

    return (select(meals)
          ..where((m) => m.dailyRecordId.isInQuery(
                selectOnly(dailyRecords)
                  ..addColumns([dailyRecords.id])
                  ..where(dailyRecords.date.isBetweenValues(startOfDay, endOfDay))
              )))
        .watch();
  }

  // --- GOAL SETTING LOGIC ---

  // 1. Fetch the user's goals (and create defaults if they don't exist yet)
  Future<UserGoal> getUserGoal() async {
    final goal = await select(userGoals).getSingleOrNull();
    if (goal != null) return goal;

    // First time opening the app? Insert the default values we defined in the schema!
    await into(userGoals).insert(const UserGoalsCompanion());
    return await select(userGoals).getSingle();
  }

  // 2. Update the singleton row
  Future<void> updateUserGoal({
    required int steps,
    required double sleep,
    required int workoutMins,
    required int calories,
    required double mood,
  }) async {
    final existing = await select(userGoals).getSingleOrNull();
    
    if (existing != null) {
      // Overwrite the existing row
      await update(userGoals).replace(
        existing.copyWith(
          targetSteps: steps,
          targetSleep: sleep,
          targetWorkoutMinutesWeekly: workoutMins,
          targetDailyCalories: calories,
          targetAvgMood: mood,
        ),
      );
    } else {
      // Failsafe in case it somehow got deleted
      await into(userGoals).insert(
        UserGoalsCompanion.insert(
          targetSteps: Value(steps),
          targetSleep: Value(sleep),
          targetWorkoutMinutesWeekly: Value(workoutMins),
          targetDailyCalories: Value(calories),
          targetAvgMood: Value(mood),
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

  // delete a daily record AND all its attached details
  Future<void> deleteEntireDay(int recordId) async {
    // 1. Delete the children first
    await (delete(workouts)..where((w) => w.dailyRecordId.equals(recordId))).go();
    await (delete(meals)..where((m) => m.dailyRecordId.equals(recordId))).go();
    await (delete(moodSymptoms)..where((m) => m.dailyRecordId.equals(recordId))).go();
    
    // 2. Delete the parent
    await (delete(dailyRecords)..where((d) => d.id.equals(recordId))).go();
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