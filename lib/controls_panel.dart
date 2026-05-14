import 'package:flutter/material.dart';
import 'pressed_card.dart';

class ControlsPanel extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const ControlsPanel({Key? key, this.onSettingsTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors
    final background = Colors.white;
    final airconAccent = Colors.blue;
    final heatingAccent = Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Text(
              'Controls',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
            const SizedBox(height: 10),
            // Cards column
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PressableCard(
                    onTap: () {
                      print('tapped aircon');
                    },
                    child: _DeviceCard(
                      title: 'Aircon',
                      subtitle: 'Living Room',
                      accentColor: airconAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PressableCard(
                    onTap: () {
                      print("Heating pressed");
                    },
                    child: _DeviceCard(
                      title: 'Heating',
                      subtitle: 'Living Room',
                      accentColor: heatingAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;

  const _DeviceCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      shadowColor: const Color.fromARGB(255, 18, 2, 2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title row
            Row(
              children: [
                // simple circle icon placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    title == 'Aircon' ? Icons.ac_unit : Icons.heat_pump,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
