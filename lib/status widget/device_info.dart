import 'package:flutter/material.dart';

class DeviceInfoLeftMenu extends StatefulWidget {
  final String currentDevice;
  final List<String> allDevices;

  const DeviceInfoLeftMenu({
    Key? key,
    required this.currentDevice,
    required this.allDevices,
  }) : super(key: key);

  @override
  _DeviceInfoLeftMenuState createState() => _DeviceInfoLeftMenuState();
}

class _DeviceInfoLeftMenuState extends State<DeviceInfoLeftMenu> {
  final TextEditingController _ipController = TextEditingController();
  bool _isDeviceOn = true;

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Text(
                "Connected device",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Fixed-Height Scroll Box
            Container(
              height: 110,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.allDevices.length,
                itemExtent: 36.0,
                itemBuilder: (context, index) {
                  final deviceName = widget.allDevices[index];
                  final isSelected = deviceName == widget.currentDevice;
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      deviceName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.grey.shade100,
                    onTap: () {
                      // Handle select modifications
                    },
                  );
                },
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
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "192.168.1.100",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),            // Switch Item Status
          ],
        ),
      ),
    );
  }
}
