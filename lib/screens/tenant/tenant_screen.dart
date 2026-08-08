// lib/screens/tenant/tenant_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'home_screen.dart';
import 'payments_screen.dart';
import 'maintenance_screen.dart';
import 'documents_screen.dart';
import 'profile_screen.dart';
import 'tenant_drawer.dart';

class TenantScreen extends StatefulWidget {
  const TenantScreen({super.key});

  @override
  TenantScreenState createState() => TenantScreenState();
}

class TenantScreenState extends State<TenantScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _screens = [
    HomeScreen(),
    PaymentsScreen(),
    MaintenanceScreen(),
    DocumentsScreen(),
    ProfileScreen(),
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

  // Getter for selected index (used by child screens)
  int get selectedIndex => _selectedIndex;

  // Method to navigate to a specific tab (used by child screens)
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

  // Method to open drawer (used by child screens)
  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Helper methods for floating tabs
  IconData _getIcon(int index) {
    const icons = [
      Icons.home_rounded,
      Icons.payment_rounded,
      Icons.build_rounded,
      Icons.folder_rounded,
      Icons.person_rounded,
    ];
    return icons[index];
  }

  String _getLabel(int index) {
    const labels = ['Home', 'Payments', 'Maintenance', 'Documents', 'Profile'];
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              // Wrapping the label in a FittedBox lets it auto-scale down to
              // fit the tab's available width instead of clipping/wrapping
              // for longer words like "Maintenance", while short labels
              // like "Home" keep rendering at full size.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isSelected ? kLivinkeyGreen : Colors.white.withOpacity(0.38),
                    fontSize: isSelected ? 11 : 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
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
      drawer: const TenantDrawer(),
      extendBody: true,
      body: TenantScreenProvider(
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
class TenantScreenProvider extends InheritedWidget {
  final VoidCallback openDrawer;
  final Function(int) navigateToTab;

  const TenantScreenProvider({
    super.key,
    required this.openDrawer,
    required this.navigateToTab,
    required super.child,
  });

  static TenantScreenProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TenantScreenProvider>();
  }

  @override
  bool updateShouldNotify(TenantScreenProvider oldWidget) {
    return openDrawer != oldWidget.openDrawer ||
        navigateToTab != oldWidget.navigateToTab;
  }
}