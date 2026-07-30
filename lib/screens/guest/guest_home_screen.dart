// lib/screens/guest/guest_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/guest/pg_card.dart';
import '../../widgets/guest/pg_detail_modal.dart';
import '../../models/pg_model.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _selectedFilter = 'All';
  final String guestName = 'Guest User';

  // Sample PG Data
  final List<PgModel> _allPgs = [
    PgModel(
      id: '1',
      name: 'Green Valley PG',
      location: 'Near LPU, Phagwara',
      rating: 4.8,
      totalRooms: 20,
      availableRooms: 5,
      rent: 8500,
      status: 'Vacant',
      imageUrl: 'assets/images/pg1.jpg',
      amenities: ['Wi-Fi', 'AC', 'Parking', 'Security', 'Laundry', 'Gym'],
      comments: [
        UserComment('Rahul K.', 'Great place! Very clean and affordable.'),
        UserComment('Priya S.', 'Good food and friendly staff.'),
        UserComment('Amit R.', 'Nice location, close to university.'),
      ],
      description: 'Green Valley PG offers comfortable living spaces with modern amenities. Located near LPU, it\'s perfect for students and professionals.',
    ),
    PgModel(
      id: '2',
      name: 'Sunshine PG',
      location: 'Near Lovely Professional University',
      rating: 4.6,
      totalRooms: 15,
      availableRooms: 0,
      rent: 7500,
      status: 'Full Occupied',
      imageUrl: 'assets/images/pg2.jpg',
      amenities: ['Wi-Fi', 'AC', 'Parking', 'Security', 'Food'],
      comments: [
        UserComment('Sneha M.', 'Good food and comfortable rooms.'),
        UserComment('Vikram S.', 'Affordable rent, nice place.'),
      ],
      description: 'Sunshine PG provides quality accommodation with delicious home-cooked meals.',
    ),
    PgModel(
      id: '3',
      name: 'Royal PG',
      location: 'Phagwara, Punjab',
      rating: 4.9,
      totalRooms: 25,
      availableRooms: 8,
      rent: 9500,
      status: 'Vacant',
      imageUrl: 'assets/images/pg3.jpg',
      amenities: ['Wi-Fi', 'AC', 'Parking', 'Security', 'Laundry', 'Gym', 'Swimming Pool'],
      comments: [
        UserComment('Arjun P.', 'Best PG in town! Highly recommended.'),
        UserComment('Neha G.', 'Amazing amenities and service.'),
        UserComment('Rohit K.', 'Great place for students.'),
      ],
      description: 'Royal PG offers premium accommodation with world-class amenities including a swimming pool.',
    ),
    PgModel(
      id: '4',
      name: 'Cozy Nest PG',
      location: 'Near LPU Gate 1',
      rating: 4.3,
      totalRooms: 12,
      availableRooms: 2,
      rent: 6800,
      status: 'Vacant',
      imageUrl: 'assets/images/pg4.jpg',
      amenities: ['Wi-Fi', 'Parking', 'Security', 'Food'],
      comments: [
        UserComment('Deepak K.', 'Budget-friendly PG with good facilities.'),
      ],
      description: 'Cozy Nest PG provides affordable accommodation with all essential amenities.',
    ),
    PgModel(
      id: '5',
      name: 'Elite PG',
      location: 'Phagwara City Center',
      rating: 4.7,
      totalRooms: 30,
      availableRooms: 0,
      rent: 10000,
      status: 'Full Occupied',
      imageUrl: 'assets/images/pg5.jpg',
      amenities: ['Wi-Fi', 'AC', 'Parking', 'Security', 'Laundry', 'Gym', 'Swimming Pool', 'Restaurant'],
      comments: [
        UserComment('Ananya R.', 'Luxury living at affordable prices.'),
        UserComment('Karan S.', 'Excellent facilities and service.'),
        UserComment('Meera D.', 'Best PG in Phagwara!'),
      ],
      description: 'Elite PG offers luxury accommodation with premium amenities.',
    ),
  ];

  List<PgModel> get _filteredPgs {
    List<PgModel> filtered = List.from(_allPgs);
    
    // Sort: Vacant first
    filtered.sort((a, b) {
      if (a.status == 'Vacant' && b.status != 'Vacant') return -1;
      if (a.status != 'Vacant' && b.status == 'Vacant') return 1;
      return 0;
    });

    // Apply filter
    if (_selectedFilter == 'Vacant') {
      filtered = filtered.where((pg) => pg.status == 'Vacant').toList();
    } else if (_selectedFilter == 'Full Occupied') {
      filtered = filtered.where((pg) => pg.status == 'Full Occupied').toList();
    }
    
    return filtered;
  }

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

  void _showPgDetail(PgModel pg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PgDetailModal(pg: pg),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const Color(0xFFFF9800).withOpacity(0.2),
                  const Color(0xFFFF9800).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF9800).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFFFF9800), size: 8),
                  SizedBox(width: 6),
                  Text(
                    'Guest',
                    style: TextStyle(
                      color: Color(0xFFFF9800),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${getTimeOfDay()}!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    guestName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Welcome Message
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kLivinkeyGreen.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kLivinkeyGreen.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: kLivinkeyGreen.withOpacity(0.7),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Explore our PGs and find your perfect home! 🏠',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Vacant'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Full Occupied'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // PG Cards Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _filteredPgs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_work_rounded,
                              color: Colors.white.withOpacity(0.1),
                              size: 64,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No PGs available',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: _filteredPgs.length,
                        itemBuilder: (context, index) {
                          return PgCard(
                            pg: _filteredPgs[index],
                            onTap: () => _showPgDetail(_filteredPgs[index]),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
        HapticFeedback.selectionClick();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [kLivinkeyGreen, Color(0xFF66BB6A)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? kLivinkeyGreen
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}