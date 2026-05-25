import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  final int running;
  final int stop;
  final int error;

  const StatusRow({
    super.key,
    required this.running,
    required this.stop,
    required this.error,
  });

  Widget _badge({
    required Color bgColor,
    required Color dotColor,
    required Color textColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    const double Breakpoint2 = 420;
  

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        final double space = w <= Breakpoint2 ? 0 : 30;
        print(w);
        final children = <Widget>[
          _badge(
            bgColor: const Color(0xFFE8F5E9),
            dotColor: const Color(0xFF4CAF50),
            textColor: const Color(0xFF2E7D32),
            label: 'Running : $running',
          ),
          _badge(
            bgColor: const Color(0xFFFFF3E0),
            dotColor: const Color(0xFFFFB74D),
            textColor: const Color(0xFFE65100),
            label: 'Stop : $stop',
          ),
          _badge(
            bgColor: const Color(0xFFFFEBEE),
            dotColor: const Color(0xFFEF5350),
            textColor: const Color(0xFFC62828),
            label: 'Error : $error',
          ),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: space,
          children: children
              .map(
                (w) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: w,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
