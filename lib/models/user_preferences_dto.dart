class UserPreferenceDto {
  String? userName;
  bool showRestTimerAfterEachSet;
  bool autoPopulateWorkoutFromSetsHistory;
  bool isMetricSystemSelected;

  UserPreferenceDto({
    this.userName = '',
    this.showRestTimerAfterEachSet = false,
    this.isMetricSystemSelected = false,
    this.autoPopulateWorkoutFromSetsHistory = false,
  });

  factory UserPreferenceDto.fromJson(Map<String, dynamic> json) {
    return UserPreferenceDto(
      userName: json['userName'] ?? '',
      showRestTimerAfterEachSet: json['showRestTimerAfterEachSet'] ?? false,
      isMetricSystemSelected: json['isMetricSystemSelected'] ?? false,
      autoPopulateWorkoutFromSetsHistory:
          json['autoPopulateTrackedExerciseFromLatest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'showRestTimerAfterEachSet': showRestTimerAfterEachSet,
      'isMetricSystemSelected': isMetricSystemSelected,
      'autoPopulateTrackedExerciseFromLatest':
          autoPopulateWorkoutFromSetsHistory,
    };
  }
}
