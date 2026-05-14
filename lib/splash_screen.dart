import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cgw_app/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController; // subtle looping scale
  late final AnimationController _ringsController; // expanding rings (once)
  late final AnimationController _fadeController; // final fade-out
  late final Animation<double> _pulseAnim;
  late final Animation<double> _glowAnim;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 0.98, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _ringsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    Future.delayed(Duration(milliseconds: 1400), () {
      if (mounted) _ringsController.forward();
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );

    // Navigate after 5s; start fade slightly before navigation to overlap
    _timer = Timer(Duration(milliseconds: 5000), () async {
      await _fadeController.forward();
      if (mounted)
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _ringsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white; // light theme background
    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController),
        child: Center(
          child: SizedBox(
            width: 360,
            height: 360,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Subtle radial glow (light-adapted)
                AnimatedBuilder(
                  animation: _glowAnim,
                  builder: (context, child) {
                    final v = _glowAnim.value;
                    return Transform.scale(
                      scale: 0.9 + 0.12 * v,
                      child: Opacity(
                        opacity: 0.18 * v,
                        child: Container(
                          width: 380,
                          height: 380,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color.fromARGB(
                                  (200 * v).toInt(),
                                  255,
                                  77,
                                  116,
                                ), // pale pinkish
                                Color.fromARGB((90 * v).toInt(), 190, 60, 90),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 1.0],
                              center: Alignment(-0.05, -0.12),
                              radius: 0.8,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Rings
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RingsPainter(
                      animation: _ringsController,
                      lightMode: true,
                    ),
                  ),
                ),

                // Logo (pulsing)
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    );
                  },
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/lg_splash.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Painter for rings and sparkles, tuned for light background.
class _RingsPainter extends CustomPainter {
  final Animation<double> animation;
  final bool lightMode;
  _RingsPainter({required this.animation, this.lightMode = false})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    if (t <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);

    // ring 1
    final ring1Progress = (t).clamp(0.0, 1.0);
    final ring1Radius = ui.lerpDouble(
      size.width * 0.45,
      size.width * 0.78,
      ring1Progress,
    )!;
    final ring1Opacity = (1.0 - ring1Progress).clamp(0.0, 1.0);
    final ring1Color = lightMode
        ? Color.fromRGBO(220, 90, 130, (0.26 * ring1Opacity))
        : Color.fromRGBO(255, 45, 85, (0.28 * ring1Opacity));
    final ring1Paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..color = ring1Color;

    canvas.drawCircle(center, ring1Radius, ring1Paint);

    // ring 2
    final ring2Progress = ((t - 0.12) / (1.0 - 0.12)).clamp(0.0, 1.0);
    final ring2Radius = ui.lerpDouble(
      size.width * 0.33,
      size.width * 0.66,
      ring2Progress,
    )!;
    final ring2Opacity = (1.0 - ring2Progress).clamp(0.0, 1.0);
    final ring2Color = lightMode
        ? Color.fromRGBO(160, 40, 80, (0.20 * ring2Opacity))
        : Color.fromRGBO(165, 0, 52, (0.20 * ring2Opacity));
    final ring2Paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..color = ring2Color;

    canvas.drawCircle(center, ring2Radius, ring2Paint);

    // sparkles (fading)
    final sparklePaint = Paint()
      ..color = (lightMode ? Colors.white70 : Colors.white).withOpacity(
        0.9 * (1.0 - t),
      );
    if (t < 0.9) {
      final sparkleCount = 6;
      for (int i = 0; i < sparkleCount; i++) {
        final angle = (i / sparkleCount) * 2 * pi + t * 2.0;
        final r = ui.lerpDouble(
          size.width * 0.18,
          size.width * 0.42,
          (i / sparkleCount),
        )!;
        final p = Offset(
          center.dx + r * cos(angle),
          center.dy + r * sin(angle),
        );
        canvas.drawCircle(p, 1.6 * (1.0 - t), sparklePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => true;
}
