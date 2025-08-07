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
              TimeOfDay(hour: 10, minute: 0),
              TimeOfDay(hour: 11, minute: 0),
            );
          },
          child: Text('Create timer'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.startService,
          child: Text('Start service'),
        ),
        ElevatedButton(
          onPressed: LinuxScheduler.deleteService,
          child: Text('Delete service'),
        ),
      ],
    );
  }
}
