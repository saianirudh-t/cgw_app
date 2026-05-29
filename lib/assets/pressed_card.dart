import 'package:flutter/material.dart';

class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const PressableCard({super.key, required this.child, this.onTap});

  @override
  _PressableCardState createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.97 : 1.0;
    final opacity = _pressed ? 0.85 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _release(),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: opacity,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: scale,
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }

  void _release() async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setPressed(false);
  }
}
