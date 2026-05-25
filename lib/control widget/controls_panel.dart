import 'package:cgw_app/control%20widget/controls_screen.dart';
import 'package:flutter/material.dart';
import '../pressed_card.dart';

class ControlsPanel extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const ControlsPanel({super.key, this.onSettingsTap});

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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double availableHeight =
                      constraints.maxHeight == double.infinity
                      ? MediaQuery.of(context).size.height
                      : constraints.maxHeight;

                  // 2. Flip axis direction if the layout environment is short
                  final bool isShortScreen = availableHeight < 165.0;

                  return Flex(
                    direction: isShortScreen ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      isShortScreen
                          ? Expanded(
                              child: PressableCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ControlsScreen(controlType: "Aircon"),
                                    ),
                                  );
                                },
                                child: _DeviceCard(
                                  title: 'Aircon',
                                  subtitle: 'Room1',
                                  accentColor: airconAccent,
                                ),
                              ),
                            )
                          : PressableCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ControlsScreen(controlType: 'Aircon'),
                                  ),
                                );
                              },
                              child: _DeviceCard(
                                title: 'Aircon',
                                subtitle: 'Room1',
                                accentColor: airconAccent,
                              ),
                            ),

                      // Dynamic padding spacer block based on active layout axis orientation
                      isShortScreen
                          ? const SizedBox(width: 16)
                          : const SizedBox(height: 16),
                      isShortScreen
                          ? Expanded(
                              child: PressableCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ControlsScreen(
                                        controlType: 'Heating',
                                      ),
                                    ),
                                  );
                                },
                                child: _DeviceCard(
                                  title: 'Heating',
                                  subtitle: 'Room1',
                                  accentColor: heatingAccent,
                                ),
                              ),
                            )
                          : PressableCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ControlsScreen(controlType: 'Heating'),
                                  ),
                                );
                              },
                              child: _DeviceCard(
                                title: 'Heating',
                                subtitle: 'Room1',
                                accentColor: heatingAccent,
                              ),
                            ),
                    ],
                  );
                },
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
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

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
