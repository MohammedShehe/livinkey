// lib/screens/guest/guest_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../widgets/guest/pg_card.dart';
import '../../widgets/guest/pg_detail_modal.dart';
import '../../models/pg_model.dart';

class GuestSearchScreen extends StatefulWidget {
  const GuestSearchScreen({super.key});

  @override
  State<GuestSearchScreen> createState() => _GuestSearchScreenState();
}

class _GuestSearchScreenState extends State<GuestSearchScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true; // 🔥 Keep state alive

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample PG Data (same as home)
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
      description: 'Green Valley PG offers comfortable living spaces with modern amenities.',
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
      description: 'Royal PG offers premium accommodation with world-class amenities.',
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

  List<PgModel> get _searchResults {
    if (_searchQuery.isEmpty) return _allPgs;
    
    final query = _searchQuery.toLowerCase();
    return _allPgs.where((pg) {
      return pg.name.toLowerCase().contains(query) ||
          pg.location.toLowerCase().contains(query) ||
          pg.status.toLowerCase().contains(query) ||
          pg.rent.toString().contains(query) ||
          pg.amenities.any((a) => a.toLowerCase().contains(query)) ||
          pg.comments.any((c) => c.text.toLowerCase().contains(query));
    }).toList();
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
    _searchController.dispose();
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
    super.build(context); // 🔥 Must call super.build
    
    return Scaffold(
      backgroundColor: kLivinkeyBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Search PGs'),
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
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by name, location, rent, amenities...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: kLivinkeyGreen.withOpacity(0.7),
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white.withOpacity(0.4),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: kLivinkeyGreen.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${_searchResults.length} PG${_searchResults.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Results Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: Colors.white.withOpacity(0.1),
                              size: 64,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No PGs found',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try adjusting your search',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.2),
                                fontSize: 13,
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
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return PgCard(
                            pg: _searchResults[index],
                            onTap: () => _showPgDetail(_searchResults[index]),
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
}