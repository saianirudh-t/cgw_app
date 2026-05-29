import 'package:cgw_app/controllers/AirconHeating.dart';
import 'package:cgw_app/controllers/device_details.dart';
import 'package:cgw_app/controllers/password_controller.dart';
import 'package:cgw_app/routes/app_routes.dart';
import 'package:cgw_app/views/controls_screen.dart';
import 'package:cgw_app/views/home_screen.dart';
import 'package:cgw_app/views/settings.dart';
import 'package:cgw_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:window_manager/window_manager.dart'; // Import package

void main() async {
  // Ensure Flutter bindings are initialized
  Get.put(UserControllers());
  Get.put(AuthController());
  Get.put(PasswordController());
  Get.put(ControlsController());
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
      theme: ThemeData.light(),
      home: SplashScreen(),
      getPages: [
        GetPage(name: AppRoutes.Settings, page: () => CloudGatewayDashboard()),
        GetPage(
          name: AppRoutes.HomeScreen,
          page: () => HomeScreen(result: null),
        ),
        GetPage(name: '/controls', page: () => ControlsScreen()),
      ],
    );
  }
}
