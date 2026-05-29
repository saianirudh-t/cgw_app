
import 'package:cgw_app/routes/app_routes.dart';
import 'package:cgw_app/views/home_screen.dart';
import 'package:cgw_app/views/settings.dart';
import 'package:cgw_app/views/splash_screen.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static const initial = AppRoutes.SplashScreen;
  static final routes = [
    GetPage(name: AppRoutes.Settings, page: () => CloudGatewayDashboard()),
    GetPage(name: AppRoutes.SplashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.HomeScreen, page:() =>HomeScreen(result: null))
  
  ];
}
