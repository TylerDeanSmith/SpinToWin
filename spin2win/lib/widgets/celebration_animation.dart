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
      duration: const Duration(seconds: 4), // Longer celebration!
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
      curve: const Interval(0.8, 1.0, curve: Curves.easeOut), // Fade later
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
    
    // Generate many more sparkles for a grand celebration!
    for (int i = 0; i < 200; i++) {
      _sparkles.add(Sparkle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 12 + 3, // Larger size range
        delay: random.nextDouble() * 0.8,
        duration: random.nextDouble() * 2.0 + 0.5,
        color: _getRandomStarColor(random),
        type: random.nextBool() ? SparkleType.star : SparkleType.firework,
        velocityX: (random.nextDouble() - 0.5) * 4, // For shooting effects
        velocityY: (random.nextDouble() - 0.5) * 4,
      ));
    }
  }
  
  Color _getRandomStarColor(Random random) {
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.green,
      Colors.lime,
      Colors.white,
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
    ];
    return colors[random.nextInt(colors.length)];
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
                          horizontal: 40,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.6),
                              blurRadius: 15,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Multiple celebration icons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.celebration,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 36,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.celebration,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.yellow,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                widget.winningText,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
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

enum SparkleType { star, firework }

class Sparkle {
  final double x;
  final double y;
  final double size;
  final double delay;
  final double duration;
  final Color color;
  final SparkleType type;
  final double velocityX;
  final double velocityY;

  Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.delay,
    required this.duration,
    required this.color,
    required this.type,
    required this.velocityX,
    required this.velocityY,
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

      // Calculate position with movement for shooting effects
      final centerX = sparkle.x * size.width + sparkle.velocityX * sparkleProgress * 100;
      final centerY = sparkle.y * size.height + sparkle.velocityY * sparkleProgress * 100;
      
      final center = Offset(centerX, centerY);

      if (sparkle.type == SparkleType.star) {
        final paint = Paint()
          ..color = sparkle.color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

        // Draw star shape
        _drawStar(canvas, center, sparkle.size * sparkleProgress, paint);
      } else {
        // Draw firework burst
        _drawFirework(canvas, center, sparkle.size * sparkleProgress, sparkle.color.withOpacity(opacity));
      }
    }
  }

  void _drawFirework(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw multiple burst rays
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi) / 4;
      final startRadius = size * 0.2;
      final endRadius = size;
      
      final startX = center.dx + startRadius * cos(angle);
      final startY = center.dy + startRadius * sin(angle);
      final endX = center.dx + endRadius * cos(angle);
      final endY = center.dy + endRadius * sin(angle);
      
      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), strokePaint);
      
      // Add small circles at the end of each ray
      canvas.drawCircle(Offset(endX, endY), 2, paint);
    }
    
    // Draw center burst
    canvas.drawCircle(center, size * 0.3, paint);
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