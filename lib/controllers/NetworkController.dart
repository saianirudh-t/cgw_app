import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DialogType { wifi, dns }

class NetworkDialogController extends GetxController {
  final DialogType type;

  // Input text controllers
  late final TextEditingController field1Controller;
  late final TextEditingController field2Controller;
  late final TextEditingController field3Controller;

  NetworkDialogController({required this.type});

  @override
  void onInit() {
    super.onInit();
    // Initialize standard values depending on the context type
    if (type == DialogType.wifi) {
      field1Controller = TextEditingController(text: 'Home_Network_5G');
      field2Controller = TextEditingController(text: 'WPA2-PSK');
      field3Controller = TextEditingController(text: '********');
    } else {
      field1Controller = TextEditingController(text: "210.117.65.1");
      field2Controller = TextEditingController(text: "210.117.65.1");
      field3Controller = TextEditingController(); // Unused for DNS layout
    }
  }

  void applySettings() {
    if (type == DialogType.wifi) {
      print(
        'WiFi Saved -> SSID: ${field1Controller.text}, Security: ${field2Controller.text}',
      );
    } else {
      print(
        'DNS Saved -> Main: ${field1Controller.text}, Sub: ${field2Controller.text}',
      );
    }
    Get.back();
  }

  @override
  void onClose() {
    field1Controller.dispose();
    field2Controller.dispose();
    field3Controller.dispose();
    super.onClose();
  }
}
