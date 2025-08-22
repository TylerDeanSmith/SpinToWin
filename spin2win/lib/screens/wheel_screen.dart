import 'package:flutter/material.dart';
import '../models/wheel_configuration.dart';
import '../models/wheel_option.dart';
import '../services/configuration_service.dart';
import '../widgets/spinning_wheel.dart';
import '../widgets/celebration_animation.dart';

class WheelScreen extends StatefulWidget {
  final WheelConfiguration configuration;
  final int configIndex;
  final List<WheelConfiguration> allConfigurations;

  const WheelScreen({
    super.key,
    required this.configuration,
    required this.configIndex,
    required this.allConfigurations,
  });

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  bool _isSpinning = false;
  bool _showCelebration = false;
  WheelOption? _result;
  bool _canSpin = true;

  void _spinWheel() {
    if (!_canSpin || _isSpinning) return;

    setState(() {
      _isSpinning = true;
      _canSpin = false;
      _showCelebration = false;
      _result = null;
    });
  }

  void _onSpinResult(WheelOption result) {
    setState(() {
      _isSpinning = false;
      _result = result;
      _showCelebration = true;
    });
  }

  void _onCelebrationComplete() {
    setState(() {
      _showCelebration = false;
      _canSpin = true;
    });
  }

  void _nextWheel() async {
    final nextIndex = widget.configuration.nextIndex;
    
    if (nextIndex < widget.allConfigurations.length) {
      final nextConfig = widget.allConfigurations[nextIndex];
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WheelScreen(
            configuration: nextConfig,
            configIndex: nextIndex,
            allConfigurations: widget.allConfigurations,
          ),
        ),
      );
    } else {
      // No more wheels, go back to home
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All wheels completed! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.configuration.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinningWheel(
                        options: widget.configuration.options,
                        onResult: _onSpinResult,
                        isSpinning: _isSpinning,
                      ),
                      const SizedBox(height: 40),
                      if (_result != null && !_showCelebration) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(int.parse('FF${_result!.color}', radix: 16)),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Result: ${_result!.label}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (widget.configuration.nextIndex < widget.allConfigurations.length)
                          ElevatedButton(
                            onPressed: _nextWheel,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text(
                              'Next Wheel',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text(
                              'Finish',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canSpin ? _spinWheel : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _isSpinning ? 'Spinning...' : 'SPIN!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          CelebrationAnimation(
            isVisible: _showCelebration,
            winningText: _result?.label ?? '',
            onComplete: _onCelebrationComplete,
          ),
        ],
      ),
    );
  }
}