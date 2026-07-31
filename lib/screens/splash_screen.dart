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
      // Slowed from 7500ms -> 9500ms so each hop has more room to
      // breathe. Combined with the sine-based easing now used inside
      // LivinkeyLogo, this is what makes the bounce read as smooth
      // rather than quick/snappy.
      duration: const Duration(milliseconds: 9500),
    );

    _keyRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    // Note: curve is linear on purpose. All the easing (per-hop ease-in/
    // out, arc shaping, squash-and-stretch) is already computed inside
    // LivinkeyLogo based on raw progress — layering a second curve here
    // would fight that shaping and make the motion feel uneven again.

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