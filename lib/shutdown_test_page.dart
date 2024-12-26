import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShutdownTestPage extends StatefulWidget {
  const ShutdownTestPage({super.key});

  @override
  State<ShutdownTestPage> createState() => _ShutdownTestPageState();
}

class _ShutdownTestPageState extends State<ShutdownTestPage> {
  static const platform = MethodChannel('go_sleep.yolisses.com');

  Future<void> _shutdown() async {
    try {
      await platform.invokeMethod('shutdown');
    } on PlatformException catch (e) {
      print("Failed to shutdown: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _shutdown,
              child: const Text('Shutdown'),
            ),
          ],
        ),
      ),
    );
  }
}
