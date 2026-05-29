import 'package:get/get.dart';

class AuthController extends GetxController {
  // Example: stored old password (in real apps use secure storage + hashing)
  final RxString storedPassword = 'LG12@soft34'.obs;
  // Async check that compares provided old password to stored password
  Future<bool> verifyOldPassword(String input) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate IO
    return input == storedPassword.value;
  }

  // Update stored password (replace with secure storage / backend call)
  Future<void> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate IO
    storedPassword.value = newPassword;
  }
  
}


class PasswordController extends GetxController {
  final obscureOld = true.obs;
  final obscureNew = true.obs;
  final obscureRe = true.obs;

  void toggleOld() => obscureOld.toggle();
  void toggleNew() => obscureNew.toggle();
  void toggleRe() => obscureRe.toggle();
}


