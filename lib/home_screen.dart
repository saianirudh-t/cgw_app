import 'package:cgw_app/status%20widget/status_screen.dart';
import 'package:flutter/material.dart';
import 'controls/controls_panel.dart';
import 'splash screen/login_card.dart';

class HomeScreen extends StatefulWidget {
  final DeviceConfigResult? result;

  const HomeScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DeviceConfigResult? _result;

  @override
  void initState() {
    super.initState();
    _result = widget.result;
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
                child: StatusScreen(
                  running: 10,
                  stop: 2,
                  error: 6,
                  result: widget.result,
                ),
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
