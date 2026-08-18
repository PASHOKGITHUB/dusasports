import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'home_screen.dart';
import 'facilities_hub_screen.dart';
import 'ai_concierge_screen.dart';
import 'dusa_play_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int tabIndex, [int categoryIndex = 0]) {
    Provider.of<BookingProvider>(context, listen: false).setFacilityTab(categoryIndex);
    setState(() => _currentIndex = tabIndex);
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => const _NotificationsSheet(),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('DUSA AI Concierge', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFE2E8F0), height: 1),
          ),
        ),
        body: const AiConciergeScreen(),
      )),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A), size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('My Profile', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFE2E8F0), height: 1),
          ),
        ),
        body: const ProfileScreen(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    if (provider.isAdminMode) {
      return const AdminDashboardScreen();
    }

    final List<Widget> pages = [
      HomeScreen(onCategoryTap: _navigateToTab),
      const FacilitiesHubScreen(),
      const DusaPlayScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Prominent Big Logo
                Image.asset(
                  'assets/logo.png',
                  height: 64,
                  width: 64,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (c, e, s) => Container(
                    width: 56, height: 56,
                    decoration: const BoxDecoration(color: Color(0xFFFF4C00), shape: BoxShape.circle),
                    child: const Icon(Icons.sports, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(width: 12),

                // Greeting & Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Hi, ${provider.profileName.split(' ').first} 👋',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (provider.activeMembership != 'No Active Plan') ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4C00).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.2), width: 0.8),
                              ),
                              child: Text(
                                provider.activeMembership.split(' ').first.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF4C00),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Color(0xFFFF4C00)),
                          const SizedBox(width: 2),
                          Text('DUSA Sports Academy, Madurai', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notification Bell (Only notification icon in header)
                GestureDetector(
                  onTap: _showNotifications,
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Stack(
                      children: [
                        const Center(child: Icon(Icons.notifications_outlined, color: Color(0xFF475569), size: 21)),
                        Positioned(
                          right: 7, top: 7,
                          child: Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4C00),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: IndexedStack(
            key: ValueKey(_currentIndex),
            index: _currentIndex,
            children: pages,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChat,
        backgroundColor: const Color(0xFF0F172A),
        shape: const CircleBorder(),
        elevation: 6,
        child: Image.asset(
          'assets/machine-learning.png',
          height: 26,
          width: 26,
          fit: BoxFit.contain,
          color: Colors.white,
          errorBuilder: (c, e, s) => const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                _buildNavItem(1, Icons.explore_outlined, Icons.explore, 'Explore'),
                _buildNavItem(2, Icons.sports_esports_outlined, Icons.sports_esports, 'Play'),
                _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF4C00).withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFFFF4C00) : const Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? const Color(0xFFFF4C00) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// NOTIFICATIONS BOTTOM SHEET
// ═══════════════════════════════════════════
class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotifItem(Icons.check_circle, const Color(0xFF16A34A), 'Court Booking Confirmed', 'Your badminton court 2 slot (6-7 PM) is confirmed for tomorrow.', '2 min ago', true),
      _NotifItem(Icons.emoji_events, const Color(0xFFD97706), 'Independence Cup 2026', 'Registration is now open for the DUSA Independence Badminton Cup. Sign up today!', '15 min ago', true),
      _NotifItem(Icons.local_offer, const Color(0xFFFF4C00), 'First Month GYM FREE!', 'Sign up for any annual plan and get your first month gym access absolutely free.', '1 hour ago', false),
      _NotifItem(Icons.restaurant, const Color(0xFF06B6D4), 'Café Order Ready', 'Your Whey Protein Shake is ready for pickup at the Aadukalam counter.', '3 hours ago', false),
      _NotifItem(Icons.people, const Color(0xFF7C3AED), 'New Match Challenge', 'Arun Kumar has challenged you to a badminton match tomorrow at 6 PM.', '5 hours ago', false),
      _NotifItem(Icons.camera_alt, const Color(0xFFEC4899), 'Tournament Photos Available', 'Your 3 photos from the Weekend League have been matched. Download now!', 'Yesterday', false),
      _NotifItem(Icons.fitness_center, const Color(0xFF2563EB), 'Streak Milestone! 🔥', 'Amazing! You\'ve hit a 7-day gym streak. Keep the momentum going!', 'Yesterday', false),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Mark all read', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00))),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE2E8F0), height: 1),

            // Notifications list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.isNew ? const Color(0xFFFF4C00).withOpacity(0.03) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: n.isNew ? const Color(0xFFFF4C00).withOpacity(0.15) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: n.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n.icon, color: n.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(n.title, style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                                  ),
                                  if (n.isNew)
                                    Container(
                                      width: 8, height: 8,
                                      decoration: const BoxDecoration(color: Color(0xFFFF4C00), shape: BoxShape.circle),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(n.body, style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B), height: 1.35), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Text(n.time, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool isNew;
  const _NotifItem(this.icon, this.color, this.title, this.body, this.time, this.isNew);
}
