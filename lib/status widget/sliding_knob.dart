import 'dart:async';

import 'package:flutter/material.dart';

enum TriState { on, idle, off }

typedef TriStateAction = FutureOr<void> Function();

class SlidingTriStateKnob extends StatefulWidget {
  final double width;
  final double height;
  final Color trackColor;
  final Color knobColor;
  final Color activeColorOn;
  final Color activeColorOff;
  final TriState initial;
  final Duration animationDuration;
  final TriStateAction? onPressedOn;
  final TriStateAction? onPressedOff;

  const SlidingTriStateKnob({
    Key? key,
    this.width = 250,
    this.height = 56,
    this.trackColor = const Color.fromARGB(
      255,
      235,
      243,
      250,
    ), // Color(0xFFEFEFEF),
    this.knobColor = Colors.white,
    this.activeColorOn = Colors.green,
    this.activeColorOff = Colors.red,
    this.initial = TriState.idle,
    this.animationDuration = const Duration(milliseconds: 400),
    this.onPressedOn,
    this.onPressedOff,
  }) : super(key: key);

  @override
  _SlidingTriStateKnobState createState() => _SlidingTriStateKnobState();
}

class _SlidingTriStateKnobState extends State<SlidingTriStateKnob>
    with SingleTickerProviderStateMixin {
  late TriState _state;
  late double _knobX;
  late AnimationController _ctrl;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _state = widget.initial;
    _knobX = _posForState(_state);
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _posForState(TriState s) {
    switch (s) {
      case TriState.on:
        return 0.0;
      case TriState.idle:
        return 0.5;
      case TriState.off:
        return 1.0;
    }
  }

  TriState _stateForPos(double t) {
    if (t < 0.33) return TriState.on;
    if (t > 0.66) return TriState.off;
    return TriState.idle;
  }

  Future<void> _animateTo(double target) async {
    final begin = _knobX;
    final anim = Tween<double>(
      begin: begin,
      end: target,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.reset();
    _ctrl.addListener(() {
      setState(() {
        _knobX = anim.value;
      });
    });
    await _ctrl.forward();
    _ctrl.removeListener(() {});
  }

  Future<void> _performActionAndReturn(TriState pressedState) async {
    if (_busy) return;
    _busy = true;
    try {
      final callback = pressedState == TriState.on
          ? widget.onPressedOn
          : widget.onPressedOff;
      if (callback != null) {
        await Future.value(callback());
      }
      // HOLD HERE before returning to idle
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // change 1000 to desired hold ms
      await _animateTo(_posForState(TriState.idle));
      setState(() => _state = TriState.idle);
    } finally {
      _busy = false;
    }
  }

  Future<void> _onTapAt(Offset localPosition, double trackWidth) async {
    final t = (localPosition.dx / trackWidth).clamp(0.0, 1.0);
    final targetState = _stateForPos(t);
    if (targetState == TriState.idle) {
      await _animateTo(_posForState(TriState.idle));
      setState(() => _state = TriState.idle);
      return;
    }
    // animate to pressed position, run callback, return to idle
    await _animateTo(_posForState(targetState));
    setState(() => _state = targetState);
    await _performActionAndReturn(targetState);
  }

  @override
  Widget build(BuildContext context) {
    final knobDiameter = widget.height - 8;
    final trackRadius = BorderRadius.circular(widget.height / 2);
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        _onTapAt(box.globalToLocal(details.globalPosition), widget.width);
      },
      onHorizontalDragStart: (details) {},
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);
        final t = (local.dx / widget.width).clamp(0.0, 1.0);
        setState(() {
          _knobX = t;
          _state = _stateForPos(t);
        });
      },
      onHorizontalDragEnd: (details) async {
        final endState = _stateForPos(_knobX);
        if (endState == TriState.idle) {
          await _animateTo(_posForState(TriState.idle));
          setState(() => _state = TriState.idle);
        } else {
          await _animateTo(_posForState(endState));
          setState(() => _state = endState);
          await _performActionAndReturn(endState);
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.trackColor,
                borderRadius: trackRadius,
              ),
            ),
            // Active background (tint left/right when over that side)
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: (_knobX < 0.33)
                            ? widget.activeColorOn.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget.height / 2),
                          bottomLeft: Radius.circular(widget.height / 2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container(color: Colors.transparent)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: (_knobX > 0.66)
                            ? widget.activeColorOff.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(widget.height / 2),
                          bottomRight: Radius.circular(widget.height / 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Labels
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'ON',
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'OFF',
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Knob
            Positioned(
              left: (_knobX * (widget.width - knobDiameter)).clamp(
                0.0,
                widget.width - knobDiameter,
              ),
              child: AnimatedContainer(
                duration: widget.animationDuration,
                width: knobDiameter,
                height: knobDiameter,
                decoration: BoxDecoration(
                  color: widget.knobColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.black12),
                ),
                alignment: Alignment.center,
                child: (_state == TriState.on)
                    ? Icon(
                        Icons.check,
                        color: widget.activeColorOn,
                        size: knobDiameter * 0.5,
                      )
                    : (_state == TriState.off)
                    ? Icon(
                        Icons.close,
                        color: widget.activeColorOff,
                        size: knobDiameter * 0.5,
                      )
                    : Icon(
                        Icons.remove,
                        color: Colors.grey.shade600,
                        size: knobDiameter * 0.5,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
