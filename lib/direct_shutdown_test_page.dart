import 'dart:io';

import 'package:flutter/material.dart';

class DirectShutdownTestPage extends StatefulWidget {
  const DirectShutdownTestPage({super.key});

  @override
  State<DirectShutdownTestPage> createState() => _DirectShutdownTestPageState();
}

class _DirectShutdownTestPageState extends State<DirectShutdownTestPage> {
  void onPressed() {
    Process.run('shutdown', ['now']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Direct Shutdown Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Is it time to say goodbye? Goodbye, goodbye?',
            ),
            ElevatedButton(onPressed: onPressed, child: const Text('Shutdown')),
          ],
        ),
      ),
    );
  }
}
