import 'package:shortest_path_app/models/path_task.dart';

class ApiResponse {
  final bool error;
  final String message;
  final List<PathTask> data;

  const ApiResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => PathTask.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };
}
