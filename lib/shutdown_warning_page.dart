import 'package:flutter/material.dart';

class ShutdownWarningPage extends StatefulWidget {
  const ShutdownWarningPage({super.key});

  @override
  State<StatefulWidget> createState() => _ShutdownWarningPage();
}

class _ShutdownWarningPage extends State<ShutdownWarningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shutdown Warning'),
      ),
      body: const Center(
        child: Text('This is a warning that the app will shutdown.'),
      ),
    );
  }
}
