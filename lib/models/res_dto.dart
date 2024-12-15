class ResDto {
  final String? message;
  final bool success;
  final dynamic data;

  ResDto({
    this.message = "",
    required this.success,
    this.data,
  });

  // factory ResDto.fromJson(Map<String, dynamic> json) {
  //   return ResDto(
  //     message: json['message'],
  //     success: json['success'],
  //     data: json['data'],
  //   );
  // }
}
