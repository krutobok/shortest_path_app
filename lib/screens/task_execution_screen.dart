import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shortest_path_app/models/api_response.dart';
import 'package:shortest_path_app/models/path_response.dart';
import 'package:shortest_path_app/models/path_result.dart';
import 'package:shortest_path_app/models/path_task.dart';
import 'package:shortest_path_app/models/point.dart';
import 'package:shortest_path_app/screens/results_screen.dart';
import 'package:shortest_path_app/shortest_path_logic.dart';

class TaskExecutionScreen extends StatefulWidget {
  final String baseUrl;

  const TaskExecutionScreen({super.key, required this.baseUrl});

  @override
  State<TaskExecutionScreen> createState() => _TaskExecutionScreenState();
}

class _TaskExecutionScreenState extends State<TaskExecutionScreen> {
  static const totalSteps = 100;
  int stepSending = 1;
  double step = 1;
  String loaderText = 'Request to the server is in progress';
  double _progress = 0.0;
  bool _isSendingResults = false;
  String? _errorMessage;
  List<PathTask> shortestPathTasks = [];
  List<PathResult> shortestPathResults = [];

  @override
  void initState() {
    super.initState();
    _startTaskExecution();
  }

  Future<void> _startTaskExecution() async {
    setState(() {
      _errorMessage == null;
    });
    final url = widget.baseUrl;
    void loading() async {
      while (step < totalSteps - 1) {
        await Future.delayed(const Duration(milliseconds: 30));
        setState(() {
          if (step < totalSteps) {
            step++;
            _progress = step / totalSteps;
          }
        });
      }
    }

    try {
      setState(() {
        loaderText = 'Request to the server is in progress';
      });
      loading();
      final response = await http.get(Uri.parse(url));
      setState(() {
        step = totalSteps.toDouble();
        _progress = step / totalSteps;
      });
      if (response.statusCode == 200) {
        setState(() {
          step = 0;
          _progress = step / totalSteps;
        });
        setState(() {
          loaderText = 'Calculations are in progress';
        });
        final apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
        final data = apiResponse.data;
        //test code for more complicated example
        // final data = [
        //   PathTask(
        //       id: '1',
        //       field: ['..X', '.X.', '.XX'],
        //       start: Point(0, 2),
        //       end: Point(2, 1))
        // ];
        // final data = apiResponse.data
        // .map(
        //   (e) => PathTask(
        //     id: e.id,
        //     field: e.field,
        //     start: e.start.invert(),
        //     end: e.end.invert(),
        //   ),
        // )
        // .toList(); // координати міняються на оборотні для коректної роботи алгоритму. Як варіант можна було зробити це в самому алгоритмі(в конструкторі класу Grid), але я обрав цей спосіб
        for (int i = 0; i < data.length; i++) {
          Grid gridObj = Grid(data[i]);
          shortestPathTasks.add(data[i]);
          List<Point> shortestPath = gridObj.findShortestPath();
          PathResult result =
              PathResult.fromShortestPath(shortestPath, data[i].id);
          // PathResult result =
          //     PathResult.fromShortestPath(shortestPath.invert(), data[i].id);
          shortestPathResults.add(result);
          setState(() {
            step += totalSteps / data.length;
            _progress = step / totalSteps;
          });
        }
        setState(() {
          loaderText =
              'All calculations have finished, you can send your results to the servers';
          stepSending = 2;
        });
      } else {
        setState(() {
          _errorMessage =
              'Error: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _progress = 0.0;
        _errorMessage = 'Failed to load tasks: $e';
      });
    }
  }

  Future<void> _sendResultsToServer() async {
    setState(() {
      _errorMessage == null;
    });
    setState(() {
      _isSendingResults = true;
    });
    try {
      List<Map<String, dynamic>> jsonResponses = shortestPathResults
          .map((e) => PathResponse(result: e).toJson())
          .toList();
      final response = await http.post(
        Uri.parse(widget.baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonResponses),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSendingResults = false;
          _errorMessage = null;
        });
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                results: shortestPathResults,
                tasks: shortestPathTasks,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _isSendingResults = false;
          _errorMessage = 'Failed to send results: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isSendingResults = false;
        _errorMessage = 'Failed to send results: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Process screen',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else
              Text(
                loaderText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            Text('${(_progress * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: ((_progress < 1.0 && _errorMessage == null) ||
                      _isSendingResults)
                  ? null
                  : stepSending == 1
                      ? _startTaskExecution
                      : _sendResultsToServer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: ((_progress < 1.0 && _errorMessage == null) ||
                      _isSendingResults)
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      stepSending == 1
                          ? 'Start counting process'
                          : 'Send results to server',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
