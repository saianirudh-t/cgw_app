import 'package:cgw_app/splash%20screen/login_card.dart';
import 'package:flutter/material.dart';

class DeviceInfo extends StatefulWidget {
  final DeviceConfigResult? result;
  const DeviceInfo({Key? key, this.result}) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  final TextEditingController _ipController = TextEditingController();
  bool _isDeviceOn = true;

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.result?.deviceName ?? 'Unknown device';
    final ip = widget.result?.ip ?? '—';
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
      child: Container(
        width: 250,
        padding: const EdgeInsets.only(left: 24, right: 10, bottom: 8),
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Device Status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isDeviceOn,
                    activeThumbColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _isDeviceOn = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0), // Subtle grey border line
                    width: 1.0,
                  ),
                ),
              ),
              child: Text(
                "Connected device: $name",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // IP Field
            const Text(
              "IP Address",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),

            SizedBox(
              height: 38,
              child: TextField(
                controller: _ipController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: ip,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ), // Switch Item Status
          ],
        ),
      ),
    );
  }
}
