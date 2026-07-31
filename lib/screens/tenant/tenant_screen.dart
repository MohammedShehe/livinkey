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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('tenant_scaffold'),
      backgroundColor: kLivinkeyBlack,
      drawer: const TenantDrawer(),
      body: Column(
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            navigateToTab(index);
          },
          backgroundColor: kLivinkeyBlack,
          selectedItemColor: kLivinkeyGreen,
          unselectedItemColor: Colors.white.withOpacity(0.4),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment_rounded),
              label: 'Payments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_rounded),
              label: 'Maintenance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_rounded),
              label: 'Documents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}