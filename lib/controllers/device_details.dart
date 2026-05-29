import 'package:get/get.dart';

class UserControllers extends GetxController {
  var deviceName = 'no device'.obs;
  var ipAdress = ' '.obs;
  var running = 12.obs;
  var dns = "210.117.65.1".obs;
  var stop = 3.obs;
  var error = 1.obs;
  void deviceDetails(String name, String ip) {
    deviceName.value = name;
    ipAdress.value = ip;
  }

  void statusControls(int run, int stopping, int errored) {
    running.value = run;
    stop.value = stopping;
    error.value = errored;
  }

  void dnsDetails(String dnsvalue) {
    dns.value = dnsvalue;
  }
}
