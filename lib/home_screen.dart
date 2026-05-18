import 'package:cgw_app/status%20widget/status_screen.dart';
import 'package:flutter/material.dart';
import 'controls_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Setting a dark theme to match the widget's aesthetic
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        // Light grey background
      ),

      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 227, 227),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //child: RunningStatus(runningCount: 9, stopCount: 2, errorCount: 4),
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
                child: StatusScreen(running: 10, stop: 2, error: 6),
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
                  child: ControlsPanel(
                    onSettingsTap: () {
                      // open settings
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
