import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_sleep/overlay_content.dart';
import 'package:go_sleep/overlay_page.dart';
import 'package:go_sleep/sleep_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.contains('--overlay')) {
    runApp(MaterialApp(home: OverlayContent()));
    return;
  }

  final shouldSleep = args.contains('--sleep');
  final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  runApp(MyApp(shouldSleep: shouldSleep, isAndroid: isAndroid));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.shouldSleep, required this.isAndroid});

  final bool shouldSleep;
  final bool isAndroid;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Sleep',
      theme: ThemeData(splashColor: const Color(0xFF784421)),
      home: shouldSleep ? SleepPage() : OverlayPage(),
    );
  }
}
