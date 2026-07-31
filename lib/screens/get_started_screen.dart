import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../widgets/livinkey_logo.dart';
import 'auth/login_screen.dart';
import '../services/audio_service.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _keyRotationAnimation;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playBackgroundMusic();
    });

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _keyRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HapticFeedback.selectionClick();
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HapticFeedback.selectionClick();
      };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _logoController.forward();
      });
    });
  }

  Future<void> _playBackgroundMusic() async {
    await AudioService.playBackgroundMusic('get_started.mp3');
  }

  @override
  void dispose() {
    _mainController.dispose();
    _logoController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    AudioService.stopBackgroundMusic();
    super.dispose();
  }

  // Prevent back navigation from GetStartedScreen
  Future<bool> _onWillPop() async {
    // Show exit dialog when back button is pressed on GetStartedScreen
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kLivinkeyBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Exit App?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kLivinkeyGreen, Color(0xFF7CB342)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: kLivinkeyBlack,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: kLivinkeyBlack,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),

                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 30,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  kLivinkeyGreen.withOpacity(0.08),
                                  Colors.transparent,
                                  kLivinkeyGreen.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: kLivinkeyGreen.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: LivinkeyLogoKeyFlip(
                              keyAnimation: _keyRotationAnimation,
                              width: 280,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  kLivinkeyWhite.withOpacity(0.06),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kLivinkeyWhite.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Start your living journey with',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kLivinkeyWhite.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      kLivinkeyGreen,
                                      const Color(0xFF66BB6A),
                                      kLivinkeyGreen,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Livinkey',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kLivinkeyWhite,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: kLivinkeyWhite.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: kLivinkeyWhite.withOpacity(0.06),
                                width: 1,
                              ),
                            ),
                           child: Text(
                              'We believe that finding a home is just the beginning of your journey. Livinkey is a comprehensive platform designed to transform the way you discover, book, and manage your living space.\n\nWhether you\'re a student, professional, or anyone seeking a comfortable stay, Livinkey makes your entire living experience seamless and stress-free.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 15,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.3),
                          child: _buildGetStartedButton(),
                        ),

                        const SizedBox(height: 24),

                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.2),
                          child: _buildTermsText(),
                        ),

                        const SizedBox(height: 20),
                        const Spacer(flex: 1),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              kLivinkeyGreen,
              Color(0xFF4CAF50),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kLivinkeyGreen.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: kLivinkeyGreen.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            AudioService.stopBackgroundMusic();
            // 🔥 KEY CHANGE: Use pushReplacement to prevent going back
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.black,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    const baseStyle = TextStyle(
      fontSize: 12,
      height: 1.6,
      fontWeight: FontWeight.w400,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kLivinkeyWhite.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kLivinkeyWhite.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: baseStyle.copyWith(color: Colors.white.withOpacity(0.5)),
          children: [
            const TextSpan(text: 'By continuing you agree to '),
            TextSpan(
              text: 'Terms of Services',
              style: baseStyle.copyWith(
                color: kLivinkeyGreen.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: kLivinkeyGreen.withOpacity(0.3),
              ),
              recognizer: _termsRecognizer,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: baseStyle.copyWith(
                color: kLivinkeyGreen.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: kLivinkeyGreen.withOpacity(0.3),
              ),
              recognizer: _privacyRecognizer,
            ),
          ],
        ),
      ),
    );
  }
}