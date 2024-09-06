import 'dart:collection';

import 'package:shortest_path_app/models/path_task.dart';
import 'package:shortest_path_app/models/point.dart';

class Grid {
  final List<List<String>> grid;
  final Point start;
  final Point end;

  Grid(PathTask task)
      : grid = task.field.map((row) => row.split('')).toList(),
        start = task.start.invert(),
        end = task.end.invert();

  bool isValid(Point p) {
    return p.x >= 0 &&
        p.x < grid.length &&
        p.y >= 0 &&
        p.y < grid.length &&
        grid[p.x][p.y] == '.';
  }

  List<Point> getNeighbors(Point p) {
    List<Point> directions = const [
      Point(1, 0),
      Point(-1, 0),
      Point(0, 1),
      Point(0, -1),
      Point(1, 1),
      Point(1, -1),
      Point(-1, 1),
      Point(-1, -1),
    ];

    List<Point> neighbors = [];

    for (var dir in directions) {
      int newX = p.x + dir.x;
      int newY = p.y + dir.y;
      Point neighbor = Point(newX, newY);
      if (isValid(neighbor)) {
        neighbors.add(neighbor);
      }
    }

    return neighbors;
  }

  List<Point> findShortestPath() {
    Queue<List<Point>> queue = Queue();
    Set<Point> visited = {};

    queue.add([start]);
    visited.add(start);

    while (queue.isNotEmpty) {
      List<Point> path = queue.removeFirst();
      Point current = path.last;

      if (current == end) {
        return path.invert();
      }

      for (Point neighbor in getNeighbors(current)) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          List<Point> newPath = List.from(path)..add(neighbor);
          queue.add(newPath);
        }
      }
    }

    return [];
  }
}

extension on List<Point> {
  List<Point> invert() {
    return map((e) => Point(e.y, e.x)).toList();
  }
}
