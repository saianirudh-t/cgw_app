import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/controllers/IpSettingsController.dart';

class IpSettingsDialog extends StatelessWidget {
  const IpSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IpSettingsController());

    const primaryColor = Color(0xFFA10E3A);
    const labelStyle = TextStyle(color: Colors.black, fontSize: 14);

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
            const Text(
              'IP Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Radio Buttons Segment
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text(
                        'static',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      value: true,
                      groupValue: controller.isStatic.value,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => controller.setStaticMode(val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text(
                        'DHCP',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      value: false,
                      groupValue: controller.isStatic.value,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => controller.setStaticMode(val!),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Text Input Fields (Now responsive to DHCP status)
            Obx(
              () => Column(
                children: [
                  _buildInputField(
                    label: 'IP Address',
                    controller: controller.ipController,
                    enabled: !controller
                        .isStatic
                        .value, // Enabled when isStatic is FALSE (DHCP mode)
                    labelStyle: labelStyle,
                  ),
                  _buildInputField(
                    label: 'Subnet mask',
                    controller: controller.subnetController,
                    enabled: !controller
                        .isStatic
                        .value, // Enabled when isStatic is FALSE (DHCP mode)
                    labelStyle: labelStyle,
                  ),
                  _buildInputField(
                    label: 'Gateway',
                    controller: controller.gatewayController,
                    enabled: !controller
                        .isStatic
                        .value, // Enabled when isStatic is FALSE (DHCP mode)
                    labelStyle: labelStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dialog Footnote Controls
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
                Obx(() {
                  // 1. Determine active status based on configuration choice
                  final isEnabled = !controller.isStatic.value;

                  return ElevatedButton(
                    onPressed: isEnabled
                        ? () => controller.applySettings()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled
                          ? primaryColor
                          : const Color.fromARGB(255, 184, 114, 114),

                      foregroundColor: isEnabled
                          ? Colors.white
                          : const Color.fromARGB(255, 11, 11, 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Apply'),
                  );
                }),
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
    required bool enabled,
    required TextStyle labelStyle,
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
              enabled: enabled,
              style: TextStyle(
                color: enabled ? Colors.black87 : Colors.grey,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 4),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: const UnderlineInputBorder(
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
