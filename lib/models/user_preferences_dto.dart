class UserPreferenceDto {
  String? userName;
  bool showRestTimerAfterEachSet;
  bool autoPopulateWorkoutFromSetsHistory;
  bool autoCollapseTrackedExercises;
  bool isMetricSystemSelected;
  bool hasAcknowledgeDataStorageDisclaimer;
  int? lastNavigatorPageIndex;

  UserPreferenceDto({
    this.userName = '',
    this.showRestTimerAfterEachSet = false,
    this.isMetricSystemSelected = false,
    this.autoPopulateWorkoutFromSetsHistory = false,
    this.autoCollapseTrackedExercises = false,
    this.hasAcknowledgeDataStorageDisclaimer = false,
    this.lastNavigatorPageIndex,
  });

  factory UserPreferenceDto.fromJson(Map<String, dynamic> json) {
    return UserPreferenceDto(
      userName: json['userName'] ?? '',
      showRestTimerAfterEachSet: json['showRestTimerAfterEachSet'] ?? false,
      isMetricSystemSelected: json['isMetricSystemSelected'] ?? false,
      autoPopulateWorkoutFromSetsHistory:
          json['autoPopulateTrackedExerciseFromLatest'] ?? false,
      autoCollapseTrackedExercises:
          json['autoCollapseTrackedExercises'] ?? false,
      hasAcknowledgeDataStorageDisclaimer:
          json['hasAcknowledgeDataStorageDisclaimer'] ?? false,
      lastNavigatorPageIndex: json['lastNavigatorPageIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'showRestTimerAfterEachSet': showRestTimerAfterEachSet,
      'isMetricSystemSelected': isMetricSystemSelected,
      'autoPopulateTrackedExerciseFromLatest':
          autoPopulateWorkoutFromSetsHistory,
      'autoCollapseTrackedExercises': autoCollapseTrackedExercises,
      'hasAcknowledgeDataStorageDisclaimer':
          hasAcknowledgeDataStorageDisclaimer,
      'lastNavigatorPageIndex': lastNavigatorPageIndex,
    };
  }
}
