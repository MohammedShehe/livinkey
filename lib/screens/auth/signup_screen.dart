import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../../widgets/livinkey_logo.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/snackbar_helper.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedNationality = 'Indian';
  String _selectedCountryCode = '+91';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoScaleAnimation;

  late final TapGestureRecognizer _backToLoginRecognizer;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  final List<String> _nationalities = [
    'Afghan', 'Albanian', 'Algerian', 'American', 'Andorran', 'Angolan',
    'Argentinian', 'Armenian', 'Australian', 'Austrian', 'Azerbaijani',
    'Bahamian', 'Bahraini', 'Bangladeshi', 'Barbadian', 'Belarusian',
    'Belgian', 'Belizean', 'Beninese', 'Bhutanese', 'Bolivian', 'Bosnian',
    'Botswanan', 'Brazilian', 'British', 'Bruneian', 'Bulgarian', 'Burkinabe',
    'Burmese', 'Burundian', 'Cambodian', 'Cameroonian', 'Canadian',
    'Cape Verdean', 'Central African', 'Chadian', 'Chilean', 'Chinese',
    'Colombian', 'Comorian', 'Congolese', 'Costa Rican', 'Croatian',
    'Cuban', 'Cypriot', 'Czech', 'Danish', 'Djiboutian', 'Dominican',
    'Dutch', 'Ecuadorian', 'Egyptian', 'Emirati', 'Equatorial Guinean',
    'Eritrean', 'Estonian', 'Ethiopian', 'Fijian', 'Filipino', 'Finnish',
    'French', 'Gabonese', 'Gambian', 'Georgian', 'German', 'Ghanaian',
    'Greek', 'Grenadian', 'Guatemalan', 'Guinean', 'Guyanese', 'Haitian',
    'Honduran', 'Hungarian', 'Icelandic', 'Indian', 'Indonesian', 'Iranian',
    'Iraqi', 'Irish', 'Israeli', 'Italian', 'Jamaican', 'Japanese',
    'Jordanian', 'Kazakh', 'Kenyan', 'Kittitian', 'Kuwaiti', 'Kyrgyz',
    'Laotian', 'Latvian', 'Lebanese', 'Liberian', 'Libyan', 'Liechtensteiner',
    'Lithuanian', 'Luxembourgish', 'Malagasy', 'Malawian', 'Malaysian',
    'Maldivian', 'Malian', 'Maltese', 'Marshallese', 'Mauritanian',
    'Mauritian', 'Mexican', 'Micronesian', 'Moldovan', 'Monacan',
    'Mongolian', 'Montenegrin', 'Moroccan', 'Mozambican', 'Namibian',
    'Nauruan', 'Nepali', 'New Zealander', 'Nicaraguan', 'Nigerian',
    'North Korean', 'Norwegian', 'Omani', 'Pakistani', 'Palauan',
    'Panamanian', 'Papua New Guinean', 'Paraguayan', 'Peruvian', 'Polish',
    'Portuguese', 'Qatari', 'Romanian', 'Russian', 'Rwandan', 'Salvadoran',
    'Samoan', 'Sao Tomean', 'Saudi', 'Senegalese', 'Serbian', 'Seychellois',
    'Sierra Leonean', 'Singaporean', 'Slovak', 'Slovenian',
    'Solomon Islander', 'Somali', 'South African', 'South Korean',
    'South Sudanese', 'Spanish', 'Sri Lankan', 'Sudanese', 'Surinamese',
    'Swazi', 'Swedish', 'Swiss', 'Syrian', 'Taiwanese', 'Tajik',
    'Tanzanian', 'Thai', 'Timorese', 'Togolese', 'Tongan', 'Trinidadian',
    'Tunisian', 'Turkish', 'Turkmen', 'Tuvaluan', 'Ugandan', 'Ukrainian',
    'Uruguayan', 'Uzbek', 'Vanuatuan', 'Vatican', 'Venezuelan',
    'Vietnamese', 'Yemeni', 'Zambian', 'Zimbabwean',
  ];

  final List<Map<String, String>> _countryCodes = [
    {'code': '+91', 'country': 'India'},
    {'code': '+1', 'country': 'USA/Canada'},
    {'code': '+44', 'country': 'United Kingdom'},
    {'code': '+61', 'country': 'Australia'},
    {'code': '+81', 'country': 'Japan'},
    {'code': '+86', 'country': 'China'},
    {'code': '+92', 'country': 'Pakistan'},
    {'code': '+94', 'country': 'Sri Lanka'},
    {'code': '+880', 'country': 'Bangladesh'},
    {'code': '+977', 'country': 'Nepal'},
    {'code': '+60', 'country': 'Malaysia'},
    {'code': '+65', 'country': 'Singapore'},
    {'code': '+971', 'country': 'UAE'},
    {'code': '+966', 'country': 'Saudi Arabia'},
    {'code': '+49', 'country': 'Germany'},
    {'code': '+33', 'country': 'France'},
    {'code': '+39', 'country': 'Italy'},
    {'code': '+34', 'country': 'Spain'},
    {'code': '+55', 'country': 'Brazil'},
    {'code': '+52', 'country': 'Mexico'},
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1400),
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

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutBack,
      ),
    );

    _backToLoginRecognizer = TapGestureRecognizer()
      ..onTap = () {
        hapticSelection();
        _navigateBackToLogin();
      };

    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        hapticSelection();
        SnackbarHelper.show(context, 'Terms of Services');
      };

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        hapticSelection();
        SnackbarHelper.show(context, 'Privacy Policy');
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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _backToLoginRecognizer.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return phone.length >= 5 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      SnackbarHelper.showError(context, 'Please agree to the Terms of Services');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      SnackbarHelper.showSuccess(context, 'OTP sent to ${_emailController.text}');

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OtpVerificationScreen(
                email: _emailController.text,
                userData: {
                  'fullName': _fullNameController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'nationality': _selectedNationality,
                  'countryCode': _selectedCountryCode,
                  'role': 'guest',
                },
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: _navigateBackToLogin,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
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

                            const SizedBox(height: 24),

                            Align(
                              alignment: Alignment.topRight,
                              child: ScaleTransition(
                                scale: _logoScaleAnimation,
                                child: Image.asset(
                                  kGeneralLogo,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Join the Livinkey community as a Guest',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFFF9800).withOpacity(0.15),
                                    const Color(0xFFFF9800).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFF9800).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF9800),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Guest Account',
                                    style: TextStyle(
                                      color: const Color(0xFFFF9800),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9800).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Fixed',
                                      style: TextStyle(
                                        color: const Color(0xFFFF9800).withOpacity(0.6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            _buildTextField(
                              controller: _fullNameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!_isValidEmail(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.05),
                                    Colors.white.withOpacity(0.02),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedNationality,
                                dropdownColor: Colors.black,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Nationality',
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.flag_outlined,
                                    color: const Color(0xFF92C24A).withOpacity(0.7),
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF92C24A).withOpacity(0.5),
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
                                    vertical: 12,
                                  ),
                                ),
                                items: _nationalities.map((nationality) {
                                  return DropdownMenuItem<String>(
                                    value: nationality,
                                    child: Text(
                                      nationality,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedNationality = value!;
                                  });
                                  hapticSelection();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your nationality';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.05),
                                          Colors.white.withOpacity(0.02),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedCountryCode,
                                      dropdownColor: Colors.black,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'Code',
                                        labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: const Color(0xFF92C24A).withOpacity(0.5),
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
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      items: _countryCodes.map((country) {
                                        return DropdownMenuItem<String>(
                                          value: country['code'],
                                          child: Text(
                                            country['code']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountryCode = value!;
                                        });
                                        hapticSelection();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select code';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.05),
                                          Colors.white.withOpacity(0.02),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      style: const TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone_outlined,
                                          color: const Color(0xFF92C24A).withOpacity(0.7),
                                          size: 22,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: const Color(0xFF92C24A).withOpacity(0.5),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter phone number';
                                        }
                                        if (!_isValidPhone(value)) {
                                          return 'Enter a valid phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                  hapticFeedback();
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              icon: Icons.lock_outline,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
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
                                  hapticFeedback();
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
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

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      fillColor: WidgetStateProperty.resolveWith(
                                        (states) => const Color(0xFF92C24A),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    unselectedWidgetColor:
                                        Colors.white.withOpacity(0.3),
                                  ),
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value!;
                                      });
                                      hapticSelection();
                                    },
                                    activeColor: const Color(0xFF92C24A),
                                    checkColor: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        const TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Services',
                                          style: TextStyle(
                                            color: const Color(0xFF92C24A).withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            decorationColor:
                                                const Color(0xFF92C24A).withOpacity(0.3),
                                          ),
                                          recognizer: _termsRecognizer,
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: const Color(0xFF92C24A).withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            decorationColor:
                                                const Color(0xFF92C24A).withOpacity(0.3),
                                          ),
                                          recognizer: _privacyRecognizer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: _agreeToTerms
                                    ? const LinearGradient(
                                        colors: [Color(0xFF92C24A), Color(0xFF4CAF50)],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _agreeToTerms
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF92C24A).withOpacity(0.3),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFF92C24A).withOpacity(0.1),
                                          blurRadius: 40,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: _agreeToTerms
                                      ? Colors.black
                                      : Colors.white.withOpacity(0.4),
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _isLoading || !_agreeToTerms
                                    ? null
                                    : _handleSignUp,
                                child: _isLoading
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              const AlwaysStoppedAnimation<Color>(
                                                Colors.black,
                                              ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: _agreeToTerms
                                                  ? Colors.black
                                                  : Colors.white.withOpacity(0.4),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: _agreeToTerms
                                                ? Colors.black
                                                : Colors.white.withOpacity(0.4),
                                            size: 22,
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: TextStyle(
                                        color: const Color(0xFF92C24A),
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            const Color(0xFF92C24A).withOpacity(0.3),
                                      ),
                                      recognizer: _backToLoginRecognizer,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF92C24A).withOpacity(0.7),
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF92C24A).withOpacity(0.5),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          errorStyle: TextStyle(
            color: Colors.red.shade300,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        validator: validator,
      ),
    );
  }
}