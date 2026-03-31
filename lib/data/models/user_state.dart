class UserState {
  final int steps;
  final double sleepHours;
  final String diaryNote;
  final String? avatarState; // e.g., 'happy', 'exhausted'
  final String? coachMessage;

  UserState({
    required this.steps,
    required this.sleepHours,
    required this.diaryNote,
    this.avatarState,
    this.coachMessage,
  });

  // Helper to create a new state with updated AI info
  UserState copyWith({String? avatarState, String? coachMessage}) {
    return UserState(
      steps: this.steps,
      sleepHours: this.sleepHours,
      diaryNote: this.diaryNote,
      avatarState: avatarState ?? this.avatarState,
      coachMessage: coachMessage ?? this.coachMessage,
    );
  }
}