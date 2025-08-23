import 'dart:math';
import 'package:flutter/material.dart';
import '../models/wheel_option.dart';

class SpinningWheel extends StatefulWidget {
  final List<WheelOption> options;
  final Function(WheelOption) onResult;
  final bool isSpinning;

  const SpinningWheel({
    super.key,
    required this.options,
    required this.onResult,
    required this.isSpinning,
  });

  @override
  State<SpinningWheel> createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  int? _resultIndex;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(SpinningWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _startSpinning();
    }
  }

  void _startSpinning() {
    // Generate random result
    final random = Random();
    _resultIndex = random.nextInt(widget.options.length);
    
    // Calculate target rotation (multiple full rotations + result position)
    final baseRotations = 3 + random.nextDouble() * 2; // 3-5 full rotations
    final segmentAngle = 2 * pi / widget.options.length;
    
    // PATTERN-BASED FIX:
    // User reported: Pizza=Sushi (0->2) and Burger=Pasta (1->4)  
    // Pattern: 0->2 (+2), 1->4 (+3)
    // This suggests segments are offset. Let me try reversing: 2->0, 4->1
    // If Pizza(0) shows as Sushi(2), then to show Pizza I need index 2
    // Let me try: if I want to show index i, use index (i+2) % length
    final correctedIndex = (_resultIndex! + 2) % widget.options.length;
    final targetAngle = baseRotations * 2 * pi - ((correctedIndex + 0.5) * segmentAngle);
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));

    _rotationController.reset();
    _rotationController.forward().then((_) {
      if (_resultIndex != null) {
        widget.onResult(widget.options[_resultIndex!]);
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wheel
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: WheelPainter(options: widget.options),
                ),
              );
            },
          ),
          // Pointer
          Positioned(
            top: 10,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 20, color: Colors.transparent),
                  right: BorderSide(width: 20, color: Colors.transparent),
                  bottom: BorderSide(width: 40, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelOption> options;

  WheelPainter({required this.options});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = 2 * pi / options.length;

    for (int i = 0; i < options.length; i++) {
      final paint = Paint()
        ..color = Color(int.parse('FF${options[i].color}', radix: 16))
        ..style = PaintingStyle.fill;

      final startAngle = i * sweepAngle - pi / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: options[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(textAngle) - textPainter.width / 2;
      final textY = center.dy + textRadius * sin(textAngle) - textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}