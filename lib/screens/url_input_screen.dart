import 'package:flutter/material.dart';
import 'package:shortest_path_app/screens/task_execution_screen.dart';

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  String? _errorMessage;
  bool _isValidUrl(String url) {
    const urlPattern =
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    return RegExp(urlPattern).hasMatch(url);
  }

  void _onStartPressed() {
    if (_formKey.currentState!.validate()) {
      String baseUrl = _urlController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskExecutionScreen(baseUrl: baseUrl)),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set valid API base URL in order to continue'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.compare_arrows,
                    size: 24,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'Enter the base URL',
                        errorText: _errorMessage,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a URL';
                        } else if (!_isValidUrl(value)) {
                          return 'Invalid URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onStartPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Start counting process',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
