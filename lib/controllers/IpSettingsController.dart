import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IpSettingsController extends GetxController {
  final isStatic = true.obs;

  final ipController = TextEditingController(text: '192.168.0.104');
  final subnetController = TextEditingController(text: '255.255.255.0');
  final gatewayController = TextEditingController(text: '192.168.0.1');

  void setStaticMode(bool value) {
    isStatic.value = value;
  }

  void applySettings() {
    print('DHCP mode active: ${!isStatic.value}');
    print(
      'IP Configuration: ${ipController.text}, ${subnetController.text}, ${gatewayController.text}',
    );
    Get.back();
  }

  @override
  void onClose() {
    ipController.dispose();
    subnetController.dispose();
    gatewayController.dispose();
    super.onClose();
  }
}
