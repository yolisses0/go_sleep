import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

class LinuxScheduler {
  static final String homeDir =
      Platform.environment['SNAP_REAL_HOME'] ??
      Platform.environment['HOME'] ??
      '';
  static final servicePath = '$homeDir/.config/systemd/user/go_sleep.service';
  static final timerPath = '$homeDir/.config/systemd/user/go_sleep.timer';

  static final String executablePath = Platform.environment['SNAP'] != null
      ? '/snap/bin/go-sleep'
      // For development
      : '${Directory.current.path}/build/linux/x64/debug/bundle/go_sleep';

  static void createService() {
    final content =
        """[Unit]
Description=Go Sleep

[Service]
ExecStart=$executablePath --sleep
Type=simple

[Install]
WantedBy=default.target
""";
    final file = File(servicePath);
    file.writeAsStringSync(content);
  }

  static void deleteService() async {
    await runCommand('systemctl', ['--user', 'stop', 'go_sleep.service']);
    final file = File(servicePath);
    await file.delete();
  }

  static void deleteTimer() async {
    await runCommand('systemctl', ['--user', 'stop', 'go_sleep.timer']);
    await runCommand('systemctl', ['--user', 'disable', 'go_sleep.timer']);
    final file = File(timerPath);
    await file.delete();
  }

  static List<String> createOnCalendar(TimeOfDay startTime, TimeOfDay endTime) {
    final List<String> result = [];
    final hourDifference = endTime.hour - startTime.hour;
    if (hourDifference == 0) {
      final [first, second] = startTime.isAfter(endTime)
          ? [endTime, startTime]
          : [startTime, endTime];
      result.add('${startTime.hour}:${first.minute}..${second.minute}:0/1');
    } else if (startTime.isBefore(endTime)) {
      result.add('${startTime.hour}:${startTime.minute}..59:0/1');
      if (endTime.hour - startTime.hour > 1) {
        result.add('${startTime.hour + 1}..${endTime.hour - 1}:*:0/1');
      }
      result.add('${endTime.hour}:0..${endTime.minute}:0/1');
    } else {
      result.add('${startTime.hour}:${startTime.minute}..59:0/1');
      if (24 - startTime.hour > 1) {
        result.add('${startTime.hour + 1}..23:*:0/1');
      }
      if (endTime.hour > 0) {
        result.add('0..${endTime.hour - 1}:*:0/1');
      }
      result.add('${endTime.hour}:0..${endTime.minute}:0/1');
    }
    return result;
  }

  static void createTimer(TimeOfDay startTime, TimeOfDay endTime) async {
    final lines =[ ];
    lines.add('[Unit]');
    lines.add('Description=Go Sleep scheduled start');
    lines.add('[Timer]');
    lines.add('AccuracySec=100ms');
    final onCalendars = createOnCalendar(startTime, endTime);
    for (var onCalendar in onCalendars) {
      lines.add('OnCalendar=$onCalendar');
    }
    lines.add('[Install]');
    lines.add('WantedBy=timers.target');
    final content = lines.join('\n');
    final file = File(timerPath);
    file.writeAsStringSync(content);
  }

  static Future runCommand(String command, List<String> arguments) async {
    final result = await Process.run(command, arguments);
    log(result.stdout.toString());
    log(result.stderr.toString());
    if (result.exitCode != 0) {
      throw Exception("Exit code different than zero");
    }
  }

  static void startService() async {
    await runCommand('systemctl', ['--user', 'unmask', 'go_sleep.service']);
    await runCommand('systemctl', ['--user', 'daemon-reload']);
    await runCommand('systemctl', ['--user', 'start', 'go_sleep.service']);
  }

  static void startTimer() async {
    await runCommand('systemctl', ['--user', 'unmask', 'go_sleep.timer']);
    await runCommand('systemctl', ['--user', 'daemon-reload']);
    await runCommand('systemctl', ['--user', 'enable', 'go_sleep.timer']);
    await runCommand('systemctl', ['--user', 'start', 'go_sleep.timer']);
  }
}
