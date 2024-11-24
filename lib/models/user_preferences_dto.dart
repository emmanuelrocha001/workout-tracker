class UserPreferenceDto {
  String? userName;
  bool showRestTimerAfterEachSet;
  bool isMetricSystemSelected;

  UserPreferenceDto(
      {this.userName = '',
      this.showRestTimerAfterEachSet = false,
      this.isMetricSystemSelected = false});

  factory UserPreferenceDto.fromJson(Map<String, dynamic> json) {
    return UserPreferenceDto(
      userName: json['userName'] ?? '',
      showRestTimerAfterEachSet: json['showRestTimerAfterEachSet'] ?? false,
      isMetricSystemSelected: json['isMetricSystemSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'showRestTimerAfterEachSet': showRestTimerAfterEachSet,
      'isMetricSystemSelected': isMetricSystemSelected,
    };
  }
}
