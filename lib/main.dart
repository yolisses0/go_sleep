import 'package:flutter/material.dart';

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
  TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0); // 10 PM default
  TimeOfDay endTime = const TimeOfDay(hour: 7, minute: 0); // 7 AM default

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              SwitchListTile(
                onChanged: (value) {
                  setState(() {
                    enabled = value;
                  });
                },
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
