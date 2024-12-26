import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CronTestPage extends StatefulWidget {
  const CronTestPage({super.key});

  @override
  State<CronTestPage> createState() => _CronTestPage();
}

class _CronTestPage extends State<CronTestPage> {
  static const platform = MethodChannel('go_sleep.yolisses.com');

  Future<void> _shutdown() async {
    try {
      await platform.invokeMethod('shutdown');
    } on PlatformException catch (e) {
      print("Failed to shutdown: '${e.message}'.");
    }
  }

  void _onPressed() {
    final cron = Cron();

    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print('every single minute');
      _shutdown();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Cron Test Page'),
            ElevatedButton(onPressed: _onPressed, child: Text('Cron Test')),
          ],
        ),
      ),
    );
  }
}
