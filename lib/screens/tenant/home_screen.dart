// lib/screens/tenant/home_screen.dart
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

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true; // 🔥 Keep state alive

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
    final state = context.findAncestorStateOfType<TenantScreenState>();
    state?.navigateToTab(index);
  }

  double _getLogoSize(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      return 80.0;
    } else if (screenWidth >= 400) {
      return 40.0;
    } else {
      return 32.0;
    }
  }

  Future<bool> _onWillPop() async {
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
    super.build(context); // 🔥 Must call super.build
    
    const tenantName = 'John Doe';
    const pgName = 'Green Valley PG';
    const roomNumber = 'Room 204';
    
    final double logoSize = _getLogoSize(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kLivinkeyBlack,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Image.asset(
            kGeneralLogo,
            height: logoSize,
            width: logoSize,
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
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.home_rounded,
                                color: kLivinkeyGreen.withOpacity(0.7),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pgName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.meeting_room_rounded,
                                color: kLivinkeyGreen.withOpacity(0.7),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                roomNumber,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 3 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: MediaQuery.of(context).size.width >= 600 ? 1.1 : 1.0,
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
      ),
    );
  }
}