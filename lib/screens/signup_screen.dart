import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../widgets/livinkey_logo.dart';
import 'login_screen.dart';

/// Complete Sign Up flow with form validation and smooth animations
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dropdown values
  String _selectedNationality = 'Indian';
  String _selectedCountryCode = '+91';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoScaleAnimation;

  // Gesture recognizers
  late final TapGestureRecognizer _backToLoginRecognizer;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  // Nationality data
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

  // Country codes for phone numbers
  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'USA/Canada'},
    {'code': '+1-242', 'country': 'Bahamas'},
    {'code': '+1-246', 'country': 'Barbados'},
    {'code': '+1-473', 'country': 'Grenada'},
    {'code': '+1-758', 'country': 'St. Lucia'},
    {'code': '+1-767', 'country': 'Dominica'},
    {'code': '+1-784', 'country': 'St. Vincent'},
    {'code': '+1-809', 'country': 'Dominican Republic'},
    {'code': '+1-868', 'country': 'Trinidad & Tobago'},
    {'code': '+1-869', 'country': 'St. Kitts & Nevis'},
    {'code': '+1-876', 'country': 'Jamaica'},
    {'code': '+20', 'country': 'Egypt'},
    {'code': '+27', 'country': 'South Africa'},
    {'code': '+30', 'country': 'Greece'},
    {'code': '+31', 'country': 'Netherlands'},
    {'code': '+32', 'country': 'Belgium'},
    {'code': '+33', 'country': 'France'},
    {'code': '+34', 'country': 'Spain'},
    {'code': '+36', 'country': 'Hungary'},
    {'code': '+39', 'country': 'Italy'},
    {'code': '+40', 'country': 'Romania'},
    {'code': '+41', 'country': 'Switzerland'},
    {'code': '+42', 'country': 'Czech Republic'},
    {'code': '+43', 'country': 'Austria'},
    {'code': '+44', 'country': 'United Kingdom'},
    {'code': '+45', 'country': 'Denmark'},
    {'code': '+46', 'country': 'Sweden'},
    {'code': '+47', 'country': 'Norway'},
    {'code': '+48', 'country': 'Poland'},
    {'code': '+49', 'country': 'Germany'},
    {'code': '+51', 'country': 'Peru'},
    {'code': '+52', 'country': 'Mexico'},
    {'code': '+53', 'country': 'Cuba'},
    {'code': '+54', 'country': 'Argentina'},
    {'code': '+55', 'country': 'Brazil'},
    {'code': '+56', 'country': 'Chile'},
    {'code': '+57', 'country': 'Colombia'},
    {'code': '+58', 'country': 'Venezuela'},
    {'code': '+60', 'country': 'Malaysia'},
    {'code': '+61', 'country': 'Australia'},
    {'code': '+62', 'country': 'Indonesia'},
    {'code': '+63', 'country': 'Philippines'},
    {'code': '+64', 'country': 'New Zealand'},
    {'code': '+65', 'country': 'Singapore'},
    {'code': '+66', 'country': 'Thailand'},
    {'code': '+81', 'country': 'Japan'},
    {'code': '+82', 'country': 'South Korea'},
    {'code': '+84', 'country': 'Vietnam'},
    {'code': '+86', 'country': 'China'},
    {'code': '+90', 'country': 'Turkey'},
    {'code': '+91', 'country': 'India'},
    {'code': '+92', 'country': 'Pakistan'},
    {'code': '+93', 'country': 'Afghanistan'},
    {'code': '+94', 'country': 'Sri Lanka'},
    {'code': '+95', 'country': 'Myanmar'},
    {'code': '+98', 'country': 'Iran'},
    {'code': '+211', 'country': 'South Sudan'},
    {'code': '+212', 'country': 'Morocco'},
    {'code': '+213', 'country': 'Algeria'},
    {'code': '+216', 'country': 'Tunisia'},
    {'code': '+218', 'country': 'Libya'},
    {'code': '+220', 'country': 'Gambia'},
    {'code': '+221', 'country': 'Senegal'},
    {'code': '+222', 'country': 'Mauritania'},
    {'code': '+223', 'country': 'Mali'},
    {'code': '+224', 'country': 'Guinea'},
    {'code': '+225', 'country': 'Ivory Coast'},
    {'code': '+226', 'country': 'Burkina Faso'},
    {'code': '+227', 'country': 'Niger'},
    {'code': '+228', 'country': 'Togo'},
    {'code': '+229', 'country': 'Benin'},
    {'code': '+230', 'country': 'Mauritius'},
    {'code': '+231', 'country': 'Liberia'},
    {'code': '+232', 'country': 'Sierra Leone'},
    {'code': '+233', 'country': 'Ghana'},
    {'code': '+234', 'country': 'Nigeria'},
    {'code': '+235', 'country': 'Chad'},
    {'code': '+236', 'country': 'Central African Republic'},
    {'code': '+237', 'country': 'Cameroon'},
    {'code': '+238', 'country': 'Cape Verde'},
    {'code': '+239', 'country': 'Sao Tome & Principe'},
    {'code': '+240', 'country': 'Equatorial Guinea'},
    {'code': '+241', 'country': 'Gabon'},
    {'code': '+242', 'country': 'Congo'},
    {'code': '+243', 'country': 'DR Congo'},
    {'code': '+244', 'country': 'Angola'},
    {'code': '+245', 'country': 'Guinea-Bissau'},
    {'code': '+248', 'country': 'Seychelles'},
    {'code': '+249', 'country': 'Sudan'},
    {'code': '+250', 'country': 'Rwanda'},
    {'code': '+251', 'country': 'Ethiopia'},
    {'code': '+252', 'country': 'Somalia'},
    {'code': '+253', 'country': 'Djibouti'},
    {'code': '+254', 'country': 'Kenya'},
    {'code': '+255', 'country': 'Tanzania'},
    {'code': '+256', 'country': 'Uganda'},
    {'code': '+257', 'country': 'Burundi'},
    {'code': '+258', 'country': 'Mozambique'},
    {'code': '+260', 'country': 'Zambia'},
    {'code': '+261', 'country': 'Madagascar'},
    {'code': '+263', 'country': 'Zimbabwe'},
    {'code': '+264', 'country': 'Namibia'},
    {'code': '+265', 'country': 'Malawi'},
    {'code': '+266', 'country': 'Lesotho'},
    {'code': '+267', 'country': 'Botswana'},
    {'code': '+268', 'country': 'Eswatini'},
    {'code': '+269', 'country': 'Comoros'},
    {'code': '+291', 'country': 'Eritrea'},
    {'code': '+297', 'country': 'Aruba'},
    {'code': '+298', 'country': 'Faroe Islands'},
    {'code': '+299', 'country': 'Greenland'},
    {'code': '+350', 'country': 'Gibraltar'},
    {'code': '+351', 'country': 'Portugal'},
    {'code': '+352', 'country': 'Luxembourg'},
    {'code': '+353', 'country': 'Ireland'},
    {'code': '+354', 'country': 'Iceland'},
    {'code': '+355', 'country': 'Albania'},
    {'code': '+356', 'country': 'Malta'},
    {'code': '+357', 'country': 'Cyprus'},
    {'code': '+358', 'country': 'Finland'},
    {'code': '+359', 'country': 'Bulgaria'},
    {'code': '+370', 'country': 'Lithuania'},
    {'code': '+371', 'country': 'Latvia'},
    {'code': '+372', 'country': 'Estonia'},
    {'code': '+373', 'country': 'Moldova'},
    {'code': '+374', 'country': 'Armenia'},
    {'code': '+375', 'country': 'Belarus'},
    {'code': '+376', 'country': 'Andorra'},
    {'code': '+377', 'country': 'Monaco'},
    {'code': '+378', 'country': 'San Marino'},
    {'code': '+379', 'country': 'Vatican City'},
    {'code': '+380', 'country': 'Ukraine'},
    {'code': '+381', 'country': 'Serbia'},
    {'code': '+382', 'country': 'Montenegro'},
    {'code': '+385', 'country': 'Croatia'},
    {'code': '+386', 'country': 'Slovenia'},
    {'code': '+387', 'country': 'Bosnia'},
    {'code': '+420', 'country': 'Czech Republic'},
    {'code': '+421', 'country': 'Slovakia'},
    {'code': '+423', 'country': 'Liechtenstein'},
    {'code': '+501', 'country': 'Belize'},
    {'code': '+502', 'country': 'Guatemala'},
    {'code': '+503', 'country': 'El Salvador'},
    {'code': '+504', 'country': 'Honduras'},
    {'code': '+505', 'country': 'Nicaragua'},
    {'code': '+506', 'country': 'Costa Rica'},
    {'code': '+507', 'country': 'Panama'},
    {'code': '+591', 'country': 'Bolivia'},
    {'code': '+592', 'country': 'Guyana'},
    {'code': '+593', 'country': 'Ecuador'},
    {'code': '+595', 'country': 'Paraguay'},
    {'code': '+597', 'country': 'Suriname'},
    {'code': '+598', 'country': 'Uruguay'},
    {'code': '+670', 'country': 'Timor-Leste'},
    {'code': '+673', 'country': 'Brunei'},
    {'code': '+674', 'country': 'Nauru'},
    {'code': '+675', 'country': 'Papua New Guinea'},
    {'code': '+676', 'country': 'Tonga'},
    {'code': '+677', 'country': 'Solomon Islands'},
    {'code': '+678', 'country': 'Vanuatu'},
    {'code': '+679', 'country': 'Fiji'},
    {'code': '+680', 'country': 'Palau'},
    {'code': '+685', 'country': 'Samoa'},
    {'code': '+686', 'country': 'Kiribati'},
    {'code': '+688', 'country': 'Tuvalu'},
    {'code': '+691', 'country': 'Micronesia'},
    {'code': '+692', 'country': 'Marshall Islands'},
    {'code': '+850', 'country': 'North Korea'},
    {'code': '+855', 'country': 'Cambodia'},
    {'code': '+856', 'country': 'Laos'},
    {'code': '+880', 'country': 'Bangladesh'},
    {'code': '+886', 'country': 'Taiwan'},
    {'code': '+960', 'country': 'Maldives'},
    {'code': '+961', 'country': 'Lebanon'},
    {'code': '+962', 'country': 'Jordan'},
    {'code': '+963', 'country': 'Syria'},
    {'code': '+964', 'country': 'Iraq'},
    {'code': '+965', 'country': 'Kuwait'},
    {'code': '+966', 'country': 'Saudi Arabia'},
    {'code': '+967', 'country': 'Yemen'},
    {'code': '+968', 'country': 'Oman'},
    {'code': '+970', 'country': 'Palestine'},
    {'code': '+971', 'country': 'UAE'},
    {'code': '+972', 'country': 'Israel'},
    {'code': '+973', 'country': 'Bahrain'},
    {'code': '+974', 'country': 'Qatar'},
    {'code': '+975', 'country': 'Bhutan'},
    {'code': '+976', 'country': 'Mongolia'},
    {'code': '+977', 'country': 'Nepal'},
    {'code': '+992', 'country': 'Tajikistan'},
    {'code': '+993', 'country': 'Turkmenistan'},
    {'code': '+994', 'country': 'Azerbaijan'},
    {'code': '+995', 'country': 'Georgia'},
    {'code': '+996', 'country': 'Kyrgyzstan'},
    {'code': '+998', 'country': 'Uzbekistan'},
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
        HapticFeedback.selectionClick();
        _navigateBackToLogin();
      };

    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HapticFeedback.selectionClick();
        _showSnackBar('Terms of Services', kLivinkeyGreen);
      };

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HapticFeedback.selectionClick();
        _showSnackBar('Privacy Policy', kLivinkeyGreen);
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
      _showSnackBar('Please agree to the Terms of Services', Colors.red.shade800);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('Account created successfully! 🎉', kLivinkeyGreen);
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
                      child: Form(
                        key: _formKey,
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

                            const SizedBox(height: 24),

                            // Logo
                            Align(
                              alignment: Alignment.topRight,
                              child: ScaleTransition(
                                scale: _logoScaleAnimation,
                                child: Image.asset(
                                  'assets/images/general_logo.png',
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Header
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
                                  'Join the Livinkey community today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Full Name Field
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

                            // Email Field
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

                            // Nationality Dropdown
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
                              child: DropdownButtonFormField<String>(
                                value: _selectedNationality,
                                dropdownColor: kLivinkeyBlack,
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
                                  HapticFeedback.selectionClick();
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

                            // Phone Field with Country Code
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Country Code Dropdown
                                Expanded(
                                  flex: 3,
                                  child: Container(
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
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedCountryCode,
                                      dropdownColor: kLivinkeyBlack,
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
                                        HapticFeedback.selectionClick();
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

                                // Phone Number Field
                                Expanded(
                                  flex: 7,
                                  child: Container(
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

                            // Password Field
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
                                  HapticFeedback.lightImpact();
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

                            // Confirm Password Field
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
                                  HapticFeedback.lightImpact();
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

                            // Password Hint
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

                            // Terms and Conditions Checkbox
                            Row(
                              children: [
                                Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      fillColor: WidgetStateProperty.resolveWith(
                                        (states) => kLivinkeyGreen,
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
                                      HapticFeedback.selectionClick();
                                    },
                                    activeColor: kLivinkeyGreen,
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
                                            color: kLivinkeyGreen.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            decorationColor:
                                                kLivinkeyGreen.withOpacity(0.3),
                                          ),
                                          recognizer: _termsRecognizer,
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: kLivinkeyGreen.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            decorationColor:
                                                kLivinkeyGreen.withOpacity(0.3),
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

                            // Sign Up Button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: _agreeToTerms
                                    ? const LinearGradient(
                                        colors: [
                                          kLivinkeyGreen,
                                          Color(0xFF4CAF50),
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          kLivinkeyWhite.withOpacity(0.1),
                                          kLivinkeyWhite.withOpacity(0.05),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _agreeToTerms
                                    ? [
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

                            // Back to Login Link
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
            color: kLivinkeyGreen.withOpacity(0.7),
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