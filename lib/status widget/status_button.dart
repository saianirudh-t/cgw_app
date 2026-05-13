import 'package:flutter/material.dart';

enum StatusType { running, stop, error }

class StatusButton extends StatefulWidget {
  final StatusType type;
  final String label;
  final VoidCallback onTap;

  const StatusButton({
    super.key,
    required this.type,
    required this.label,
    required this.onTap,
  });

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Encapsulated visual specifications inside the file boundary
    final IconData icon;
    final Color iconColor;
    final Color textColor;
    final Color backgroundColor;
    final Color borderColor;

    switch (widget.type) {
      case StatusType.running:
        icon = Icons.play_arrow_rounded;
        iconColor = const Color(0xFF16A34A);
        textColor = const Color(0xFF15803D);
        backgroundColor = const Color(0xFFF0F9F4);
        borderColor = const Color(0xFFE2F0E7);
        break;
      case StatusType.stop:
        icon = Icons.pause_rounded;
        iconColor = const Color(0xFFD97706);
        textColor = const Color(0xFFB45309);
        backgroundColor = const Color(0xFFFEF7EA);
        borderColor = const Color(0xFFF9EDD9);
        break;
      case StatusType.error:
        icon = Icons.warning_rounded;
        iconColor = const Color(0xFFDC2626);
        textColor = const Color(0xFFB91C1C);
        backgroundColor = const Color(0xFFFDF2F2);
        borderColor = const Color(0xFFFBE5E5);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: iconColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18.0),
            const SizedBox(width: 2),
            Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
