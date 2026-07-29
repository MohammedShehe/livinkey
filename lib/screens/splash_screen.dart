import 'package:flutter/material.dart';
import '../widgets/livinkey_logo.dart';
import 'get_started_screen.dart';
import '../services/audio_service.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playBackgroundMusic();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7500),
    );

    _keyRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _startSequence();
  }

  Future<void> _playBackgroundMusic() async {
    await AudioService.playBackgroundMusic('splash_screen.mp3');
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await _controller.forward();

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
    }
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