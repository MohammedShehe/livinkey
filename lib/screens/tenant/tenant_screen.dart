// lib/screens/tenant/tenant_screen.dart
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [kLivinkeyGreen, Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kLivinkeyGreen.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: kLivinkeyGreen.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(4),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.black : Colors.white.withOpacity(0.4),
                  size: isSelected ? 24 : 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white.withOpacity(0.4),
                  fontSize: isSelected ? 10 : 9,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
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
      body: TenantScreenProvider(
        openDrawer: openDrawer,
        navigateToTab: navigateToTab,
        child: Column(
          children: [
            // 1. Top Progress Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _selectedIndex / (_screens.length - 1),
                        backgroundColor: Colors.white.withOpacity(0.05),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          kLivinkeyGreen,
                        ),
                        minHeight: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${((_selectedIndex / (_screens.length - 1)) * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. Page Indicator Dots
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _screens.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _selectedIndex == index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _selectedIndex == index
                          ? kLivinkeyGreen
                          : Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
              ),
            ),
            
            // 3. Main PageView
            Expanded(
              child: PageView(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, -5),
            ),
            BoxShadow(
              color: kLivinkeyGreen.withOpacity(0.1),
              blurRadius: 30,
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