import 'package:flutter/material.dart';
import 'package:go_sleep/linux_scheduler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              // Process.run('shutdown', ['now']);
              print('shutdown');
              LinuxScheduler.schedule();
            },
            child: Text('Press me'),
          ),
        ),
      ),
    );
  }
}
