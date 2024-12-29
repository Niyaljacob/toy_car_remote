import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote/controller/bloc/remote_bloc.dart';
import 'package:remote/controller/bloc/remote_event.dart';
import 'package:remote/controller/bloc/remote_state.dart';
import 'package:remote/utils/images.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _carRotation = 0.0;

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(_animationController);
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
      body: BlocListener<RemoteBloc, RemoteState>(
        listener: (context, state) {
          if (state is RemoteLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sending command...')),
            );
          } else if (state is RemoteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RemoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Container(
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
                  remoteButton(
                    icon: Icons.arrow_upward,
                    onPressed: () {
                      context.read<RemoteBloc>().add(SendCommandEvent('up'));
                      _rotateCar(0.0);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      remoteButton(
                        icon: Icons.arrow_back,
                        onPressed: () {
                          context
                              .read<RemoteBloc>()
                              .add(SendCommandEvent('left'));
                          _rotateCar(-1.57);
                        },
                      ),
                      const SizedBox(width: 20),
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
                      remoteButton(
                        icon: Icons.arrow_forward,
                        onPressed: () {
                          context
                              .read<RemoteBloc>()
                              .add(SendCommandEvent('right'));
                          _rotateCar(1.57);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  remoteButton(
                    icon: Icons.arrow_downward,
                    onPressed: () {
                      context.read<RemoteBloc>().add(SendCommandEvent('down'));
                      _rotateCar(3.14);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
