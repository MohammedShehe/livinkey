import 'package:flutter/material.dart';
import '../widgets/livinkey_logo.dart';
import 'get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _keyRotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // 1.0 = key "straight up" (starting position)
    // 0.0 = key "facing down", matching the final logo artwork
    _keyRotation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // small pause so the "straight" key is visible for a beat before it moves
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    await _controller.forward();

    // hold the final logo on screen for 3 seconds before moving on
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLivinkeyBlack,
      body: Center(
        child: LivinkeyLogo(keyAnimation: _keyRotation),
      ),
    );
  }
}