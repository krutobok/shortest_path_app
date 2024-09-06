class Point {
  final int x;
  final int y;

  // const Point({
  //   required this.x,
  //   required this.y,
  // });
  const Point(
    this.x,
    this.y,
  );

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      json['x'] as int,
      json['y'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';
  Point invert() => Point(y, x);
}
