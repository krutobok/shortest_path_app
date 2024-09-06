import 'package:flutter/material.dart';
import 'package:shortest_path_app/constants/colors.dart';
import 'package:shortest_path_app/models/path_result.dart';
import 'package:shortest_path_app/models/path_task.dart';
import 'package:shortest_path_app/models/point.dart';

class ResultDetailScreen extends StatelessWidget {
  final PathTask task;
  final PathResult result;

  const ResultDetailScreen({
    super.key,
    required this.task,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final gridSize = task.field[0].length;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: SizedBox(
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize, // Кількість колонок
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  int x = index ~/ gridSize;
                  int y = index % gridSize;
                  String cellType = task.field[x][y];

                  return GridCell(
                    cellType: cellType,
                    result: result,
                    point: Point(y, x),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            result.path,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final Point point;
  final String cellType;
  final PathResult result;
  const GridCell(
      {super.key,
      required this.result,
      required this.point,
      required this.cellType});

  @override
  Widget build(BuildContext context) {
    Color cellColor = AppColors.emptyCell;
    Color textColor = Colors.black;
    if (cellType == 'X') {
      cellColor = AppColors.blockedCell;
      textColor = Colors.white;
    } else if (result.steps.first == point) {
      cellColor = AppColors.startCell;
    } else if (result.steps.last == point) {
      cellColor = AppColors.endCell;
    } else if (result.steps.contains(point)) {
      cellColor = AppColors.shortestPathCell;
    }
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        color: cellColor,
      ),
      child: Center(
        child: Text(
          point.toString(),
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
