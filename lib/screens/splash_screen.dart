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

    // Slowed further (was 6000ms) for an even calmer, more deliberate glide
    // now that the key also tumbles while it travels.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7500),
    );

    // 0.0 = key at its starting point above the roof, upright
    // 1.0 = key at the end of the path, resting next to 'e', having
    //       completed a full 360° tumble so it lands straight (like 'Y')
    _keyRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // small pause so the "straight" key is visible for a beat before it moves
    await Future.delayed(const Duration(milliseconds: 500));
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