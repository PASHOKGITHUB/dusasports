import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showQrCode = false;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BookingProvider>(context, listen: false);
    _nameController.text = provider.profileName;
    _mobileController.text = provider.profileMobile;
    _emailController.text = provider.profileEmail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog(BookingProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit Profile Info',
            style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShadInput(
                  controller: _nameController,
                  placeholder: const Text('Name'),
                  style: GoogleFonts.inter(color: const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                ShadInput(
                  controller: _mobileController,
                  placeholder: const Text('Mobile'),
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(color: const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                ShadInput(
                  controller: _emailController,
                  placeholder: const Text('Email'),
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.inter(color: const Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          actions: [
            ShadButton.outline(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF0F172A))),
            ),
            ShadButton(
              backgroundColor: const Color(0xFFFF4C00),
              hoverBackgroundColor: const Color(0xFFE04300),
              onPressed: () {
                provider.updateProfile(
                  name: _nameController.text,
                  mobile: _mobileController.text,
                  email: _emailController.text,
                );
                Navigator.pop(context);
                ShadToaster.of(context).show(
                  const ShadToast(
                    title: Text('Profile Updated!'),
                    description: Text('Your changes have been saved successfully.'),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 0. ADMIN MODE SWITCHER BANNER CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.6), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4C00).withOpacity(0.15),
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
                        color: const Color(0xFFFF4C00).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFFF4C00), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Console Mode',
                          style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          provider.isAdminMode ? 'Active: Executive Admin View' : 'Switch to view revenue & reports',
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: provider.isAdminMode,
                  activeColor: const Color(0xFFFF4C00),
                  activeTrackColor: const Color(0xFFFF4C00).withOpacity(0.3),
                  inactiveThumbColor: const Color(0xFF94A3B8),
                  inactiveTrackColor: const Color(0xFF334155),
                  onChanged: (val) {
                    provider.toggleAdminMode();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val ? 'Switched to Executive Admin Console ⚡' : 'Switched to Member View 👋'),
                        backgroundColor: const Color(0xFFFF4C00),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Digital Membership Card (Swiggy Premium gradient)
          _buildMembershipCard(provider),
          const SizedBox(height: 20),

          // QR Code check-in drawer
          if (_showQrCode) _buildQrCheckinArea(),
          const SizedBox(height: 24),

          // 2. Streaks and Gamification
          _buildGamificationSection(provider),
          const SizedBox(height: 24),

          // 3. Active Café Orders List
          if (provider.cafeOrders.isNotEmpty) ...[
            _buildCafeOrdersList(provider),
            const SizedBox(height: 24),
          ],

          // 4. Submitted Enquiries History Log
          _buildEnquiriesLog(provider),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BookingProvider provider) {
    return Column(
      children: [
        // Main Membership Card
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF1EB), Color(0xFFFFE3D5), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFFF4C00).withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DUSA MEMBER ID',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: const Color(0xFFFF4C00),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.memberId,
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Color(0xFFFF4C00)),
                    onPressed: () => _showEditProfileDialog(provider),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Member details
              Text(
                provider.profileName,
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                provider.profileMobile,
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
              ),
              if (provider.profileEmail.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  provider.profileEmail,
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                ),
              ],
              const SizedBox(height: 16),
              
              // Membership plan & QR button
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.activeMembership,
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF16A34A), fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4C00),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        _showQrCode = !_showQrCode;
                      });
                    },
                    icon: const Icon(Icons.qr_code, size: 16, color: Colors.white),
                    label: Text(
                      _showQrCode ? 'Hide QR' : 'Check-In QR',
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Active Court Bookings Card
        if (provider.selectedCourtSlots.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sports_tennis, color: Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text('Active Court Bookings', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 12),
                ...provider.selectedCourtSlots.map((slot) {
                  final parts = slot.split('_');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 14, color: Color(0xFF16A34A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            parts.length == 2 ? '${parts[0]} • ${parts[1]}' : slot,
                            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

        // Upcoming Events Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD97706).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.emoji_events, color: Color(0xFFD97706), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text('Upcoming Events', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                ],
              ),
              const SizedBox(height: 12),
              _buildEventRow('Independence Badminton Cup', 'Aug 15–18', const Color(0xFF16A34A), 'Open'),
              const SizedBox(height: 8),
              _buildEventRow('Madurai Open Pickleball', 'Sep 05', const Color(0xFFD97706), 'Soon'),
              const SizedBox(height: 8),
              _buildEventRow('DUSA Fitness Challenge', 'Sep 20–21', const Color(0xFF7C3AED), 'Teaser'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventRow(String name, String date, Color color, String status) {
    return Row(
      children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A))),
        ),
        Text(date, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
          child: Text(status, style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }


  Widget _buildQrCheckinArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Text(
            'Check-In QR Code',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan this QR code at DUSA entrance turnstile to check-in.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          // Mock QR Code Block
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Text(
            'Valid for today • Auto-expires in 5 hrs',
            style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationSection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Streaks & Badges',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildStreakTile(
                title: 'Gym Streak',
                value: '${provider.gymStreak} Days',
                icon: Icons.local_fire_department,
                accentColor: const Color(0xFFFF4C00),
                onTap: () {
                  provider.incrementGymStreak();
                  ShadToaster.of(context).show(
                    const ShadToast(
                      title: Text('Gym Workout Logged!'),
                      description: Text('Your gym streak has been incremented.'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStreakTile(
                title: 'Badminton',
                value: '${provider.badmintonStreak} Games',
                icon: Icons.sports_tennis_outlined,
                accentColor: const Color(0xFF2563EB),
                onTap: () {
                  provider.incrementBadmintonStreak();
                  ShadToaster.of(context).show(
                    const ShadToast(
                      title: Text('Badminton game logged!'),
                      description: Text('Your match count has been updated.'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Badges row
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
              Text(
                'Unlocked Badges (${provider.unlockedBadges.length})',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: provider.unlockedBadges.map((badgeName) {
                  IconData icon = Icons.workspace_premium;
                  Color color = const Color(0xFFFF4C00);
                  if (badgeName == 'Early Bird') {
                    icon = Icons.wb_sunny_outlined;
                    color = const Color(0xFFD97706);
                  } else if (badgeName == 'Gym Warrior') {
                    icon = Icons.fitness_center;
                    color = const Color(0xFF2563EB);
                  } else if (badgeName == 'Hydration Hero') {
                    icon = Icons.local_drink;
                    color = const Color(0xFF06B6D4);
                  }
                  
                  return Tooltip(
                    message: badgeName,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          badgeName,
                          style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakTile({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 20),
              Text(
                value,
                style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor.withOpacity(0.08),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: onTap,
              child: Text(
                'Log Session',
                style: GoogleFonts.outfit(fontSize: 10, color: accentColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCafeOrdersList(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Café Orders',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        ...provider.cafeOrders.map((order) {
          final String orderId = (order['orderId'] ?? order['id'] ?? 'ORD-000').toString();
          final String status = (order['status'] ?? 'Completed').toString();
          final String itemText = (order['item'] ?? (order['items'] != null ? order['items'].toString() : 'Café Item')).toString();
          final String dateText = (order['date'] ?? order['time'] ?? 'Today').toString();
          final String amount = (order['amount'] ?? '').toString();

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderId,
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFFF4C00)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFFD97706)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• $itemText ${amount.isNotEmpty ? "($amount)" : ""}',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: $dateText',
                  style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEnquiriesLog(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Enquiry & Booking Logs',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        if (provider.enquiries.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Text(
                'No recent enquiries found.',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.enquiries.length,
            itemBuilder: (context, index) {
              final enq = provider.enquiries[index];
              final String title = (enq['category'] ?? enq['plan'] ?? 'General Enquiry').toString();
              final String status = (enq['status'] ?? 'Pending').toString();
              final String note = (enq['note'] ?? enq['subPlan'] ?? '').toString();
              final String dateStr = (enq['date'] ?? (enq['timestamp'] != null ? enq['timestamp'].toString() : 'Today')).toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A)),
                          ),
                        ),
                      ],
                    ),
                    if (note.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Details: $note',
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'Logged: $dateStr',
                      style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
