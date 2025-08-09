import 'dart:math';

import 'package:flutter/material.dart';

class TimeGraph extends StatelessWidget {
  final TimeOfDay shutdownTime;
  final TimeOfDay wakeupTime;
  final double size;

  const TimeGraph({
    super.key,
    required this.shutdownTime,
    required this.wakeupTime,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: TimeGraphPainter(
          shutdownTime: shutdownTime,
          wakeupTime: wakeupTime,
        ),
      ),
    );
  }
}

class TimeGraphPainter extends CustomPainter {
  final TimeOfDay shutdownTime;
  final TimeOfDay wakeupTime;

  TimeGraphPainter({required this.shutdownTime, required this.wakeupTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the circle background
    final circlePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, circlePaint);

    // Convert TimeOfDay to angles (0° is at 12 o'clock, moving clockwise)
    final shutdownAngle = _timeToAngle(shutdownTime);
    final wakeupAngle = _timeToAngle(wakeupTime);

    // Draw the arc for shutdown period
    final arcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      shutdownAngle,
      _calculateSweepAngle(shutdownAngle, wakeupAngle),
      false,
      arcPaint,
    );

    // Draw hour markers
    _drawHourMarkers(canvas, center, radius);
  }

  double _timeToAngle(TimeOfDay time) {
    // Convert time to angle (starting from 12 o'clock)
    final hours = time.hour + time.minute / 60;
    return (hours - 6) * (pi / 6); // Subtract 6 to start from right side
  }

  double _calculateSweepAngle(double start, double end) {
    double sweep = end - start;
    if (sweep < 0) sweep += 2 * pi;
    return sweep;
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius) {
    final markerPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int hour = 0; hour < 24; hour++) {
      final angle = (hour - 6) * (pi / 12);
      final markerStart = Offset(
        center.dx + (radius - 8) * cos(angle),
        center.dy + (radius - 8) * sin(angle),
      );
      final markerEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawLine(markerStart, markerEnd, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
