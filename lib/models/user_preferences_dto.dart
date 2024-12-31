class UserPreferenceDto {
  String? userName;
  bool showRestTimerAfterEachSet;
  bool autoPopulateWorkoutFromSetsHistory;
  bool isMetricSystemSelected;
  bool hasAcknowledgeDataStorageDisclaimer;

  UserPreferenceDto({
    this.userName = '',
    this.showRestTimerAfterEachSet = false,
    this.isMetricSystemSelected = false,
    this.autoPopulateWorkoutFromSetsHistory = false,
    this.hasAcknowledgeDataStorageDisclaimer = false,
  });

  factory UserPreferenceDto.fromJson(Map<String, dynamic> json) {
    return UserPreferenceDto(
      userName: json['userName'] ?? '',
      showRestTimerAfterEachSet: json['showRestTimerAfterEachSet'] ?? false,
      isMetricSystemSelected: json['isMetricSystemSelected'] ?? false,
      autoPopulateWorkoutFromSetsHistory:
          json['autoPopulateTrackedExerciseFromLatest'] ?? false,
      hasAcknowledgeDataStorageDisclaimer:
          json['hasAcknowledgeDataStorageDisclaimer'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'showRestTimerAfterEachSet': showRestTimerAfterEachSet,
      'isMetricSystemSelected': isMetricSystemSelected,
      'autoPopulateTrackedExerciseFromLatest':
          autoPopulateWorkoutFromSetsHistory,
      'hasAcknowledgeDataStorageDisclaimer':
          hasAcknowledgeDataStorageDisclaimer,
    };
  }
}
