import 'package:flutter/material.dart';
import 'package:remote/utils/images.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Initial rotation of the car
  double _carRotation = 0.0;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initializing the rotation animation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _rotateCar(double angle) {
    setState(() {
      _rotationAnimation = Tween<double>(
        begin: _carRotation,
        end: angle,
      ).animate(_animationController);

      _carRotation = angle;
    });

    _animationController.forward(from: 0.0);
  }

  Widget remoteButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTapDown: (_) async {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 50);
        }
        onPressed();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white60, width: 1.5),
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF434343),
              Color(0xFF000000),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Car
                SizedBox(
                  height: 150,
                  child: AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Image.asset(
                            car,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Up Button
                remoteButton(
                  icon: Icons.arrow_upward,
                  onPressed: () {
                    _rotateCar(0.0); // Rotate upward
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Button
                    remoteButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        _rotateCar(-1.57); // Rotate left
                      },
                    ),
                    const SizedBox(width: 20),
                    // Center Button
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8E8E93),
                            Color(0xFF121212),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.circle,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right Button
                    remoteButton(
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        _rotateCar(1.57); // Rotate right
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Down Button
                remoteButton(
                  icon: Icons.arrow_downward,
                  onPressed: () {
                    _rotateCar(3.14); // Rotate downward
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
