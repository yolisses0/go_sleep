import 'package:flutter/material.dart';
import 'package:go_sleep/sleep_page.dart';
import 'package:go_sleep/systemd_page.dart';

void main(List<String> args) {
  final shouldSleep = args.contains('--sleep');
  runApp(MyApp(shouldSleep: shouldSleep));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.shouldSleep});

  final bool shouldSleep;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Sleep',
      theme: ThemeData(splashColor: const Color(0xFF784421)),
      home: shouldSleep ? SleepPage() : SystemdPage(),
    );
  }
}
