import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';
import '../widgets/enquiry_dialog.dart';
import '../widgets/checkout_payment_dialog.dart';

class FacilitiesHubScreen extends StatefulWidget {
  const FacilitiesHubScreen({super.key});

  @override
  State<FacilitiesHubScreen> createState() => _FacilitiesHubScreenState();
}

class _FacilitiesHubScreenState extends State<FacilitiesHubScreen> {
  String _selectedPickupTime = 'In 15 Mins';
  String _cafeSearchQuery = '';

  final List<Map<String, String>> _categories = [
    {
      'name': 'Badminton',
      'image': 'assets/courttwo.jpg',
    },
    {
      'name': 'Gym',
      'image': 'assets/gym.jpg',
    },
    {
      'name': 'Swimming',
      'image': 'assets/swimming.jpg',
    },
    {
      'name': 'Café',
      'image': 'assets/cafetwo.jpeg',
    },
    {
      'name': 'Recovery',
      'image': 'assets/steamone.jpg',
    },
    {
      'name': 'Snooker',
      'image': 'assets/pooltable.jpg',
    },
    {
      'name': 'Table Tennis',
      'image': 'assets/courttwo.jpg',
    },
  ];

  final List<String> _timeSlots = [
    '06:00 AM - 07:00 AM',
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '11:00 AM - 12:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
    '08:00 PM - 09:00 PM',
  ];

  final Set<String> _simulatedBookedSlots = {
    'Court 1_06:00 AM - 07:00 AM',
    'Court 2_08:00 AM - 09:00 AM',
    'Court 3_07:00 AM - 08:00 AM',
    'Court 4_06:00 AM - 07:00 AM',
    'Court 1_05:00 PM - 06:00 PM',
    'Court 3_06:00 PM - 07:00 PM',
  };

  final List<Map<String, dynamic>> _cafeMenu = [
    {'name': 'Whey Protein Shake (Choco)', 'price': 120, 'desc': '24g Protein • Post-workout recovery', 'tag': 'High Protein', 'image': 'https://images.unsplash.com/photo-1577805947697-89e18249d767?q=80&w=200'},
    {'name': 'Berry Hydration Smoothie', 'price': 95, 'desc': 'Antioxidants • Electrolytes', 'tag': 'Hydration', 'image': 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=200'},
    {'name': 'Grilled Chicken Salad', 'price': 160, 'desc': 'Lean chicken • Fresh greens', 'tag': 'Keto Friendly', 'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=200'},
    {'name': 'Hard Boiled Eggs (3 eggs)', 'price': 40, 'desc': 'Classic clean protein snack', 'tag': 'Quick Snack', 'image': 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?q=80&w=200'},
    {'name': 'Fruit & Nut Oatmeal Bowl', 'price': 85, 'desc': 'Slow digesting carbs', 'tag': 'Pre-workout', 'image': 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?q=80&w=200'},
    {'name': 'Avocado Toast with Egg', 'price': 130, 'desc': 'Healthy fats • Whole wheat toast', 'tag': 'Energy Boost', 'image': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=200'},
    {'name': 'Peanut Butter Banana Toast', 'price': 90, 'desc': 'Rich protein spread • Potassium', 'tag': 'Snack', 'image': 'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?q=80&w=200'},
    {'name': 'Green Detox Juice', 'price': 80, 'desc': 'Spinach, kale, apple, cucumber', 'tag': 'Healthy Juices', 'image': 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?q=80&w=200'},
    {'name': 'BCAA Recovery Fizz', 'price': 110, 'desc': 'Intra-workout muscle recovery', 'tag': 'Recovery', 'image': 'https://images.unsplash.com/photo-1622484210800-8855b17490bb?q=80&w=200'},
  ];

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
      default:
        return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=200';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    final _selectedCategoryIndex = provider.selectedFacilityTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Swiggy-Style Category Selector (Circular Clipped Images)
        Container(
          height: 96,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = index == _selectedCategoryIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 18),
                child: GestureDetector(
                  onTap: () {
                    provider.setFacilityTab(index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular Image Container
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFFF4C00).withOpacity(0.15),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          cat['image']!,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            _getUnsplashUrl(cat['name']!),
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: const Color(0xFFFF4C00),
                              child: const Icon(Icons.sports, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name']!,
                        style: GoogleFonts.outfit(
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Content Area
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: _buildFacilityContent(provider),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityContent(BookingProvider provider) {
    final selectedCategoryIndex = provider.selectedFacilityTab;
    switch (selectedCategoryIndex) {
      case 0:
        return _buildBadmintonSection(provider);
      case 1:
        return _buildGymSection(provider);
      case 2:
        return _buildSwimmingSection(provider);
      case 3:
        return _buildCafeSection(provider);
      case 4:
        return _buildRecoverySection(provider);
      case 5:
        return _buildSnookerSection(provider);
      case 6:
        return _buildTableTennisSection(provider);
      default:
        return Container();
    }
  }

  // --- 1. Badminton Section ---
  Widget _buildBadmintonSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'Badminton Courts',
          subtitle: '4 World-class Wooden Courts',
          desc: 'Engineered for perfect stability, speed, and knee protection. Features eye-friendly shadow-free lighting. Ideal for coaching, matches, and leisure play.',
          imagePath: 'assets/courttwo.jpg',
          accentColor: const Color(0xFFFF4C00),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Badminton Court Booking Grid',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Select up to 3 slots. Soft orange indicates your choices.',
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        
        // Legend
        Row(
          children: [
            _buildLegendItem('Booked', const Color(0xFFFFF0F0), border: const Color(0xFFEF4444)),
            const SizedBox(width: 12),
            _buildLegendItem('Available', Colors.white, border: const Color(0xFFE2E8F0)),
            const SizedBox(width: 12),
            _buildLegendItem('Selected', const Color(0xFFFFF1EB), border: const Color(0xFFFF4C00)),
          ],
        ),
        const SizedBox(height: 14),

        // Grid Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(110),
              border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 1),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                  children: [
                    _buildGridHeader('Time Slot'),
                    _buildGridHeader('Court 1'),
                    _buildGridHeader('Court 2'),
                    _buildGridHeader('Court 3'),
                    _buildGridHeader('Court 4'),
                  ],
                ),
                ..._timeSlots.map((time) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Text(
                          time.split(' - ')[0],
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildCourtCell(1, time, provider),
                      _buildCourtCell(2, time, provider),
                      _buildCourtCell(3, time, provider),
                      _buildCourtCell(4, time, provider),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        if (provider.selectedCourtSlots.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4C00).withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Slots for Booking:',
                  style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                ),
                const SizedBox(height: 4),
                ...provider.selectedCourtSlots.map((slot) => Text(
                  '• $slot',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A)),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        ShadButton(
          backgroundColor: const Color(0xFFFF4C00),
          hoverBackgroundColor: const Color(0xFFE04300),
          onPressed: () {
            if (provider.selectedCourtSlots.isEmpty) {
              ShadToaster.of(context).show(
                const ShadToast(
                  title: Text('No Slots Selected'),
                  description: Text('Please select at least one time slot by tapping the court grid above!'),
                ),
              );
              return;
            }
            provider.setPlan('Badminton Court Booking');
            _showCheckout(
              planName: 'Badminton Court Booking',
              duration: '${provider.selectedCourtSlots.length} Court Slot${provider.selectedCourtSlots.length > 1 ? "s" : ""}',
              basePrice: provider.selectedCourtSlots.length * 400,
              benefits: const [
                'Guaranteed wooden court reservation',
                'Complimentary badminton racquets',
                'Sauna, locker, and shower facilities included',
              ],
            );
          },
          child: Text(
            'Book Selected Slots',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // --- 2. Gym Section ---
  Widget _buildGymSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'DUSA Strength Gym',
          subtitle: 'Cardio & Crossfit Floor',
          desc: 'High-end lifting deck with heavy Evost biomechanical machines, functional workout zones, and certified personal trainer plans.',
          imagePath: 'assets/gym.jpg',
          accentColor: const Color(0xFF2563EB),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Gym Membership Packages',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        _buildPackageCard(
          title: '1 Month Membership',
          price: '₹3,000',
          desc: 'Full floor access, changing rooms, showers & lockers.',
          onTap: () {
            provider.setPlan('Gym Package', subPlan: '1 Month');
            _showCheckout(
              planName: 'Gym Package',
              duration: '1 Month',
              basePrice: 3000,
              benefits: [
                'Full strength & cardio floor access',
                'General trainer assistance',
                'Showers & locker facility access',
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: '3 Months Membership',
          price: '₹5,999',
          desc: 'Standard quarterly access. Includes fitness metrics consultation.',
          onTap: () {
            provider.setPlan('Gym Package', subPlan: '3 Months');
            _showCheckout(
              planName: 'Gym Package',
              duration: '3 Months',
              basePrice: 5999,
              benefits: [
                'Full strength & cardio floor access',
                'Standard fitness evaluation',
                'Showers & locker facility access',
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: '6 Months Membership',
          price: '₹9,999',
          desc: 'Mid-term pass. Includes customized trainer advice cards.',
          onTap: () {
            provider.setPlan('Gym Package', subPlan: '6 Months');
            _showCheckout(
              planName: 'Gym Package',
              duration: '6 Months',
              basePrice: 9999,
              benefits: [
                'Full strength & cardio floor access',
                'Personalized fitness goals chart',
                'Showers, locker & steam room access',
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: 'Annual Gym Pass',
          price: '₹15,999',
          desc: 'Best Value! Full yearly floor access with locker perks.',
          onTap: () {
            provider.setPlan('Gym Package', subPlan: '1 Year');
            _showCheckout(
              planName: 'Gym Package',
              duration: '1 Year',
              basePrice: 15999,
              benefits: [
                'Unlimited gym floor access',
                'Personalized trainer goal advice',
                'Priority locker perks & steam bath access',
              ],
            );
          },
        ),
      ],
    );
  }

  // --- 3. Swimming Section ---
  Widget _buildSwimmingSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'Swimming Pool',
          subtitle: 'Filtered Olympic Lap Pool',
          desc: 'Sanitized 25-meter lap lanes supervised by certified swim trainers. Safe for kids, beginners, and adult master workouts.',
          imagePath: 'assets/swimming.jpg',
          accentColor: const Color(0xFF16A34A),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Swim Coaching & Access',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        _buildPackageCard(
          title: 'Monthly Coaching Batch',
          price: '₹2,500',
          desc: '3 weekly coaching batches. Perfect for stroke correction and water stamina.',
          onTap: () {
            provider.setPlan('Swimming Coaching', subPlan: '1 Month');
            _showEnquiry();
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: 'Annual Swim Pass',
          price: '₹10,000',
          desc: 'General lap access during daily swimming hours (5 AM - 10 PM).',
          onTap: () {
            provider.setPlan('Swimming Membership', subPlan: '1 Year');
            _showEnquiry();
          },
        ),
      ],
    );
  }

  // --- 4. Café Section (Swiggy Stepper ADD Interface with Search & Top Cart Tracker!) ---
  Widget _buildCafeSection(BookingProvider provider) {
    // Filtered menu based on search query
    final filteredMenu = _cafeMenu.where((item) {
      if (_cafeSearchQuery.isEmpty) return true;
      final q = _cafeSearchQuery.toLowerCase();
      final name = (item['name'] as String).toLowerCase();
      final desc = (item['desc'] as String).toLowerCase();
      final tag = (item['tag'] as String).toLowerCase();
      return name.contains(q) || desc.contains(q) || tag.contains(q);
    }).toList();

    final totalCartItems = provider.cafeCart.values.fold(0, (sum, count) => sum + count);
    final totalCartPrice = provider.cafeCart.entries.fold(0, (sum, entry) => sum + (entry.value * (_cafeMenu.firstWhere((m) => m['name'] == entry.key)['price'] as int)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'Aadukalam Health Café',
          subtitle: 'Pre-order Healthy Athlete Nutrition',
          desc: 'Whey shakes, grilled proteins, and recovery juice smoothies crafted for post-workout restoration. Order now to pick up right after training!',
          imagePath: 'assets/cafetwo.jpeg',
          accentColor: const Color(0xFFD97706),
        ),
        const SizedBox(height: 16),

        // TOP CART TRACKER BANNER (Always visible at top of Cafe section)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: totalCartItems > 0 ? const Color(0xFFFF4C00) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (totalCartItems > 0 ? const Color(0xFFFF4C00) : Colors.black).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalCartItems > 0 ? '$totalCartItems Items in Cart' : 'Cart is Empty',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        totalCartItems > 0 ? 'Total: ₹$totalCartPrice • Scheduled Pickup' : 'Select dishes below to add to cart',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ],
              ),
              if (totalCartItems > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹$totalCartPrice',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // SEARCH BAR FOR AADUKALAM CAFÉ DISHES
        TextFormField(
          cursorColor: const Color(0xFFFF4C00),
          onChanged: (val) {
            setState(() {
              _cafeSearchQuery = val.trim();
            });
          },
          style: GoogleFonts.inter(fontSize: 13.5, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search protein shakes, smoothies, salads...',
            hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFFFF4C00)),
            suffixIcon: _cafeSearchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                    onPressed: () {
                      setState(() {
                        _cafeSearchQuery = '';
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF4C00), width: 1.5)),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Menu - Fresh Recovery Meals (${filteredMenu.length})',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        // Menu Items List (Filtered)
        if (filteredMenu.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF94A3B8)),
                const SizedBox(height: 8),
                Text(
                  'No cafe items found for "$_cafeSearchQuery"',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredMenu.length,
            itemBuilder: (context, index) {
              final item = filteredMenu[index];
              final String name = item['name'];
              final int count = provider.cafeCart[name] ?? 0;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Dish Image Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'] ?? '',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 64,
                          height: 64,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(Icons.fastfood_rounded, color: Color(0xFFFF4C00), size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4C00).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['tag'],
                                  style: GoogleFonts.inter(fontSize: 7.5, color: const Color(0xFFFF4C00), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['desc'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${item['price']}',
                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                          ),
                        ],
                      ),
                    ),
                    
                    // Swiggy Stepper ADD layout
                    Container(
                      width: 76,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.6)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4C00).withOpacity(0.05),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: count == 0
                          ? InkWell(
                              onTap: () => provider.addCafeItem(name),
                              child: Center(
                                child: Text(
                                  'ADD',
                                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => provider.removeCafeItem(name),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Icon(Icons.remove, size: 14, color: Color(0xFFFF4C00)),
                                  ),
                                ),
                                Text(
                                  '$count',
                                  style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                                ),
                                GestureDetector(
                                  onTap: () => provider.addCafeItem(name),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Icon(Icons.add, size: 14, color: Color(0xFFFF4C00)),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 16),

        // Preorder Drawer checkout
        if (provider.cafeCart.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pre-order Cart Summary',
                  style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                ),
                const Divider(color: Color(0xFFE2E8F0), height: 16),
                ...provider.cafeCart.entries.map((entry) {
                  final menuItem = _cafeMenu.firstWhere((m) => m['name'] == entry.key);
                  final itemTotal = menuItem['price'] * entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry.key} x${entry.value}',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                        ),
                        Text(
                          '₹$itemTotal',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(color: Color(0xFFE2E8F0), height: 16),
                
                // Pick time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ready Pickup Time:',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                    ),
                    DropdownButton<String>(
                      value: _selectedPickupTime,
                      dropdownColor: Colors.white,
                      underline: Container(),
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFFF4C00), fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPickupTime = val;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'In 15 Mins', child: Text('In 15 Mins')),
                        DropdownMenuItem(value: 'In 30 Mins', child: Text('In 30 Mins')),
                        DropdownMenuItem(value: 'In 45 Mins', child: Text('In 45 Mins')),
                        DropdownMenuItem(value: 'After Workout (1 Hr)', child: Text('After Workout (1 Hr)')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                    Text(
                      '₹${provider.cafeCart.entries.fold(0, (sum, entry) => sum + (entry.value * (_cafeMenu.firstWhere((m) => m['name'] == entry.key)['price'] as int)))}',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                ShadButton(
                  backgroundColor: const Color(0xFFFF4C00),
                  hoverBackgroundColor: const Color(0xFFE04300),
                  onPressed: () {
                    provider.placeCafeOrder(_selectedPickupTime);
                    ShadToaster.of(context).show(
                      const ShadToast(
                        title: Text('Pre-order Placed!'),
                        description: Text('Aadukalam Café has received your preorder recipe.'),
                      ),
                    );
                  },
                  child: Text(
                    'Place Café Order',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                const Icon(Icons.shopping_basket_outlined, size: 36, color: Color(0xFF94A3B8)),
                const SizedBox(height: 8),
                Text(
                  'Pre-order basket is empty',
                  style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // --- 5. Recovery Section ---
  Widget _buildRecoverySection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'Recovery Zone',
          subtitle: 'Thermal Recovery Pass',
          desc: 'Structured Wet/Dry Steam Baths, Infrared Saunas, and coach-supervised Ice Plunge Hydrotherapy to prevent fatigue.',
          imagePath: 'assets/steamone.jpg',
          accentColor: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Recovery Single Session passes',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        _buildPackageCard(
          title: 'Ice Bath Hydrotherapy',
          price: '₹500',
          desc: '15-min plunge session to relieve muscular microtrauma.',
          onTap: () {
            provider.setPlan('Ice Bath Session', subPlan: 'Single Pass');
            _showEnquiry();
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: 'Sauna / Steam Bath',
          price: '₹400',
          desc: '30-min sweating pass. Promotes blood flow and detox.',
          onTap: () {
            provider.setPlan('Sauna Session', subPlan: 'Single Pass');
            _showEnquiry();
          },
        ),
      ],
    );
  }

  // --- 6. Snooker Section ---
  Widget _buildSnookerSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'DUSA Snooker Zone',
          subtitle: 'Premium Slate Lounge',
          desc: 'Relax and unwind with tournament-size slates in a quiet, air-conditioned lounge. Perfect for recreational fun.',
          imagePath: 'assets/pooltable.jpg',
          accentColor: const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Snooker Table Rates',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        _buildPackageCard(
          title: 'Hourly Table Rental',
          price: '₹200',
          desc: 'Rent a single table slot. Snooker cues, chalk, and scoreboards provided.',
          onTap: () {
            provider.setPlan('Snooker Table Rental', subPlan: '1 Hour');
            _showEnquiry();
          },
        ),
      ],
    );
  }

  // --- 7. Table Tennis Section ---
  Widget _buildTableTennisSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(
          title: 'DUSA Table Tennis Zone',
          subtitle: 'ITTF Approved Pro Boards',
          desc: 'Play on premium indoor table tennis boards with high-end paddles and balls. Lockers and air-conditioned lounge access included.',
          imagePath: 'https://images.unsplash.com/photo-1534067783941-51c9c23eccfd?q=80&w=300',
          accentColor: const Color(0xFFFF4C00),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Table Tennis Rates & Coaching',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        _buildPackageCard(
          title: 'Hourly Table Booking',
          price: '₹150',
          desc: 'Reserve a table board for recreational play. Paddles and pro balls provided.',
          onTap: () {
            provider.setPlan('Table Tennis Board Booking', subPlan: '1 Hour');
            _showCheckout(
              planName: 'Table Tennis Booking',
              duration: '1 Hour',
              basePrice: 150,
              benefits: const [
                'ITTF approved table tennis board reservation',
                'Professional paddles and balls provided',
                'Air-conditioned playing floor access',
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: 'Monthly Academy Coaching',
          price: '₹2,500',
          desc: 'Weekly coach-guided training sessions for children and beginners.',
          onTap: () {
            provider.setPlan('Table Tennis Coaching', subPlan: '1 Month');
            _showCheckout(
              planName: 'Table Tennis Coaching',
              duration: '1 Month',
              basePrice: 2500,
              benefits: const [
                '4 coach-led table training sessions per week',
                'Video play analysis and footwork feedback',
                'Free board access during leisure hours',
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildPackageCard(
          title: 'Quarterly Table Pass',
          price: '₹5,999',
          desc: 'Get unlimited board bookings for three full months.',
          onTap: () {
            provider.setPlan('Table Tennis Pass', subPlan: '3 Months');
            _showCheckout(
              planName: 'Table Tennis Pass',
              duration: '3 Months',
              basePrice: 5999,
              benefits: const [
                'Unlimited table reservations for 3 months',
                'Advanced robot training board access',
                'Invite guests to play for free (1 guest/day)',
              ],
            );
          },
        ),
      ],
    );
  }

  // --- Supporting Widgets ---
  void _showEnquiry() {
    showDialog(
      context: context,
      builder: (context) => const EnquiryDialog(),
    );
  }

  void _showCheckout({
    required String planName,
    required String duration,
    required int basePrice,
    required List<String> benefits,
  }) {
    showDialog(
      context: context,
      builder: (context) => CheckoutPaymentDialog(
        planName: planName,
        duration: duration,
        basePrice: basePrice,
        benefits: benefits,
      ),
    );
  }

  Widget _buildHeaderCard({
    required String title,
    required String subtitle,
    required String desc,
    required String imagePath,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner photo
          Image.asset(
            imagePath,
            height: 130,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 130,
              color: const Color(0xFFE2E8F0),
              child: Icon(Icons.sports, color: accentColor),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: accentColor),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color fill, {required Color border}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildGridHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCourtCell(int courtNum, String time, BookingProvider provider) {
    final slotKey = 'Court ${courtNum}_$time';
    final isBooked = _simulatedBookedSlots.contains(slotKey);
    final isSelected = provider.selectedCourtSlots.contains(slotKey);
    
    Color cellColor = Colors.transparent;
    Color textColor = const Color(0xFF64748B);
    Color borderColor = const Color(0xFFE2E8F0);
    FontWeight weight = FontWeight.normal;
    
    if (isBooked) {
      cellColor = const Color(0xFFFFF0F0);
      textColor = const Color(0xFFEF4444);
      borderColor = const Color(0xFFEF4444).withOpacity(0.5);
      weight = FontWeight.bold;
    } else if (isSelected) {
      cellColor = const Color(0xFFFFF1EB);
      textColor = const Color(0xFFFF4C00);
      borderColor = const Color(0xFFFF4C00);
      weight = FontWeight.bold;
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: InkWell(
        onTap: isBooked ? null : () => provider.toggleCourtSlot(slotKey),
        child: Container(
          decoration: BoxDecoration(
            color: cellColor,
            border: Border.all(color: borderColor, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          alignment: Alignment.center,
          child: Text(
            isBooked ? 'Booked' : (isSelected ? 'Selected' : 'Available'),
            style: TextStyle(color: textColor, fontSize: 10, fontWeight: weight),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required String title,
    required String price,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4C00),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                  ),
                  onPressed: onTap,
                  child: Text('Enquire', style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
