import 'package:flutter/material.dart';

class OtpProgressBar extends StatefulWidget {
  final Duration totalDuration;
  final Duration elapsedDuration;
  final Color progressColor;
  final Color backgroundColor;

  const OtpProgressBar({
    super.key,
    required this.totalDuration,
    required this.elapsedDuration,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
  });

  @override
  OtpProgressBarState createState() => OtpProgressBarState();
}

class OtpProgressBarState extends State<OtpProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final elapsedFactor = widget.elapsedDuration.inMilliseconds /
        widget.totalDuration.inMilliseconds;

    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    )
      ..value = elapsedFactor
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Container(
            height: 5.0,
            color: widget.backgroundColor,
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 1.0 - _controller.value,
                  child: Container(
                    height: 5.0,
                    color: widget.progressColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
