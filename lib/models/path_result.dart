import 'package:shortest_path_app/models/point.dart';

class PathResult {
  final List<Point> steps;
  final String path;
  final String id;

  PathResult({
    required this.steps,
    required this.path,
    required this.id,
  });
  Map<String, dynamic> toJson() => {
        'steps': steps.map((step) => step.toJson()).toList(),
        'path': path,
        'id': id,
      };
  Map<String, dynamic> toJsonAsResult() => {
        'steps': steps.map((step) => step.toJson()).toList(),
        'path': path,
      };
  factory PathResult.fromShortestPath(List<Point> shortestPath, String taskId) {
    String formattedPath =
        shortestPath.map((p) => '(${p.x},${p.y})').join('->');
    return PathResult(steps: shortestPath, path: formattedPath, id: taskId);
  }
}
