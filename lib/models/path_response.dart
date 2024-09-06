import 'package:shortest_path_app/models/path_result.dart';

class PathResponse {
  final PathResult result;

  PathResponse({
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'id': result.id,
        'result': result.toJsonAsResult(),
      };
}
