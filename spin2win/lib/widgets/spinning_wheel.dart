import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
  late AudioPlayer _audioPlayer;
  double _lastSegmentCrossed = -1;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
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

    // Listen for animation changes to play tick sounds
    _rotationAnimation.addListener(_onRotationChanged);
  }

  @override
  void didUpdateWidget(SpinningWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _startSpinning();
    }
  }

  void _onRotationChanged() {
    if (!_rotationController.isAnimating) return;
    
    final currentAngle = _rotationAnimation.value;
    final segmentAngle = 2 * pi / widget.options.length;
    
    // Calculate how many segment boundaries we've passed
    final segmentsPassed = currentAngle / segmentAngle;
    final currentSegmentCount = segmentsPassed.floor();
    
    // Play tick sound when we cross into a new segment
    // Only play if we've moved significantly and crossed a boundary
    if (currentSegmentCount > _lastSegmentCrossed && currentSegmentCount > 0) {
      _playTickSound();
      _lastSegmentCrossed = currentSegmentCount.toDouble();
    }
  }

  void _playTickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/tick.mp3'));
    } catch (e) {
      // Silently handle audio errors - sound is optional
      debugPrint('Tick sound error: $e');
    }
  }

  void _playCelebrationSound() async {
    try {
      //await _audioPlayer.play(AssetSource('sounds/celebration.mp3'));
    } catch (e) {
      // Silently handle audio errors - sound is optional
      debugPrint('Celebration sound error: $e');
    }
  }

  void _startSpinning() {
    final random = Random();
    
    // Reset segment tracking for new spin
    _lastSegmentCrossed = -1;
    
    // Generate truly random target rotation (multiple full rotations + random final position)
    final baseRotations = 3 + random.nextDouble() * 2; // 3-5 full rotations
    final finalAngle = random.nextDouble() * 2 * pi; // Random final position
    final targetAngle = baseRotations * 2 * pi + finalAngle;
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));

    _rotationController.reset();
    _rotationController.forward().then((_) {
      // Calculate which segment is under the pointer after the wheel stops
      _resultIndex = _calculateResultFromAngle(targetAngle);
      if (_resultIndex != null) {
        // Play celebration sound before showing result
        _playCelebrationSound();
        widget.onResult(widget.options[_resultIndex!]);
      }
    });
  }

  int _calculateResultFromAngle(double totalRotation) {
    final segmentAngle = 2 * pi / widget.options.length;
    
    // Normalize rotation to [0, 2π)
    final normalizedRotation = totalRotation % (2 * pi);
    
    // How many segments did we rotate?
    final segmentsMoved = normalizedRotation / segmentAngle;
    
    // The segment under the pointer is the original segment 0 minus the segments moved
    // (since counterclockwise rotation moves us backwards through the segment indices when viewed from the pointer's perspective)
    int resultIndex = (-segmentsMoved.ceil()) % widget.options.length;

    // Ensure positive index
     if (resultIndex < 0) {
      resultIndex += widget.options.length;
    }
    
    return resultIndex;
  }

  @override
  void dispose() {
    _rotationAnimation.removeListener(_onRotationChanged);
    _rotationController.dispose();
    _audioPlayer.dispose();
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
                  size: const Size(450, 450),
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