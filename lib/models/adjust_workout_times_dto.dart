class AdjustWorkoutTimesDto {
  final DateTime? startTime;
  final DateTime? endTime;
  final bool autoTimingSelected;
  final bool showRestTimerAfterEachSet;
  final String workoutNickName;

  AdjustWorkoutTimesDto({
    required this.startTime,
    required this.endTime,
    required this.autoTimingSelected,
    required this.showRestTimerAfterEachSet,
    required this.workoutNickName,
  });
}
