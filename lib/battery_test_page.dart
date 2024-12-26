import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryTestPage extends StatefulWidget {
  const BatteryTestPage({super.key});

  @override
  State<BatteryTestPage> createState() => _BatteryTestPageState();
}

class _BatteryTestPageState extends State<BatteryTestPage> {
  static const platform = MethodChannel('go_sleep.yolisses.com');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}
