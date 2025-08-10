import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("Background task: $task");
    // Your background work here
    return Future.value(true);
  });
}

void _schedule() async {
  log("Schedule");
  Workmanager().registerOneOffTask(
    "task-id",
    "simpleTask",
    initialDelay: Duration(seconds: 10),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            children: [
              TextButton(onPressed: _schedule, child: Text('Schedule')),
            ],
          ),
        ),
      ),
    );
  }
}
