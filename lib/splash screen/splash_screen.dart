import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cgw_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cgw_app/splash screen/login_card.dart'; // adjust path

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _ringsController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _glowAnim;
  Timer? _navigationTimer;

  bool _pausedForConfig = false;
  DeviceConfigResult? _deviceConfig;

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
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_pulseController);
    _pulseController.repeat(reverse: true);

    _ringsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    Future.delayed(Duration(milliseconds: 1400), () {
      if (mounted && !_pausedForConfig) _ringsController.forward();
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );


    Future.delayed(Duration(milliseconds: 2000), _showLoginAndPause);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    _ringsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }


Future<void> _showLoginAndPause() async {
  setState(() => _pausedForConfig = true);
  _ringsController.stop();

  final result = await showDialog<DeviceConfigResult?>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => LoginCard(
      initialName: 'CUM0954',
      initialIp: '192.168.0.12',
      onConnect: (res) async { /* optional extra handling */ },
    ),
  );

  // store config result
  if (result?.configured == true) _deviceConfig = result;

  setState(() => _pausedForConfig = false);
  _ringsController.forward();

  // cancel any existing timer
  _navigationTimer?.cancel();
  _navigationTimer = Timer(Duration(milliseconds: 3000), () async {
    await _fadeController.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(result: _deviceConfig)),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
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
                // Subtle radial glow
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
                                Color.fromARGB((200 * v).toInt(), 255, 77, 116),
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
                // Rings painter (play/stop based on _pausedForConfig)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RingsPainter(
                      animation: _ringsController,
                      lightMode: true,
                    ),
                  ),
                ),

                // Logo area (keeps pulsing)
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    );
                  },
                  child: LayoutBuilder(
                    builder: (context, _) {
                      final diameter =
                          MediaQuery.of(context).size.shortestSide * 0.4;
                      return Center(
                        child: CircleAvatar(
                          radius: diameter / 2,
                          backgroundImage: AssetImage(
                            'assets/images/lg_splash.png',
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    },
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

// Reuse the same RingsPainter from earlier (use imports: dart:math, ui)
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

// Simple HomePage that receives device config
