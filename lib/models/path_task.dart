import 'package:shortest_path_app/models/point.dart';

class PathTask {
  final String id;
  final List<String> field;
  final Point start;
  final Point end;

  const PathTask({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory PathTask.fromJson(Map<String, dynamic> json) {
    return PathTask(
      id: json['id'] as String,
      field: List<String>.from(json['field']),
      start: Point.fromJson(json['start']),
      end: Point.fromJson(json['end']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'field': field,
        'start': start.toJson(),
        'end': end.toJson(),
      };
}
