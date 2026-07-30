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

  static const List<Widget> _screens = [
    HomeScreen(),
    PaymentsScreen(),
    MaintenanceScreen(),
    DocumentsScreen(),
    ProfileScreen(),
  ];

  // Getter for selected index (used by child screens)
  int get selectedIndex => _selectedIndex;

  // Method to navigate to a specific tab (used by child screens)
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('tenant_scaffold'),
      backgroundColor: kLivinkeyBlack,
      drawer: const TenantDrawer(),
      body: _screens[_selectedIndex],
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