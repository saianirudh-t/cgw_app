import 'dart:math' as math;
import 'package:cgw_app/status%20widget/settings_icon.dart';
import 'package:cgw_app/pressed_card.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  final int running;
  final int stop;
  final int error;

  const StatusScreen({
    super.key,
    required this.running,
    required this.stop,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Making it wide and adjusting padding
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15, left: 24, right: 24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PressableCard(
                onTap: () {
                  print("Device info pressed");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 2,
                  children: [
                    const Text(
                      'CGW0954',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    const Icon(Icons.expand_more, size: 30),
                  ],
                ),
              ),
              SettingsButton(
                onTap: () {
                  print("settings pressed");
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Stack allows placing labels inside the Arc
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 1. The Gauge
                SizedBox(
                  height: 140,
                  width: 280,
                  child: CustomPaint(
                    painter: GaugePainter(
                      running: running,
                      stop: stop,
                      error: error,
                    ),
                  ),
                ),
                // 2. The Internal Labels
                Center(
                  child: SizedBox(
                    width: 120,
                    child: Text("Total : ${running + stop + error}"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Container(child: Text("Running : $running")),
              Container(child: Text("Stop : $stop")),
              Container(child: Text("Error : $error")),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 14)),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final int running, stop, error;
  GaugePainter({
    required this.running,
    required this.stop,
    required this.error,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = (running + stop + error).toDouble();
    if (total == 0) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.width);
    const double strokeWidth = 40;
    const double gap = 0.06;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double currentAngle = math.pi;

    void drawSegment(int count, Color color, bool isLast) {
      if (count <= 0) return;
      double sweep = (count / total) * math.pi;
      paint.color = color;
      canvas.drawArc(
        rect,
        currentAngle,
        isLast ? sweep : sweep - gap,
        false,
        paint,
      );
      currentAngle += sweep;
    }

    drawSegment(running, const Color(0xFF16A34A), false);
    drawSegment(stop, const Color(0xFFF9A825), false);
    drawSegment(error, const Color(0xFFDC2626), true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
