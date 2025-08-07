import 'package:flutter/material.dart';
import 'package:go_sleep/linux_scheduler.dart';

class SystemdPage extends StatelessWidget {
  const SystemdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        ElevatedButton(
          onPressed: LinuxScheduler.createService,
          child: Text('Create service'),
        ),
        ElevatedButton(
          onPressed: () {
            LinuxScheduler.createTimer(
              TimeOfDay(hour: 15, minute: 2),
              TimeOfDay(hour: 3, minute: 0),
            );
          },
          child: Text('Create timer'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.startService,
          child: Text('Start service'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.startTimer,
          child: Text('Start timer'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.deleteService,
          child: Text('Delete service'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.deleteTimer,
          child: Text('Delete timer'),
        ),
      ],
    );
  }
}
