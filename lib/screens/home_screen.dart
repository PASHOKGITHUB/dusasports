import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'plans_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex, [int categoryIndex])? onCategoryTap;
  const HomeScreen({super.key, this.onCategoryTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _activePage = 0;
  Timer? _carouselTimer;

  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Premium Badminton Courts',
      'subtitle': '4 tournament-grade wooden courts with shadow-free lighting',
      'imagePath': 'assets/courttwo.jpg',
      'tag': 'MOST POPULAR',
    },
    {
      'title': 'Strength & Cardio Gym',
      'subtitle': 'Heavy-duty Evost machines + CrossFit functional zone',
      'imagePath': 'assets/gym4.jpg',
      'tag': 'TRENDING',
    },
    {
      'title': '25m Swimming Pool',
      'subtitle': 'Filtered & supervised lap pool for all ages',
      'imagePath': 'assets/swimmingtwo.jpg',
      'tag': 'ALL AGES',
    },
    {
      'title': 'Aadukalam Health Café',
      'subtitle': 'Pre-order clean high-protein meals & recovery shakes',
      'imagePath': 'assets/cafetwo.jpeg',
      'tag': 'PRE-ORDER',
    },
    {
      'title': 'Recovery Zone — Steam & Ice',
      'subtitle': 'Sauna, steam baths & coach-supervised ice plunges',
      'imagePath': 'assets/steamone.jpg',
      'tag': 'RECOVERY',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Badminton', 'image': 'assets/courttwo.jpg', 'icon': Icons.sports_tennis},
    {'name': 'Gym', 'image': 'assets/gym.jpg', 'icon': Icons.fitness_center},
    {'name': 'Swimming', 'image': 'assets/swimming.jpg', 'icon': Icons.pool},
    {'name': 'Café', 'image': 'assets/cafetwo.jpeg', 'icon': Icons.restaurant},
    {'name': 'Recovery', 'image': 'assets/steamone.jpg', 'icon': Icons.hot_tub},
    {'name': 'Snooker', 'image': 'assets/pooltable.jpg', 'icon': Icons.sports},
  ];

  @override
  void initState() {
    super.initState();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_activePage + 1) % _carouselItems.length;
        _pageController.animateToPage(nextPage, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getUnsplashUrl(String categoryName) {
    switch (categoryName) {
      case 'Badminton':
        return 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=200';
      case 'Gym':
        return 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=200';
      case 'Swimming':
        return 'https://images.unsplash.com/photo-1519315901367-f34ff9154487?q=80&w=200';
      case 'Café':
        return 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200';
      case 'Recovery':
        return 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=200';
      case 'Snooker':
        return 'https://images.unsplash.com/photo-1544322492-23727f288b4b?q=80&w=200';
      case 'Table Tennis':
        return 'https://images.unsplash.com/photo-1534067783941-51c9c23eccfd?q=80&w=200';
      default:
        return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=200';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // 1. Hero Carousel
          _buildHeroCarousel(),
          const SizedBox(height: 20),

          // 2. Category Navigation (circular images)
          _buildCategoryNavigation(),
          const SizedBox(height: 24),

          // 3. Live Academy Stats
          _buildLiveStats(),
          const SizedBox(height: 24),

          // 4. Special Offers Banner
          _buildSpecialOfferBanner(),
          const SizedBox(height: 24),

          // 5. Trending Activities
          _buildTrendingActivities(),
          const SizedBox(height: 24),

          // 6. Women's Exclusive Timing
          _buildWomenExclusiveBanner(),
          const SizedBox(height: 24),

          // 7. Why Athletes Choose DUSA (Color Card Gradients)
          _buildWhyChooseDusa(),
          const SizedBox(height: 24),

          // 8. Upcoming Events / Tournaments
          _buildUpcomingEvents(),
          const SizedBox(height: 24),

          // 9. Featured Café Pre-orders (Unsplash Images)
          _buildFeaturedCafe(),
          const SizedBox(height: 24),

          // 10. Membership Call to Action
          _buildMembershipCTA(),
          const SizedBox(height: 24),

          // 11. Member Testimonials
          _buildTestimonials(),
          const SizedBox(height: 24),

          // 12. Blog Feed (Unsplash Images)
          _buildBlogSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // 1. HERO CAROUSEL
  // ══════════════════════════════════════════
  Widget _buildHeroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _activePage = page),
            itemCount: _carouselItems.length,
            itemBuilder: (context, index) {
              final item = _carouselItems[index];
              return GestureDetector(
                onTap: () => widget.onCategoryTap?.call(1, 0),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(item['imagePath']!, fit: BoxFit.cover, filterQuality: FilterQuality.high,
                      errorBuilder: (c, e, s) => Container(color: const Color(0xFF0F172A), child: const Icon(Icons.image, color: Colors.white24, size: 40)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4C00),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item['tag']!, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                          ),
                          const SizedBox(height: 8),
                          Text(item['title']!, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(item['subtitle']!, style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white.withOpacity(0.9), height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_carouselItems.length, (index) {
            final isActive = index == _activePage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: isActive ? 20 : 6,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFFF4C00) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 2. CATEGORY NAVIGATION
  // ══════════════════════════════════════════
  Widget _buildCategoryNavigation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Explore Facilities', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => widget.onCategoryTap?.call(1, index),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(cat['image'], fit: BoxFit.cover, filterQuality: FilterQuality.high,
                          errorBuilder: (c, e, s) => Image.network(
                            _getUnsplashUrl(cat['name']),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFFF4C00),
                              child: Icon(cat['icon'] as IconData, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(cat['name'], style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 3. LIVE ACADEMY STATS
  // ══════════════════════════════════════════
  Widget _buildLiveStats() {
    final stats = [
      {'icon': Icons.access_time_filled, 'value': '5 AM – 10 PM', 'label': 'Open Today', 'color': const Color(0xFF16A34A)},
      {'icon': Icons.people, 'value': '2,500+', 'label': 'Active Members', 'color': const Color(0xFF2563EB)},
      {'icon': Icons.sports_tennis, 'value': '4 Courts', 'label': 'Available Now', 'color': const Color(0xFFFF4C00)},
      {'icon': Icons.star, 'value': '4.8 ★', 'label': 'Google Rating', 'color': const Color(0xFFD97706)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: stats.map((s) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: s == stats.last ? 0 : 8),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20),
                    const SizedBox(height: 6),
                    Text(s['value'] as String, style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)), textAlign: TextAlign.center),
                    const SizedBox(height: 2),
                    Text(s['label'] as String, style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF64748B)), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 4. SPECIAL OFFER BANNER
  // ══════════════════════════════════════════
  Widget _buildSpecialOfferBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4C00), Color(0xFFFF6B2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFFFF4C00).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text('LIMITED OFFER', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 8),
                  Text('First Month GYM FREE!', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Sign up for any annual membership plan and get your first month of gym access absolutely free.',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.9), height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlansScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Text('View Plans →', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_offer, color: Colors.white, size: 36),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 5. TRENDING ACTIVITIES
  // ══════════════════════════════════════════
  Widget _buildTrendingActivities() {
    final trending = [
      {'title': 'Badminton Coaching', 'subtitle': 'Mon-Sat • 6-8 AM & 5-7 PM', 'members': '320+ enrolled', 'image': 'assets/court.jpg', 'tag': '🔥 Hot'},
      {'title': 'CrossFit HIIT', 'subtitle': 'Daily • 7 AM & 6 PM batches', 'members': '180+ members', 'image': 'assets/gym2.jpg', 'tag': '💪 Intense'},
      {'title': 'Swim Coaching', 'subtitle': 'Beginner to advanced levels', 'members': '150+ swimmers', 'image': 'assets/swimmingtwo.jpg', 'tag': '🏊 Fresh'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🔥 Trending at DUSA', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              GestureDetector(
                onTap: () => widget.onCategoryTap?.call(1, 0),
                child: Text('View All', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final item = trending[index];
              return GestureDetector(
                onTap: () => widget.onCategoryTap?.call(1, index),
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 105,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(item['image']!, fit: BoxFit.cover, filterQuality: FilterQuality.high,
                              errorBuilder: (c, e, s) => Container(color: const Color(0xFFE2E8F0)),
                            ),
                            Positioned(
                              top: 8, left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                                child: Text(item['tag']!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title']!, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text(item['subtitle']!, style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.group, size: 12, color: Color(0xFF16A34A)),
                                const SizedBox(width: 4),
                                Text(item['members']!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 6. WOMEN'S EXCLUSIVE BANNER
  // ══════════════════════════════════════════
  Widget _buildWomenExclusiveBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFDF2F8), const Color(0xFFFCE7F3).withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF9A8D4).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEC4899).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.female, color: Color(0xFFEC4899), size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Women's Exclusive Hours", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFBE185D))),
                  const SizedBox(height: 4),
                  Text('11:00 AM – 1:00 PM • Daily\nA safe, private space for women to train freely across all facilities.',
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF9D174D), height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 7. WHY ATHLETES CHOOSE DUSA (Premium Gradients & Rounded)
  // ══════════════════════════════════════════
  Widget _buildWhyChooseDusa() {
    final reasons = [
      {
        'icon': Icons.shield_outlined,
        'title': 'Safety First',
        'desc': 'CCTV monitored, certified trainers, first-aid ready',
        'startColor': const Color(0xFFFFF7ED),
        'borderColor': const Color(0xFFFFD8A8),
        'iconColor': const Color(0xFFFF4C00),
      },
      {
        'icon': Icons.workspace_premium,
        'title': 'Premium Equipment',
        'desc': 'Evost biomechanical machines, wooden courts',
        'startColor': const Color(0xFFEFF6FF),
        'borderColor': const Color(0xFFBFDBFE),
        'iconColor': const Color(0xFF2563EB),
      },
      {
        'icon': Icons.local_drink,
        'title': 'In-house Nutrition',
        'desc': 'Aadukalam Café — protein meals & recovery shakes',
        'startColor': const Color(0xFFF0FDF4),
        'borderColor': const Color(0xFFBBF7D0),
        'iconColor': const Color(0xFF16A34A),
      },
      {
        'icon': Icons.ac_unit,
        'title': 'Climate Controlled',
        'desc': 'AC snooker lounge, ventilated courts & gym',
        'startColor': const Color(0xFFF5F3FF),
        'borderColor': const Color(0xFFDDD6FE),
        'iconColor': const Color(0xFF7C3AED),
      },
      {
        'icon': Icons.face_retouching_natural,
        'title': 'AI Photo Finder',
        'desc': 'Find your tournament photos with face recognition',
        'startColor': const Color(0xFFFDF2F8),
        'borderColor': const Color(0xFFFBCFE8),
        'iconColor': const Color(0xFFEC4899),
      },
      {
        'icon': Icons.groups,
        'title': 'Vibrant Community',
        'desc': '2,500+ members, weekly leagues & socials',
        'startColor': const Color(0xFFFEF3C7),
        'borderColor': const Color(0xFFFDE68A),
        'iconColor': const Color(0xFFD97706),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Why Athletes Choose DUSA', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reasons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4),
            itemBuilder: (context, index) {
              final r = reasons[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      r['startColor'] as Color,
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: (r['borderColor'] as Color).withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(r['icon'] as IconData, color: const Color(0xFFFF4C00), size: 22),
                    const SizedBox(height: 6),
                    Text(r['title'] as String, style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(r['desc'] as String, style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF64748B), height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 8. UPCOMING EVENTS
  // ══════════════════════════════════════════
  Widget _buildUpcomingEvents() {
    final events = [
      {'title': 'Independence Badminton Cup 2026', 'date': 'Aug 15 – 18', 'prize': '₹50,000 Prize Pool', 'status': 'Registration Open', 'statusColor': const Color(0xFF16A34A)},
      {'title': 'Madurai Open Pickleball Blitz', 'date': 'Sep 05', 'prize': '₹20,000 Cash Prize', 'status': 'Coming Soon', 'statusColor': const Color(0xFFD97706)},
      {'title': 'DUSA Fitness Challenge', 'date': 'Sep 20 – 21', 'prize': 'Free 3-month membership', 'status': 'Teaser', 'statusColor': const Color(0xFF7C3AED)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🏆 Upcoming Events', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              GestureDetector(
                onTap: () => widget.onCategoryTap?.call(2), // Redirect to Play Screen Tab (2)
                child: Text('View All', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Tournament banner image
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/tournament.jpg', fit: BoxFit.cover, filterQuality: FilterQuality.high,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF0F172A)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.75), Colors.black.withOpacity(0.2)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFFF4C00), borderRadius: BorderRadius.circular(4)),
                        child: Text('SEASON 2026', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 10),
                      Text('Tournament Season', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Compete, win prizes & earn your rank', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.95), height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...events.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: () => widget.onCategoryTap?.call(2),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (e['statusColor'] as Color).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.emoji_events, color: e['statusColor'] as Color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['title'] as String, style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text('${e['date']} • ${e['prize']}', style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: (e['statusColor'] as Color).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text(e['status'] as String, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: e['statusColor'] as Color)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 9. FEATURED CAFÉ (Unsplash Images)
  // ══════════════════════════════════════════
  Widget _buildFeaturedCafe() {
    final cafeItems = [
      {
        'name': 'Whey Protein Shake',
        'price': '₹120',
        'tag': 'Protein',
        'image': 'https://images.unsplash.com/photo-1579758629938-03607ccdbaba?q=80&w=200',
      },
      {
        'name': 'Grilled Chicken Salad',
        'price': '₹160',
        'tag': 'Keto',
        'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200',
      },
      {
        'name': 'Berry Smoothie',
        'price': '₹95',
        'tag': 'Hydrate',
        'image': 'https://images.unsplash.com/photo-1502741224143-90386d7f8c82?q=80&w=200',
      },
      {
        'name': 'Oatmeal Power Bowl',
        'price': '₹85',
        'tag': 'Pre-work',
        'image': 'https://images.unsplash.com/photo-1517686469429-8bdb88b9f907?q=80&w=200',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🍽️ Aadukalam Café', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              GestureDetector(
                onTap: () => widget.onCategoryTap?.call(1, 3), // Navigate to Facilities tab, selected index 3 (Cafe)
                child: Text('Full Menu →', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Pre-order your post-workout recovery meal', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cafeItems.length,
            itemBuilder: (context, index) {
              final item = cafeItems[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => widget.onCategoryTap?.call(1, 3),
                  child: Container(
                    width: 145,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unsplash item image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item['image']!,
                            height: 85,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 85,
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.restaurant, color: Color(0xFFFF4C00)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['name']!,
                          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['price']!,
                              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4C00).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['tag']!,
                                style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 10. MEMBERSHIP CTA
  // ══════════════════════════════════════════
  Widget _buildMembershipCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlansScreen())),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network('https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600', fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: const Color(0xFF0F172A)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.3)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFFF4C00), borderRadius: BorderRadius.circular(4)),
                      child: Text('MEMBERSHIP', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 8),
                    Text('Become a DUSA Member', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Plans from ₹30,000/yr • Gym + Pool + Courts + Recovery', style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.85))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFFF4C00), borderRadius: BorderRadius.circular(8)),
                      child: Text('Explore Plans →', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 11. TESTIMONIALS
  // ══════════════════════════════════════════
  Widget _buildTestimonials() {
    final testimonials = [
      {'name': 'Karthik R.', 'role': 'Platinum Member', 'text': 'DUSA completely transformed my fitness routine. The courts are world-class and the trainers genuinely care about your progress.', 'rating': 5},
      {'name': 'Priya M.', 'role': 'Gold Member', 'text': "The women's exclusive hours make me feel so comfortable. I've been a member for 8 months and the gym equipment is top-notch!", 'rating': 5},
      {'name': 'Arjun S.', 'role': 'Family Plan', 'text': 'My kids love the swimming coaching and I use the gym daily. The Aadukalam Café protein shakes are the best post-workout fuel.', 'rating': 4},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('💬 What Members Say', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return Container(
                width: 270,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '"${t['text']}"',
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF475569), height: 1.35, fontStyle: FontStyle.italic),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['name'] as String, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            Text(t['role'] as String, style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFFFF4C00), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: List.generate(t['rating'] as int, (_) => const Icon(Icons.star, size: 12, color: Color(0xFFD97706))),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  // 12. BLOG FEED (Unsplash Images)
  // ══════════════════════════════════════════
  Widget _buildBlogSection() {
    final blogs = [
      {
        'category': 'Development',
        'title': 'Benefits of Badminton for Kids',
        'readTime': '8 min read',
        'desc': 'How badminton training improves coordination and concentration in children.',
        'image': 'https://images.unsplash.com/photo-1544698310-74ea9d1c8258?q=80&w=600&auto=format&fit=crop',
      },
      {
        'category': 'Fitness',
        'title': 'How Fitness Boosts Grades',
        'readTime': '10 min read',
        'desc': 'The science linking exercise to improved cognitive performance.',
        'image': 'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?q=80&w=600&auto=format&fit=crop',
      },
      {
        'category': 'Recovery',
        'title': 'Ice Baths: Science Behind It',
        'readTime': '6 min read',
        'desc': 'Why cold plunges accelerate muscle repair and reduce inflammation.',
        'image': 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?q=80&w=600&auto=format&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('📖 Latest from Blog', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => widget.onCategoryTap?.call(2), // Redirect to Play Screen Tab (2)
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unsplash blog cover image
                        Image.network(
                          blog['image']!,
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 90,
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(Icons.book, color: Color(0xFFFF4C00)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF4C00).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      blog['category']!,
                                      style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                                    ),
                                  ),
                                  Text(
                                    blog['readTime']!,
                                    style: GoogleFonts.inter(fontSize: 8.5, color: const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                blog['title']!,
                                style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
