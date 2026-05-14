import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;

  const SettingsButton({
    super.key,
    required this.onTap,
    this.size = 44.0, // Precision match for the control-panel section
  });

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Uses subtle grey hues to give the clean white dashboard surface a carved depth look
          color: const Color(0xFFE6ECF2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isPressed
                ? [
                    const Color(
                      0xFFD2D9E1,
                    ), // Darker transition when pressed down
                    const Color.fromARGB(255, 255, 255, 255),
                  ]
                : [
                    const Color(0xFFEFF5FA), // Crisp ambient upper glare
                    const Color(0xFFDCE2E8), // Deeper bottom groove shading
                  ],
          ),
          boxShadow: [
            // Dark recessed outer crescent rim drop-shading
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 5,
              offset: const Offset(1, 2),
            ),
            // Light highlight to define upper beveled baseline crispness
            const BoxShadow(
              color: Colors.white,
              blurRadius: 4,
              offset: Offset(-1, -1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.settings_outlined,
            color: const Color(
              0xFF1E293B,
            ), // Matches the exact dark gray thin stroke aesthetic
            size: widget.size * 0.52, // Automatically scales with button size
          ),
        ),
      ),
    );
  }
}
