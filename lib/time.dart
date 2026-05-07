import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocalTimeText extends StatefulWidget {
  const LocalTimeText({super.key, this.style});
  final TextStyle? style;

  @override
  State<LocalTimeText> createState() => _LocalTimeTextState();
}

class _LocalTimeTextState extends State<LocalTimeText> {
  late Timer _timer;
  late DateTime _now;
  final DateFormat _fmt = DateFormat('hh:mm a'); // HH:mm

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    final nextMinute = DateTime(
      _now.year,
      _now.month,
      _now.day,
      _now.hour,
      _now.minute,
    ).add(const Duration(minutes: 1));
    final initialDelay = nextMinute.difference(_now);

    _timer = Timer(initialDelay, () {
      _updateTime();
      _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    if (now.minute != _now.minute ||
        now.hour != _now.hour ||
        now.day != _now.day) {
      setState(() => _now = now);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _fmt.format(_now),
      style:
          widget.style ??
          const TextStyle(fontSize: 18, fontWeight: FontWeight(500)),
    );
  }
}
