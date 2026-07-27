import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/livinkey_logo.dart';
import 'login_screen.dart';

/// Complete Forgot Password flow with smooth animations
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  // Controllers for each step
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Step tracking
  int _currentStep = 0; // 0: Email, 1: OTP, 2: New Password
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String _email = '';

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  // Gesture recognizers
  late final TapGestureRecognizer _backToLoginRecognizer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _backToLoginRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HapticFeedback.selectionClick();
        _navigateBackToLogin();
      };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _backToLoginRecognizer.dispose();
    super.dispose();
  }

  void _navigateBackToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
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
  }

  void _nextStep() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentStep++;
    });
    // Trigger animations for new step
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  void _previousStep() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentStep--;
    });
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Step 0: Send OTP
  void _handleSendOTP() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter your email address', Colors.red.shade800);
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email address', Colors.red.shade800);
      return;
    }

    setState(() {
      _isLoading = true;
      _email = email;
    });

    // Simulate API call to send OTP
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('OTP sent to $email', kLivinkeyGreen);
      _nextStep();
    }
  }

  // Step 1: Resend OTP (stays on OTP step)
  void _handleResendOTP() async {
    if (_email.isEmpty) {
      _showSnackBar('Email not found. Please go back.', Colors.red.shade800);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call to resend OTP
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('OTP resent to $_email', kLivinkeyGreen);
    }
  }

  // Step 1: Verify OTP
  void _handleVerifyOTP() async {
    final String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showSnackBar('Please enter the OTP', Colors.red.shade800);
      return;
    }

    if (otp.length < 4) {
      _showSnackBar('Please enter a valid OTP', Colors.red.shade800);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('OTP verified successfully!', kLivinkeyGreen);
      _nextStep();
    }
  }

  // Step 2: Create new password
  void _handleResetPassword() async {
    final String newPassword = _newPasswordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      _showSnackBar('Please enter a new password', Colors.red.shade800);
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar('Password must be at least 6 characters', Colors.red.shade800);
      return;
    }

    if (confirmPassword.isEmpty) {
      _showSnackBar('Please confirm your password', Colors.red.shade800);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Passwords do not match', Colors.red.shade800);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate password reset
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('Password reset successful!', kLivinkeyGreen);
      
      // Navigate back to login after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _navigateBackToLogin();
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Forgot Password';
      case 1:
        return 'Verify OTP';
      case 2:
        return 'Create New Password';
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Enter your registered email to receive OTP';
      case 1:
        return 'Enter the OTP sent to your email';
      case 2:
        return 'Create a strong new password';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: kLivinkeyBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: kLivinkeyBlack,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Back Button
                          GestureDetector(
                            onTap: _navigateBackToLogin,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kLivinkeyWhite.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kLivinkeyWhite.withOpacity(0.08),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Progress Indicator
                          _buildProgressIndicator(),

                          const SizedBox(height: 32),

                          // Header
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getStepTitle(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getStepSubtitle(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.6),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Step Content
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildStepContent(),
                          ),

                          const SizedBox(height: 24),

                          // Back to Login Link
                          Center(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  const TextSpan(text: 'Remember your password? '),
                                  TextSpan(
                                    text: 'Back to Login',
                                    style: TextStyle(
                                      color: kLivinkeyGreen,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          kLivinkeyGreen.withOpacity(0.3),
                                    ),
                                    recognizer: _backToLoginRecognizer,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = index <= _currentStep;
        bool isCurrent = index == _currentStep;
        
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [kLivinkeyGreen, Color(0xFF66BB6A)],
                              )
                            : LinearGradient(
                                colors: [
                                  kLivinkeyWhite.withOpacity(0.1),
                                  kLivinkeyWhite.withOpacity(0.1),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [kLivinkeyGreen, Color(0xFF66BB6A)],
                        )
                      : LinearGradient(
                          colors: [
                            kLivinkeyWhite.withOpacity(0.1),
                            kLivinkeyWhite.withOpacity(0.1),
                          ],
                        ),
                  border: Border.all(
                    color: isActive
                        ? kLivinkeyGreen
                        : kLivinkeyWhite.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: kLivinkeyGreen,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOTPStep();
      case 2:
        return _buildPasswordStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: Email Input
  Widget _buildEmailStep() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kLivinkeyWhite.withOpacity(0.05),
                kLivinkeyWhite.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kLivinkeyWhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSendOTP(),
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: kLivinkeyGreen.withOpacity(0.7),
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: kLivinkeyGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildActionButton(
          onPressed: _handleSendOTP,
          label: 'Send OTP',
          icon: Icons.send_rounded,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  // STEP 1: OTP Verification
  Widget _buildOTPStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kLivinkeyGreen.withOpacity(0.08),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kLivinkeyGreen.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kLivinkeyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mark_email_read_rounded,
                  color: kLivinkeyGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP sent to',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : _handleResendOTP, // Use resend function
                style: TextButton.styleFrom(
                  foregroundColor: kLivinkeyGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Resend'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kLivinkeyWhite.withOpacity(0.05),
                kLivinkeyWhite.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kLivinkeyWhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _otpController,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleVerifyOTP(),
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'Enter OTP',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              counterText: '',
              prefixIcon: Icon(
                Icons.pin_outlined,
                color: kLivinkeyGreen.withOpacity(0.7),
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: kLivinkeyGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: _previousStep,
                label: 'Back',
                icon: Icons.arrow_back_rounded,
                isLoading: false,
                isOutlined: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                onPressed: _handleVerifyOTP,
                label: 'Verify',
                icon: Icons.check_circle_rounded,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 2: New Password
  Widget _buildPasswordStep() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kLivinkeyWhite.withOpacity(0.05),
                kLivinkeyWhite.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kLivinkeyWhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            style: const TextStyle(color: Colors.white),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: kLivinkeyGreen.withOpacity(0.7),
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: kLivinkeyGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kLivinkeyWhite.withOpacity(0.05),
                kLivinkeyWhite.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kLivinkeyWhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: const TextStyle(color: Colors.white),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleResetPassword(),
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: kLivinkeyGreen.withOpacity(0.7),
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                  HapticFeedback.lightImpact();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: kLivinkeyGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.3),
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Password must be at least 6 characters',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: _previousStep,
                label: 'Back',
                icon: Icons.arrow_back_rounded,
                isLoading: false,
                isOutlined: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                onPressed: _handleResetPassword,
                label: 'Reset Password',
                icon: Icons.check_circle_rounded,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required bool isLoading,
    bool isOutlined = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: BoxDecoration(
        gradient: isOutlined
            ? null
            : const LinearGradient(
                colors: [
                  kLivinkeyGreen,
                  Color(0xFF4CAF50),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        border: isOutlined
            ? Border.all(
                color: kLivinkeyWhite.withOpacity(0.15),
                width: 1.5,
              )
            : null,
        boxShadow: isOutlined
            ? null
            : [
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
          backgroundColor: isOutlined ? Colors.transparent : Colors.transparent,
          foregroundColor: isOutlined ? Colors.white : Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined ? Colors.white : Colors.black,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isOutlined ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isOutlined ? Colors.white : Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}