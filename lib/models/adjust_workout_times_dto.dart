class AdjustWorkoutTimesDto {
  final DateTime? startTime;
  final DateTime? endTime;
  final bool autoTimingSelected;

  AdjustWorkoutTimesDto({
    required this.startTime,
    required this.endTime,
    required this.autoTimingSelected,
  });
}
