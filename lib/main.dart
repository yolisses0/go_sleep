import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_sleep/custom_overlay.dart';
import 'package:system_alert_window/system_alert_window.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: CustomOverlay()));
}

void _openOverlayWindow() async {
  await SystemAlertWindow.sendMessageToOverlay('show system window');
  SystemAlertWindow.showSystemWindow(
    height: 200,
    width: 200,
    gravity: SystemWindowGravity.CENTER,
    prefMode: SystemWindowPrefMode.OVERLAY,
    layoutParamFlags: [SystemWindowFlags.FLAG_NOT_FOCUSABLE],
  );
}

@pragma('vm:entry-point')
void launchApp() async {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId");
  // This will bring the app to the foreground
  _openOverlayWindow();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());

  final int alarmId = 0;
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10),
    alarmId,
    launchApp,
  );
}

Future<void> _requestPermissions() async {
  await SystemAlertWindow.requestPermissions(
    prefMode: SystemWindowPrefMode.OVERLAY,
  );
}

void _closeOverlayWindow() async {
  SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
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
              TextButton(
                onPressed: _requestPermissions,
                child: Text('Request permission'),
              ),
              TextButton(
                onPressed: _openOverlayWindow,
                child: Text('Open overlay'),
              ),
              TextButton(
                onPressed: _closeOverlayWindow,
                child: Text('Close overlay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
