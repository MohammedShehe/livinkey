import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/tenant/stat_card.dart';
import '../../widgets/tenant/quick_action.dart';
import 'tenant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: kFadeDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    // Find the TenantScreenState and navigate
    final state = context.findAncestorStateOfType<TenantScreenState>();
    state?.navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    const tenantName = 'John Doe';

    return Scaffold(
      backgroundColor: kLivinkeyBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Row(
          children: [
            Image.asset(kGeneralLogo, height: 28, width: 28),
            const SizedBox(width: 10),
            const Text(
              'Livinkey',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kLivinkeyGreen.withOpacity(0.2),
                  kLivinkeyGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: kLivinkeyGreen.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.circle, color: kLivinkeyGreen, size: 8),
                  SizedBox(width: 6),
                  Text(
                    'Tenant',
                    style: TextStyle(
                      color: kLivinkeyGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Greeting
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good ${getTimeOfDay()}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tenantName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kLivinkeyGreen, Color(0xFF66BB6A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        getInitials(tenantName),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  StatCard(
                    icon: Icons.warning_rounded,
                    title: 'Rent Status',
                    value: 'Unpaid',
                    subtitle: 'Due in 3 days',
                    color: Colors.red,
                    onTap: () => _navigateToTab(1),
                  ),
                  StatCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Upcoming Payment',
                    value: '14 Aug, 2026',
                    subtitle: '3 days left',
                    color: Colors.orange,
                    onTap: () => _navigateToTab(1),
                  ),
                  StatCard(
                    icon: Icons.build_rounded,
                    title: 'Maintenance',
                    value: '5 Req',
                    subtitle: '2 in progress',
                    color: Colors.blue,
                    onTap: () => _navigateToTab(2),
                  ),
                  StatCard(
                    icon: Icons.receipt_rounded,
                    title: 'Bills',
                    value: '₹12,500',
                    subtitle: 'This month',
                    color: kLivinkeyGreen,
                    onTap: () => _navigateToTab(1),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions Section
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: QuickAction(
                      icon: Icons.payment_rounded,
                      label: 'Pay Rent',
                      color: kLivinkeyGreen,
                      onTap: () => _navigateToTab(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickAction(
                      icon: Icons.build_rounded,
                      label: 'Request Maintenance',
                      color: Colors.blue,
                      onTap: () => _navigateToTab(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickAction(
                      icon: Icons.folder_rounded,
                      label: 'View Documents',
                      color: Colors.orange,
                      onTap: () => _navigateToTab(3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}