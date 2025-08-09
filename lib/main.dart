import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enabled = false;
  TimeOfDay startTime = TimeOfDay(hour: 22, minute: 0); // 10 PM default
  TimeOfDay endTime = TimeOfDay(hour: 7, minute: 0); // 7 AM default

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ListTile(
              title: Text("Time to shutdown"),
              trailing: Text('${startTime.format(context)}'),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text("Time to allow usage"),
              trailing: Text('${endTime.format(context)}'),
              onTap: () => _selectTime(context, false),
            ),
          ],
        ),
      ),
    );
  }
}
