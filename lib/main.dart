import 'package:cgw_app/controllers/device_details.dart';
import 'package:cgw_app/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:window_manager/window_manager.dart'; // Import package

void main() async {
  // Ensure Flutter bindings are initialized
  Get.put(UserControllers());
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the window manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(500, 550), // Set minimum width (400) and height (600)
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LG CGW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
