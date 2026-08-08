// lib/screens/guest/guest_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'guest_home_screen.dart';
import 'guest_search_screen.dart';
import 'guest_profile_screen.dart';
import '../../widgets/guest/guest_drawer.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => GuestScreenState();
}

class GuestScreenState extends State<GuestScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _screens = [
    GuestHomeScreen(),
    GuestSearchScreen(),
    GuestProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToTab(int index) {
    if (_selectedIndex != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
    HapticFeedback.lightImpact();
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Helper methods for floating tabs
  IconData _getIcon(int index) {
    const icons = [
      Icons.home_rounded,
      Icons.search_rounded,
      Icons.person_rounded,
    ];
    return icons[index];
  }

  String _getLabel(int index) {
    const labels = ['Home', 'Search', 'Profile'];
    return labels[index];
  }

  Widget _buildFloatingTab({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  icon,
                  key: ValueKey('$icon-$isSelected'),
                  color: isSelected ? kLivinkeyGreen : Colors.white.withOpacity(0.38),
                  size: isSelected ? 26 : 22,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isSelected ? kLivinkeyGreen : Colors.white.withOpacity(0.38),
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kLivinkeyBlack,
      drawer: const GuestDrawer(),
      extendBody: true,
      body: GuestScreenProvider(
        openDrawer: openDrawer,
        navigateToTab: navigateToTab,
        child: Stack(
          children: [
            // Ambient background glow for depth
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      kLivinkeyGreen.withOpacity(0.16),
                      kLivinkeyGreen.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      kLivinkeyGreen.withOpacity(0.10),
                      kLivinkeyGreen.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Main PageView
            PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _screens,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 30,
                    offset: const Offset(0, -6),
                  ),
                  BoxShadow(
                    color: kLivinkeyGreen.withOpacity(0.12),
                    blurRadius: 32,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_screens.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return _buildFloatingTab(
                    icon: _getIcon(index),
                    label: _getLabel(index),
                    isSelected: isSelected,
                    onTap: () => navigateToTab(index),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// InheritedWidget to pass functions to child screens
class GuestScreenProvider extends InheritedWidget {
  final VoidCallback openDrawer;
  final Function(int) navigateToTab;

  const GuestScreenProvider({
    super.key,
    required this.openDrawer,
    required this.navigateToTab,
    required super.child,
  });

  static GuestScreenProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GuestScreenProvider>();
  }

  @override
  bool updateShouldNotify(GuestScreenProvider oldWidget) {
    return openDrawer != oldWidget.openDrawer ||
        navigateToTab != oldWidget.navigateToTab;
  }
}