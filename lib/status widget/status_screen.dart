import 'dart:math' as math;
import 'package:cgw_app/pressed_card.dart';
import 'package:cgw_app/status%20widget/sliding_knob.dart';
import 'package:flutter/material.dart';
import 'status_button.dart';

class WideTrafficWidget extends StatelessWidget {
  final int running;
  final int stop;
  final int error;

  const WideTrafficWidget({
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
              SlidingTriStateKnob(
                width: 100,
                height: 25,
                onPressedOn: () async {
                  // action for On (can be async)
                  print('ON pressed');
                },
                onPressedOff: () {
                  // action for Off
                  print('OFF pressed');
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
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        _buildRow('Running', running, const Color(0xFF4CAF50)),
                        const Divider(
                          color: Color.fromARGB(255, 138, 137, 137),
                          height: 12,
                        ),
                        _buildRow('Stop', stop, const Color(0xFFF9A825)),
                        const Divider(
                          color: Color.fromARGB(255, 138, 137, 137),
                          height: 12,
                        ),
                        _buildRow('Error', error, const Color(0xFFB91C1C)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusButton(
                type: StatusType.running,
                label: 'RUNNING',
                onTap: () => print('Running ...'),
              ),
              const SizedBox(width: 12),
              StatusButton(
                type: StatusType.stop,
                label: 'STOP',
                onTap: () => print('stoping.'),
              ),
              const SizedBox(width: 12),
              StatusButton(
                type: StatusType.error,
                label: 'ERROR',
                onTap: () => print('errors'),
              ),
            ],
          ),
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
    drawSegment(stop, const Color(0xFFD97706), false);
    drawSegment(error, const Color(0xFFDC2626), true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
