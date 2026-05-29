import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/password_controller.dart';

class ChangePasswordPopup extends StatefulWidget {
  const ChangePasswordPopup({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPopup> createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends State<ChangePasswordPopup> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _reCtrl = TextEditingController();
  final AuthController authC = Get.find<AuthController>();
  final PasswordController pwCtrl = Get.find<PasswordController>();

  final RxBool _loading = false.obs;
  final RxString _error = ''.obs;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _reCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    _error.value = '';
    if (!_formKey.currentState!.validate()) return;

    _loading.value = true;
    final oldOk = await authC.verifyOldPassword(_oldCtrl.text.trim());
    if (!oldOk) {
      _error.value = 'Current password is incorrect';
      _loading.value = false;
      return;
    }

    await authC.updatePassword(_newCtrl.text.trim());
    _loading.value = false;
    if (mounted) Get.back(result: true); // close popup, return success
  }

  String? _validateNew(String? v) {
    if (v == null || v.isEmpty) return 'Enter new password';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validateRe(String? v) {
    if (v == null || v.isEmpty) return 'Re-enter password';
    if (v != _newCtrl.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool _obscureNew = false;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Change Password',
        style: TextStyle(color: Colors.black54),
      ),
      content: Obx(
        () => SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _error.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Obx(
                      () => TextFormField(
                        style: TextStyle(color: Colors.black54),
                        controller: _oldCtrl,
                        obscureText: pwCtrl.obscureOld.value,
                        decoration: InputDecoration(
                          labelText: 'Current password',
                          labelStyle: TextStyle(color: Colors.black54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              pwCtrl.obscureOld.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: pwCtrl.toggleOld,
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter current password'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        style: const TextStyle(color: Colors.black54),
                        controller: _newCtrl,
                        obscureText: pwCtrl.obscureNew.value,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          labelStyle: const TextStyle(color: Colors.black54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              pwCtrl.obscureNew.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: pwCtrl.toggleNew,
                          ),
                        ),
                        validator: _validateNew,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        style: TextStyle(color: Colors.black54),
                        controller: _reCtrl,
                        obscureText: pwCtrl.obscureRe.value,
                        decoration: InputDecoration(
                          labelText: 'Re-enter password',
                          labelStyle: TextStyle(color: Colors.black54),

                          suffixIcon: IconButton(
                            icon: Icon(
                              pwCtrl.obscureRe.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: pwCtrl.toggleNew,
                          ),
                        ),

                        validator: _validateRe,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          // Sets the text/icon color
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFFA10E3A), // Sets the text/icon color
          ),
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA10E3A), // Sets the background color
              foregroundColor: Colors.white, // Sets the text/icon color
            ),
            onPressed: _loading.value ? null : _submit,
            child: _loading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          );
        }),
      ],
    );
  }
}
