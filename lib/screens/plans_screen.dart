import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../widgets/checkout_payment_dialog.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  String _selectedDuration = '1 Year'; // '3 Months', '6 Months', '1 Year'

  // Pricing configuration maps
  final Map<String, Map<String, int>> _membershipPrices = {
    'Gold': {
      '3 Months': 9999,
      '6 Months': 17999,
      '1 Year': 30000,
    },
    'Platinum': {
      '3 Months': 13999,
      '6 Months': 23999,
      '1 Year': 40000,
    },
    'Couple': {
      '3 Months': 19999,
      '6 Months': 34999,
      '1 Year': 60000,
    },
    'Family': {
      '3 Months': 29999,
      '6 Months': 49999,
      '1 Year': 85000,
    },
  };

  final Map<String, List<String>> _membershipBenefits = {
    'Gold': [
      'Gym Access (Strength & Cardio)',
      'Swimming Pool Access',
      'Zumba Fitness Sessions',
      'Recovery Sessions (Coach Supervised)',
      'Ice Bath Hydrotherapy',
      'Steam & Infrared Sauna Access',
    ],
    'Platinum': [
      'Badminton Court Access',
      'Gym Access (Strength & Cardio)',
      'Swimming Pool Access',
      'Snooker Table Access',
      'Zumba Fitness Sessions',
      'Recovery Sessions (Coach Supervised)',
      'Ice Bath Hydrotherapy',
      'Steam & Infrared Sauna Access',
    ],
    'Couple': [
      'Access for 2 Adults (Any gender)',
      'Badminton Court Access',
      'Gym Access (Strength & Cardio)',
      'Swimming Pool Access',
      'Snooker Table Access',
      'Zumba Fitness Sessions',
      'Recovery Sessions (Coach Supervised)',
      'Ice Bath Hydrotherapy',
      'Steam & Infrared Sauna Access',
    ],
    'Family': [
      'Access for 2 Adults + 2 Kids (Under 18)',
      'Badminton Court Access',
      'Gym Access (Strength & Cardio)',
      'Swimming Pool Access',
      'Snooker Table Access',
      'Zumba & Aerobics Sessions',
      'Recovery Sessions (Coach Supervised)',
      'Ice Bath Hydrotherapy',
      'Steam & Infrared Sauna Access',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/logo.png',
          height: 48,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFF4C00),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sports, color: Colors.white),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DUSA Membership Plans',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a duration tier below to customize facility access pricing.',
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),

            // Duration Toggle Selector
            Center(
              child: _buildDurationSelector(),
            ),
            const SizedBox(height: 24),
            
            // Core 4 Plans Stacked List for Generous Spacing
            Column(
              children: [
                _buildPlanCard('Gold', const Color(0xFFD97706), null),
                const SizedBox(height: 20),
                _buildPlanCard('Platinum', const Color(0xFF2563EB), 'Popular'),
                const SizedBox(height: 20),
                _buildPlanCard('Couple', const Color(0xFFDC2626), null),
                const SizedBox(height: 20),
                _buildPlanCard('Family', const Color(0xFF16A34A), 'Best Value'),
              ],
            ),
            
            const SizedBox(height: 36),
            Text(
              'Academy Coaching Packages',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Coaching Packages Stacked List
            Column(
              children: [
                _buildCoachingCard(
                  'Gym Coaching Package',
                  const Color(0xFF2563EB),
                  'Fitness',
                  15999,
                  [
                    'Strength Machine Training',
                    'Crossfit Workout Zone',
                    'High-Intensity Cardio Deck',
                    'Personal Training Assistance',
                  ],
                ),
                const SizedBox(height: 20),
                _buildCoachingCard(
                  'Badminton Academy',
                  const Color(0xFF7C3AED),
                  'Coaching',
                  24000,
                  [
                    'Professional Academy Coaching',
                    'Weekly Performance Tracking',
                    'Beginner to Advanced Skill Levels',
                    'Full Safety Supervision Included',
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Banner Message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFFF4C00)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All plans include access to changing rooms, showers & lockers.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final options = ['3 Months', '6 Months', '1 Year'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt == _selectedDuration;
          return GestureDetector(
            onTap: () => setState(() => _selectedDuration = opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Text(
                opt,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFFFF4C00) : const Color(0xFF475569),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanCard(String title, Color accentColor, String? tag) {
    final int price = _membershipPrices[title]![_selectedDuration]!;
    final List<String> benefits = _membershipBenefits[title]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image Banner Block (High Contrast, Premium Design)
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  title == 'Gold'
                      ? 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=300'
                      : title == 'Platinum'
                          ? 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=300'
                          : title == 'Couple'
                              ? 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300'
                              : 'https://images.unsplash.com/photo-1519315901367-f34ff9154487?q=80&w=300'
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_selectedDuration • ₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4C00),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '*Price exclusive of 18% GST (added at checkout).',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF4C00),
              ),
            ),
          ),

          // Features List (Rendered inside simple Column for adaptive breathing height)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, size: 15, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF475569),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ShadButton(
              backgroundColor: const Color(0xFFFF4C00),
              hoverBackgroundColor: const Color(0xFFE04300),
              onPressed: () {
                final provider = Provider.of<BookingProvider>(context, listen: false);
                provider.setPlan(title, subPlan: _selectedDuration);
                
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => CheckoutPaymentDialog(
                    planName: title,
                    duration: _selectedDuration,
                    basePrice: price,
                    benefits: benefits,
                    cameFromPlansScreen: true,
                  ),
                );
              },
              child: Text(
                'Subscribe Now',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingCard(String title, Color accentColor, String tag, int yearlyPrice, List<String> benefits) {
    // Dynamically calculate based on toggle
    int price = yearlyPrice;
    if (_selectedDuration == '3 Months') {
      price = (yearlyPrice * 0.35).toInt();
    } else if (_selectedDuration == '6 Months') {
      price = (yearlyPrice * 0.6).toInt();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image Banner Block (High Contrast, Premium Design)
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  title.contains('Gym')
                      ? 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=300'
                      : 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=300'
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_selectedDuration • ₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '*Price exclusive of 18% GST (added at checkout).',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF4C00),
              ),
            ),
          ),

          // Features List (Clean Column instead of ListView.builder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, size: 15, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF475569),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ShadButton(
              backgroundColor: const Color(0xFFFF4C00),
              hoverBackgroundColor: const Color(0xFFE04300),
              onPressed: () {
                final provider = Provider.of<BookingProvider>(context, listen: false);
                provider.setPlan(title, subPlan: _selectedDuration);
                
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => CheckoutPaymentDialog(
                    planName: title,
                    duration: _selectedDuration,
                    basePrice: price,
                    benefits: benefits,
                    cameFromPlansScreen: true,
                  ),
                );
              },
              child: Text(
                'Subscribe Now',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
