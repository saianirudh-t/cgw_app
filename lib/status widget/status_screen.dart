import 'dart:math' as math;

import 'package:cgw_app/pressed_card.dart';
import 'package:cgw_app/status%20widget/status_row.dart';
import 'package:flutter/material.dart';
import 'device_info.dart';
import 'package:cgw_app/status widget/settings_icon.dart';
import 'package:cgw_app/splash screen/login_card.dart';

class StatusScreen extends StatefulWidget {
  final int running;
  final int stop;
  final int error;
  final DeviceConfigResult? result;
  const StatusScreen({
    Key? key,
    required this.running,
    required this.stop,
    required this.error,
    this.result,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool _infopressed = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.result?.deviceName ?? 'Unknown device';
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
                onTap: () async {
                  setState(() {
                    _infopressed = true;
                  });
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;
                  final Offset offset = renderBox.localToGlobal(Offset.zero);
                  // 2. Open your separate menu container at that precise location
                  await showMenu<void>(
                    context: context,
                    useRootNavigator: true,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.white,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy + 50,
                      offset.dx + renderBox.size.width,
                      offset.dy,
                    ),

                    items: [
                      PopupMenuItem<void>(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: DeviceInfo(result: widget.result),
                      ),
                    ],
                  );
                  if (mounted) {
                    setState(() {
                      _infopressed = false;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ), //text
                    Icon(
                      _infopressed ? Icons.expand_less : Icons.expand_more,
                      size: 30,
                    ),
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
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 1. The Gauge
                SizedBox(
                  height: 130,
                  width: 260,
                  child: CustomPaint(
                    painter: GaugePainter(
                      running: widget.running,
                      stop: widget.stop,
                      error: widget.error,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 199, 199, 199),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade50, // Very soft border line
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Hug content tightly
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline
                          .alphabetic, // Aligns baselines of text and number
                      children: [
                        Text(
                          "Total : ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "${widget.running + widget.stop + widget.error}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          StatusRow(
            running: widget.running,
            stop: widget.stop,
            error: widget.error,
          ),
          const SizedBox(height: 15),
        ],
      ),
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
