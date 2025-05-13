const templateEmpahasis = [
  'Whole Body',
  'Upper Body',
  'Lower Body',
  'Chest & Back',
  'Arms & Shoulders',
  'Back & Biceps',
  'Chest & Triceps',
  'Glutes & Abs'
];

const sex = ["male", "female"];

class TemplateDto {
  late String id;

  String name;
  String emphasis;
  String sex;
  String? createdAt;
  String? updatedAt;
  List<TemplateDayDto>? days;

  TemplateDto({
    required this.id,
    required this.name,
    required this.emphasis,
    required this.sex,
    this.days,
    this.createdAt,
    this.updatedAt,
  });

  int get numberOfDays => days?.length ?? 5;

  factory TemplateDto.fromJson(Map<String, dynamic> json) {
    var id = json['key'] as String;
    /*
    // parse days
    final daysRegex = RegExp(r'-([2345])x');
    final match = daysRegex.firstMatch(id);
    var parsedNumberOfDays = match != null ? int.parse(match.group(1)!) : 5;
    */
    List<TemplateDayDto> tempDays = [];
    try {
      tempDays = (json['days'] as List)
          .map(
            (x) => TemplateDayDto.fromJson(x),
          )
          .toList();
    } catch (ex) {
      print(ex);
    }

    return TemplateDto(
      id: id,
      name: json['name'] as String,
      emphasis: json['emphasis'] as String,
      sex: json['sex'] as String,
      days: tempDays,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'days': days,
      'name': name,
      'emphasis': emphasis,
      'sex': sex,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class TemplateDayDto {
  String templateId;
  int position;
  List<TemplateDaySlotDto> slots;

  TemplateDayDto({
    required this.templateId,
    required this.position,
    required this.slots,
  });

  factory TemplateDayDto.fromJson(Map<String, dynamic> json) {
    return TemplateDayDto(
      templateId: '${json['templateId']}',
      position: json['position'] as int,
      slots: (json['slots'] as List)
          .map(
            (x) => TemplateDaySlotDto.fromJson(x),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templateId': templateId,
      'position': position,
      'slots': slots.map((x) => x.toJson()).toList(),
    };
  }
}

class TemplateDaySlotDto {
  String muscleGroupId;
  String? exerciseId;

  TemplateDaySlotDto({
    required this.muscleGroupId,
    this.exerciseId,
  });

  factory TemplateDaySlotDto.fromJson(Map<String, dynamic> json) {
    return TemplateDaySlotDto(
      muscleGroupId: '${json['muscleGroupId']}',
      exerciseId: json['exerciseId'] != null ? '${json['exerciseId']}' : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'muscleGroupId': muscleGroupId,
      'exerciseId': exerciseId,
    };
  }
}
