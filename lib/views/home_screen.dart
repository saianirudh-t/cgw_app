import 'package:cgw_app/controllers/device_details.dart';
import 'package:cgw_app/views/status_screen.dart';
import 'package:flutter/material.dart';
import 'controls_panel.dart';
import '../assets/login_card.dart';
import "dart:ui";
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final DeviceConfigResult? result;

  const HomeScreen({super.key, required this.result});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceConfigResult? _deviceConfig;
  bool _loginShown = false;
  final UserControllers updateDetails = Get.find();
  @override
  void initState() {
    super.initState();
    // wait for first frame so context/mounted are ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowLogin());
  }

  Future<void> _maybeShowLogin() async {
    if (_loginShown) return;
    _loginShown = true;

    // if already configured, skip
    if (_deviceConfig?.configured == true) return;

    await showGeneralDialog<DeviceConfigResult?>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // darkens behind the blur
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (ctx, anim, secondaryAnim) {
        return SafeArea(
          child: Builder(
            builder: (innerCtx) {
              return Stack(
                children: [
                  // blur the background
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ), // increase these for stronger blur
                    child: Container(color: Colors.black26),
                  ),

                  Center(
                    child: LoginCard(
                      initialName: 'CGW0954',
                      initialIp: '192.168.0.12',
                      onConnect: (res) async {},
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        return FadeTransition(opacity: anim, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),

      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 227, 227),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            spacing: 20,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.05),
                      offset: const Offset(0, 0),
                      blurRadius: 1.0, // Softness of the shadow edge
                      spreadRadius: 2.0, // Expands the shadow size outward
                    ),
                  ],
                ),
                child: StatusScreen(),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.05),
                        offset: const Offset(0, 0),
                        blurRadius: 1.0, // Softness of the shadow edge
                        spreadRadius: 2.0, // Expands the shadow size outward
                      ),
                    ],
                  ),
                  child: ControlsPanel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
