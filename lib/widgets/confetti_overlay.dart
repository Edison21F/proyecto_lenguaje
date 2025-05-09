import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Confetti> _confetti;
  final int _confettiCount = 100;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _confetti = List.generate(
      _confettiCount,
      (index) => Confetti(
        color: _getRandomColor(),
        position: Offset(
          _random.nextDouble() * 400,
          _random.nextDouble() * -300,
        ),
        size: _random.nextDouble() * 10 + 5,
        speed: _random.nextDouble() * 300 + 100,
        angle: _random.nextDouble() * pi / 2 - pi / 4,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            confetti: _confetti,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Confetti {
  final Color color;
  final Offset position;
  final double size;
  final double speed;
  final double angle;

  Confetti({
    required this.color,
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter({
    required this.confetti,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < confetti.length; i++) {
      final c = confetti[i];
      final paint = Paint()..color = c.color;
      
      final dx = c.position.dx + cos(c.angle) * c.speed * progress;
      final dy = c.position.dy + sin(c.angle) * c.speed * progress + 
                 c.speed * progress * progress * 0.5; // Gravity effect
      
      final position = Offset(dx, dy);
      
      // Draw confetti as small rectangles with rotation
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(progress * 10 * (i % 2 == 0 ? 1 : -1)); // Rotate differently based on index
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: c.size,
          height: c.size * 2,
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
