import 'dart:math';
import 'package:flutter/material.dart';

class CelebrationAnimation extends StatefulWidget {
  final bool isVisible;
  final String winningText;
  final VoidCallback onComplete;

  const CelebrationAnimation({
    super.key,
    required this.isVisible,
    required this.winningText,
    required this.onComplete,
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final List<Sparkle> _sparkles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    _generateSparkles();
  }

  @override
  void didUpdateWidget(CelebrationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startCelebration();
    }
  }

  void _generateSparkles() {
    final random = Random();
    _sparkles.clear();
    for (int i = 0; i < 50; i++) {
      _sparkles.add(Sparkle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 8 + 4,
        delay: random.nextDouble() * 0.5,
        duration: random.nextDouble() * 1.5 + 0.5,
      ));
    }
  }

  void _startCelebration() {
    _controller.reset();
    _sparkleController.reset();
    _controller.forward();
    _sparkleController.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            // Sparkles
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: SparklesPainter(
                    sparkles: _sparkles,
                    progress: _sparkleController.value,
                  ),
                );
              },
            ),
            // Winner text
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1.0 - _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.celebration,
                              color: Colors.orange,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Winner!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.winningText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sparkle {
  final double x;
  final double y;
  final double size;
  final double delay;
  final double duration;

  Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.delay,
    required this.duration,
  });
}

class SparklesPainter extends CustomPainter {
  final List<Sparkle> sparkles;
  final double progress;

  SparklesPainter({
    required this.sparkles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in sparkles) {
      final sparkleProgress = ((progress - sparkle.delay) / sparkle.duration).clamp(0.0, 1.0);
      
      if (sparkleProgress <= 0) continue;

      final opacity = sparkleProgress < 0.5
          ? sparkleProgress * 2
          : (1.0 - sparkleProgress) * 2;

      final paint = Paint()
        ..color = Colors.yellow.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final center = Offset(
        sparkle.x * size.width,
        sparkle.y * size.height,
      );

      // Draw star shape
      _drawStar(canvas, center, sparkle.size * sparkleProgress, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const numPoints = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < numPoints * 2; i++) {
      final angle = (i * pi) / numPoints;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(angle - pi / 2);
      final y = center.dy + radius * sin(angle - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}