import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ilike/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Navigate to the login screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        // child: Image.asset('assets/images/logo.png'),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Text(
            'iLike 💖',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.pink[800],
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
