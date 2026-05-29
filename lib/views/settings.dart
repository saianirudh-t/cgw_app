import 'package:cgw_app/assets/IpSettingsDialog.dart';
import 'package:cgw_app/assets/password.dart';
import 'package:cgw_app/controllers/device_details.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cgw_app/assets/NetworkDialog.dart';

// =========================================================================
// PAGE 1: UNIVERSAL LANDING DASHBOARD
// =========================================================================
class CloudGatewayDashboard extends StatelessWidget {
  const CloudGatewayDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserControllers deviceInfo = Get.find<UserControllers>();
    final ip = deviceInfo.ipAdress.value;
    final dns = deviceInfo.dns.value;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA10E3A),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildMenuCard(
                        context,
                        title: 'Operation',
                        subtitle: 'mode configuration, Schedules and overrides',
                        icon: Icons.settings,
                        iconColor: Colors.teal,
                        targetConfigType: 'operation',
                      ),
                      ListTile(
                        title: const Text('Auto Mode Option'),
                        subtitle: const Text('Configure dual setpoints status'),
                        trailing: Chip(
                          label: const Text(
                            '2Set Off',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        title: Text('Energy Save Mode Cycle'),
                        trailing: Text(
                          '5 min',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        title: Text('Temperature Difference'),
                        trailing: Text(
                          '1.0 °C',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Latest Holiday'),
                        trailing: Text(
                          'None',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Schedule Initialization'),
                        trailing: Text(
                          'None',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Night Silent Mode'),
                        value: false,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildMenuCard(
                        context,
                        title: 'System',
                        subtitle: 'connectivity status, security info',
                        icon: Icons.dns,
                        iconColor: Colors.blue,
                        targetConfigType: 'system',
                      ),
                      ListTile(
                        title: Text("IPv4"),
                        leading: Icon(Icons.public),
                        trailing: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Text(ip),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                        onTap: () async {
                          await Get.dialog<bool?>(const IpSettingsDialog());
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text("IPv6"),
                        leading: Icon(Icons.language),
                        trailing: Text("fe80::da4ff:fe00a:46a5"),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text("DNS Server"),
                        leading: Icon(Icons.manage_search),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Text(dns),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () {
                          Get.dialog(ReusableNetworkDialog.dns());
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text("HTTP Port"),
                        leading: Icon(Icons.https),
                        trailing: Text("80", style: TextStyle(fontSize: 15)),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: Text("TMS Status"),
                        value: false,
                        onChanged: (value) => {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text("Wifi Network"),
                        leading: const Icon(Icons.wifi),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.dialog(ReusableNetworkDialog.wifi());
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Change password'),
                        leading: const Icon(Icons.lock_outline),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final result = await Get.dialog<bool?>(
                            const ChangePasswordPopup(),
                          );
                          if (result == true) {
                            Get.snackbar(
                              'Password changed successfully',
                              ' ',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: const Color(0xFFA10E3A),
                              snackStyle: SnackStyle.FLOATING,
                              margin: const EdgeInsets.all(12),
                            );
                          }
                        },
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('Firmware Version'),
                        trailing: Text(
                          'Ver. 1.0.033 (Master)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text('Open Source License'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildMenuCard(
                        context,
                        title: 'Installer',
                        subtitle:
                            'system settings, device management and languages',
                        icon: Icons.build,
                        iconColor: Colors.orange,
                        targetConfigType: 'installer',
                      ),
                      ListTile(
                        title: Text('LGAP Settings Configuration'),
                        subtitle: Text('Current: Master LGAP1'),
                        trailing: Icon(Icons.edit, color: Colors.blue),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            _buildDeviceCountRow(
                              'IDU (Indoor Units)',
                              16,
                              Colors.blue,
                            ),
                            const Divider(height: 1),
                            _buildDeviceCountRow(
                              'ERV (Ventilation)',
                              0,
                              Colors.grey,
                            ),
                            const Divider(height: 1),
                            _buildDeviceCountRow('ERV DX', 0, Colors.grey),
                            const Divider(height: 1),
                            _buildDeviceCountRow(
                              'Heating Units',
                              1,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.language,
                          color: Colors.indigo,
                        ),
                        title: const Text('Language Update'),
                        trailing: Chip(
                          label: const Text('None'),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCountRow(String label, int count, Color badgeColor) {
    return ListTile(
      title: Text(label),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String targetConfigType,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Text(subtitle),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// PAGE 2: UNIVERSAL DETAILS SUB-PAGE (WITH NATIVE BACK BUTTON)
// =========================================================================


  // --- OPERATION SEGMENT UI ---

  // --- SYSTEM SEGMENT UI ---

  // --- INSTALLER SEGMENT UI ---
  // --- SUB-ELEMENT REFACTOR CODES ---


// GLOBAL HELPER COMPONENT ATOMICS//
