import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/NetworkController.dart';

class ReusableNetworkDialog extends StatelessWidget {
  final DialogType type;
  final String tag;

  factory ReusableNetworkDialog.wifi() =>
      const ReusableNetworkDialog._(type: DialogType.wifi, tag: 'wifi_dialog');
  factory ReusableNetworkDialog.dns() =>
      const ReusableNetworkDialog._(type: DialogType.dns, tag: 'dns_dialog');

  const ReusableNetworkDialog._({required this.type, required this.tag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NetworkDialogController(type: type), tag: tag);

    const primaryColor = Color(0xFFA10E3A);
    const labelStyle = TextStyle(color: Colors.grey, fontSize: 14);

    // Swap string labels dynamically based on widget configuration type
    final title = type == DialogType.wifi ? 'WiFi Settings' : 'DNS Settings';
    final label1 = type == DialogType.wifi ? 'SSID' : 'Main DNS';
    final label2 = type == DialogType.wifi ? 'Security' : 'Sub DNS';
    final label3 = type == DialogType.wifi ? 'Password' : '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Form Fields Layout
            _buildInputField(
              label: label1,
              controller: controller.field1Controller,
              labelStyle: labelStyle,
            ),
            _buildInputField(
              label: label2,
              controller: controller.field2Controller,
              labelStyle: labelStyle,
            ),
            if (type == DialogType.wifi)
              _buildInputField(
                label: label3,
                controller: controller.field3Controller,
                labelStyle: labelStyle,
                isObscured: true,
              ),
            const SizedBox(height: 24),

            // Action Buttons (Always interactive)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => controller.applySettings(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required TextStyle labelStyle,
    bool isObscured = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex: 4, child: Text(label, style: labelStyle)),
          Expanded(
            flex: 6,
            child: TextField(
              controller: controller,
              obscureText: isObscured,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 4),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB71C1C), width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
