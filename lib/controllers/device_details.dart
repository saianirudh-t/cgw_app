import 'package:get/get.dart';

class UserControllers extends GetxController {
  var deviceName = 'CGW0954 '.obs;
  var ipAdress = ' '.obs;

  void deviceDetails(String name, String ip) {
    deviceName.value = name;
    ipAdress.value = ip;
  }
}
