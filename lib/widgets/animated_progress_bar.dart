import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double progress;
  final Color color;
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 10.0,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: FractionallySizedBox(
            widthFactor: _animation.value,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
