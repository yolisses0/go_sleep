import 'package:flutter/material.dart';
import 'package:go_sleep/linux_scheduler.dart';
import 'package:go_sleep/time_graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDarkMode: isDarkMode,
        onThemeToggle: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool enabled = false;
  TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 7, minute: 0);

  void _handleScheduleToggle(bool value) {
    setState(() {
      enabled = value;
    });

    if (value) {
      try {
        LinuxScheduler.createService();
        LinuxScheduler.createTimer(startTime, endTime);
        LinuxScheduler.startService();
        LinuxScheduler.startTimer();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to enable scheduling'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          enabled = false;
        });
      }
    } else {
      try {
        LinuxScheduler.deleteService();
        LinuxScheduler.deleteTimer();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to disable scheduling'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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

      // Update scheduler if enabled
      if (enabled) {
        try {
          LinuxScheduler.createTimer(startTime, endTime);
          LinuxScheduler.startTimer();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update schedule'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: TimeGraph(
                    startTime: startTime,
                    endTime: endTime,
                    size: 200,
                  ),
                ),
              ),
              SwitchListTile(
                onChanged: _handleScheduleToggle,
                title: const Text("Enabled"),
                value: enabled,
              ),
              ListTile(
                title: const Text("Time to shutdown"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    startTime.format(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: const Text("Time to allow usage"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    endTime.format(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                onTap: () => _selectTime(context, false),
              ),

              SwitchListTile(
                onChanged: (_) => widget.onThemeToggle(),
                title: const Text("Dark Mode"),
                value: widget.isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
