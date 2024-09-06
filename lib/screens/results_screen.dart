import 'package:flutter/material.dart';
import 'package:shortest_path_app/models/path_result.dart';
import 'package:shortest_path_app/models/path_task.dart';
import 'package:shortest_path_app/screens/result_detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<PathResult> results;
  final List<PathTask> tasks;

  const ResultsScreen({super.key, required this.results, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result list screen',
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
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                results[index].path,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultDetailScreen(
                        result: results[index], task: tasks[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// class ResultDetailScreen extends StatelessWidget {
//   final String result;

//   const ResultDetailScreen({super.key, required this.result});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Shortest Path:',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 8.0),
//             Text(result),
//           ],
//         ),
//       ),
//     );
//   }
// }
