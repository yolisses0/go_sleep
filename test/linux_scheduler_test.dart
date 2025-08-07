import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_sleep/linux_scheduler.dart';

void main() {
  test('same hour', () {
    final onCalendar = LinuxScheduler.createOnCalendar(
      TimeOfDay(hour: 1, minute: 2),
      TimeOfDay(hour: 1, minute: 4),
    );
    expect(onCalendar, "");
  });
}
