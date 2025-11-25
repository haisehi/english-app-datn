import 'package:flutter/material.dart';
import 'dart:math';

class SpeakingWave extends StatefulWidget {
  final bool active;

  const SpeakingWave({super.key, required this.active});

  @override
  State<SpeakingWave> createState() => _SpeakingWaveState();
}

class _SpeakingWaveState extends State<SpeakingWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Nếu widget.active = true khi init, start animation
    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SpeakingWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Bật/tắt animation dựa trên active
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // safe dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 60,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (i) {
              double value = sin(_controller.value * pi * 2 + i);
              double height = 10 + (value.abs() * 40);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 6,
                height: widget.active ? height : 10,
                decoration: BoxDecoration(
                  color: widget.active ? Colors.red : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
