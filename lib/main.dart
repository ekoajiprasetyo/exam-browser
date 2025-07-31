import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'lock_task.dart';

void main() {
  runApp(const ExamBrowserApp());
}

class ExamBrowserApp extends StatelessWidget {
  const ExamBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Browser',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const UrlInputPage(),
    );
  }
}

class UrlInputPage extends StatefulWidget {
  const UrlInputPage({super.key});

  @override
  State<UrlInputPage> createState() => _UrlInputPageState();
}

class _UrlInputPageState extends State<UrlInputPage> {
  final TextEditingController _controller = TextEditingController();

  void _open() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    final url = raw.startsWith('http') ? raw : 'https://$raw';
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BrowserPage(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Browser')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Exam URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onSubmitted: (_) => _open(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _open,
              child: const Text('Start Exam'),
            ),
          ],
        ),
      ),
    );
  }
}

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key, required this.url});

  final String url;

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    LockTask.start();
  }

  @override
  void dispose() {
    LockTask.stop();
    super.dispose();
  }

  void _exit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _exit,
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
