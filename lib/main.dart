import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            children: [
              SwitchListTile(
                onChanged: (value) {
                  setState(() {
                    enabled = value;
                  });
                },
                title: Text("Enabled"),
                value: enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
