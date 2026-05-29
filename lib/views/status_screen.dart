import 'dart:math' as math;
import 'package:cgw_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:cgw_app/assets/settings_icon.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/device_details.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({
    super.key,
  });
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _infopressed = false;
  final UserControllers ctrl = Get.find<UserControllers>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Making it wide and adjusting padding
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 2,
                children: [
                  Obx(
                    () => Text(
                      ctrl.deviceName.value,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ), //text
                  Icon(
                    _infopressed ? Icons.expand_less : Icons.expand_more,
                    size: 30,
                  ),
                ],
              ),

              SettingsButton(
                onTap: () {
                  Get.toNamed(AppRoutes.Settings);
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Obx(() {
            final name = ctrl.deviceName.value;
            final running = ctrl.running.value;
            final stop = ctrl.stop.value;
            final error = ctrl.error.value;
            final total = (running + stop + error);
            if (name == 'no device') {
              return Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off, size: 40, color: Colors.grey[500]),
                      SizedBox(height: 8),
                      Text(
                        'No Device Connected',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                // Gauge area
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
                            running: running,
                            stop: stop,
                            error: error,
                            total: total.toDouble(),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // Hug content tightly
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
                                "$total",
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
                SizedBox(height: 12), // StatusRow (same Obx covers it)
                StatusRow(running: running, stop: stop, error: error),
                SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final int running, stop, error;
  final double total;

  GaugePainter({
    required this.running,
    required this.stop,
    required this.error,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

class StatusRow extends StatelessWidget {
  final int running;
  final int stop;
  final int error;

  const StatusRow({
    super.key,
    required this.running,
    required this.stop,
    required this.error,
  });

  Widget _badge({required Color dotColor, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 164, 164, 164),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double Breakpoint2 = 420;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        final double space = w <= Breakpoint2 ? 0 : 30;

        final children = <Widget>[
          _badge(
            dotColor: const Color(0xFF4CAF50),

            label: 'Running : $running',
          ),
          _badge(dotColor: const Color(0xFFFFB74D), label: 'Stop : $stop'),
          _badge(dotColor: const Color(0xFFEF5350), label: 'Error : $error'),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: space,
          children: children
              .map(
                (w) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: w,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
